package ai.amazingbank.gateway.auth;

import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import reactor.core.publisher.Mono;

/**
 * 简化登录端点（D2 口径，P2.6 契约对齐）：双通道登录入口。
 *
 * <ul>
 *   <li>POST /login —— 对客登录（契约 Auth·对客）：仅 customer 用户，签发 HS256 JWT
 *       （claim：sub=clientId、channel="customer"），响应契约 LoginResponse。</li>
 *   <li>POST /bo/login —— 内部登录（契约 Auth·内部）：仅 internal 用户（admin 无 clientId），
 *       签发 channel="internal" token（sub=username），响应契约 BoLoginResponse。</li>
 * </ul>
 *
 * <p>通道严格匹配（P2.6 契约一致性口径——契约响应 channel enum 均为单值）：
 * admin 打 /login、alice 打 /bo/login 一律 401（invalid_credentials），不得跨通道签发。
 *
 * <p>失败 401：统一载荷 {"error":"invalid_credentials"}。
 */
@RestController
public class LoginController {

    public record LoginRequest(String username, String password) {
    }

    /** 契约 LoginResponse（对客——channel 固定 "customer"）。 */
    public record LoginResponse(String token, String tokenType, long expiresIn, String channel,
            String username, String displayName, Long clientId) {
    }

    /** 契约 BoLoginResponse（内部——channel 固定 "internal"；role 基线单一 ADMIN）。 */
    public record BoLoginResponse(String token, String tokenType, long expiresIn, String channel,
            String username, String displayName, String role) {
    }

    private static final Map<String, Object> INVALID_CREDENTIALS = Map.of("error", "invalid_credentials");

    private final UsersStore users;
    private final JwtService jwt;

    public LoginController(UsersStore users, JwtService jwt) {
        this.users = users;
        this.jwt = jwt;
    }

    @Operation(responses = @ApiResponse(responseCode = "200",
            content = @Content(schema = @Schema(implementation = LoginResponse.class))))
    @PostMapping("/login")
    public Mono<ResponseEntity<Object>> login(@RequestBody(required = false) LoginRequest request) {
        return authenticate(request, JwtService.CHANNEL_CUSTOMER);
    }

    @Operation(responses = @ApiResponse(responseCode = "200",
            content = @Content(schema = @Schema(implementation = BoLoginResponse.class))))
    @PostMapping("/bo/login")
    public Mono<ResponseEntity<Object>> boLogin(@RequestBody(required = false) LoginRequest request) {
        return authenticate(request, JwtService.CHANNEL_INTERNAL);
    }

    /** 凭据校验 + 通道匹配（跨通道用户不签发——401 与凭据错误同载荷，不泄露通道语义）。 */
    private Mono<ResponseEntity<Object>> authenticate(LoginRequest request, String channel) {
        String username = request == null ? null : request.username();
        String password = request == null ? null : request.password();
        var found = users.find(username == null ? "" : username)
                .filter(user -> channel.equals(UsersStore.channelOf(user)))
                .filter(user -> users.verifyPassword(user, password));
        if (found.isEmpty()) {
            return Mono.just(ResponseEntity.status(HttpStatus.UNAUTHORIZED).body((Object) INVALID_CREDENTIALS));
        }
        var user = found.get();
        String token = jwt.issue(UsersStore.subjectOf(user), UsersStore.channelOf(user));
        Object body;
        if (JwtService.CHANNEL_INTERNAL.equals(channel)) {
            body = new BoLoginResponse(token, "Bearer", jwt.ttlSeconds(), JwtService.CHANNEL_INTERNAL,
                    user.username(), UsersStore.displayNameOf(user), "ADMIN");
        } else {
            body = new LoginResponse(token, "Bearer", jwt.ttlSeconds(), JwtService.CHANNEL_CUSTOMER,
                    user.username(), UsersStore.displayNameOf(user), user.clientId());
        }
        return Mono.just(ResponseEntity.ok(body));
    }
}
