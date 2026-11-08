package ai.amazingbank.gateway.auth;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.annotation.PostConstruct;
import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.MessageDigest;
import java.security.spec.KeySpec;
import java.util.HexFormat;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * 网关用户表：启动时一次性加载 gateway_users.json（P0.3 产物）。
 *
 * <p>路径契约（两侧声明，见 Phase P2 任务 P2.2）：
 * <ul>
 *   <li>dev / bootRun：默认相对网关工程工作目录（$GW/../../data），
 *       env {@code ABNK_USERS_FILE} 可覆盖为绝对路径</li>
 *   <li>容器形态（P3.4）：Dockerfile 打包至 {@code /app/data/gateway_users.json}
 *       并以 env 默认值注入同一变量</li>
 * </ul>
 */
@Component
public class UsersStore {

    private static final Logger log = LoggerFactory.getLogger(UsersStore.class);

    private final Map<String, GatewayUser> usersByUsername = new ConcurrentHashMap<>();

    private final Path usersFile;

    public UsersStore(@Value("${abnk.users.file}") String usersFile) {
        this.usersFile = Path.of(usersFile);
    }

    @PostConstruct
    void load() {
        if (!Files.isReadable(usersFile)) {
            throw new IllegalStateException("gateway users file not readable: " + usersFile.toAbsolutePath());
        }
        try {
            UsersFile parsed = new ObjectMapper().readValue(Files.readString(usersFile), UsersFile.class);
            parsed.users().forEach(user -> usersByUsername.put(user.username(), user));
            log.info("Loaded {} gateway users from {}", usersByUsername.size(), usersFile.toAbsolutePath());
        } catch (IOException e) {
            throw new UncheckedIOException("failed to parse gateway users file: " + usersFile, e);
        }
    }

    public Optional<GatewayUser> find(String username) {
        if (username == null) {
            return Optional.empty();
        }
        return Optional.ofNullable(usersByUsername.get(username));
    }

    /**
     * PBKDF2 口令校验，按 P0.3 定死的跨端契约手工实现：
     * PBKDF2WithHmacSHA256(口令 UTF-8, salt 字节, iterations=100000, dklen=32) 输出 hex、无 pepper。
     *
     * <p>刻意不用 Spring {@code PBKDF2PasswordEncoder}：其内置 {pbkdf2} 前缀 + base64(salt‖hash)
     * 单串格式与本 JSON 的分离字段不兼容，算法/迭代数也不透明。
     */
    public boolean verifyPassword(GatewayUser user, String password) {
        if (password == null || user.salt() == null || user.passwordHash() == null) {
            return false;
        }
        try {
            int iterations = user.iterations() != null ? user.iterations() : 100_000;
            // dklen 固定 32 字节（hash 契约；hex 长度 64）
            KeySpec spec = new PBEKeySpec(password.toCharArray(),
                    HexFormat.of().parseHex(user.salt()), iterations, 32 * 8);
            SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
            byte[] calculated = factory.generateSecret(spec).getEncoded();
            byte[] expected = HexFormat.of().parseHex(user.passwordHash());
            return MessageDigest.isEqual(calculated, expected);
        } catch (Exception e) {
            log.warn("PBKDF2 verification error for user {}", user.username(), e);
            return false;
        }
    }

    /**
     * 通道判定：有 clientId → customer；无 clientId（如 admin）→ internal。
     * admin 无 clientId 时 JWT sub 落 username（内部通道不依赖 clientId 反查）。
     */
    public static String channelOf(GatewayUser user) {
        return user.clientId() != null ? "customer" : "internal";
    }

    public static String subjectOf(GatewayUser user) {
        return user.clientId() != null ? String.valueOf(user.clientId()) : user.username();
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    record UsersFile(String algorithm, Integer iterations, Integer dklen, String pepper,
            String hashContract, List<GatewayUser> users) {
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    record GatewayUser(String username, Long clientId, String algorithm, Integer iterations, String salt,
            @JsonProperty("password_hash") String passwordHash) {
    }
}
