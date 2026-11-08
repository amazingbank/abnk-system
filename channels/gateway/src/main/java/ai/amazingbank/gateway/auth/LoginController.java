package ai.amazingbank.gateway.auth;

import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

/**
 * 简化登录端点（D2 口径）：POST /login → PBKDF2 校验 → 签发 HS256 JWT（Bearer 形态）。
 *
 * <p>响应 200：token（JWT 三段式）+ channel + sub + expiresIn；
 * 失败 401：统一载荷 {"error":"invalid_credentials"}。
 */
@RestController
public class LoginController {

    public record LoginRequest(String username, String password) {
    }

    public record LoginResponse(String token, String channel, String sub, long expiresIn) {
    }

    private static final Map<String, Object> INVALID_CREDENTIALS = Map.of("error", "invalid_credentials");

    private final UsersStore users;
    private final JwtService jwt;

    public LoginController(UsersStore users, JwtService jwt) {
        this.users = users;
        this.jwt = jwt;
    }

    @PostMapping("/login")
    public Mono<ResponseEntity<Object>> login(@RequestBody(required = false) LoginRequest request) {
        String username = request == null ? null : request.username();
        String password = request == null ? null : request.password();
        var found = users.find(username == null ? "" : username)
                .filter(user -> users.verifyPassword(user, password));
        if (found.isEmpty()) {
            return Mono.just(ResponseEntity.status(HttpStatus.UNAUTHORIZED).body((Object) INVALID_CREDENTIALS));
        }
        var user = found.get();
        return Mono.just(ResponseEntity.ok((Object) new LoginResponse(
                jwt.issue(UsersStore.subjectOf(user), UsersStore.channelOf(user)),
                UsersStore.channelOf(user),
                UsersStore.subjectOf(user),
                jwt.ttlSeconds())));
    }
}
