package ai.amazingbank.gateway.auth;

import static org.assertj.core.api.Assertions.assertThat;

import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.time.ZoneOffset;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.reactive.WebFluxTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Import;
import org.springframework.test.web.reactive.server.WebTestClient;

/**
 * 登录端点单测：真实 UsersStore（fixture PBKDF2 数据，自造口令）+ 固定时钟 JwtService。
 * P2.6 契约对齐断言：LoginResponse / BoLoginResponse 全字段、双通道严格匹配（跨通道 401）。
 */
@WebFluxTest(controllers = LoginController.class)
@Import({ SecurityConfig.class, LoginControllerTest.TestBeans.class })
class LoginControllerTest {

    private static final String FIXTURE = "src/test/resources/auth/test-users.json";
    private static final Instant NOW = Instant.parse("2026-11-08T00:00:00Z");

    @Autowired
    WebTestClient webTestClient;

    @Autowired
    JwtService jwtService;

    @TestConfiguration
    static class TestBeans {

        @Bean
        UsersStore usersStore() {
            UsersStore store = new UsersStore(FIXTURE);
            store.load();
            return store;
        }

        @Bean
        JwtService jwtService() {
            return new JwtService("unit-test-jwt-secret-0123456789abcdef",
                    Duration.ofMinutes(15), Clock.fixed(NOW, ZoneOffset.UTC));
        }
    }

    @Test
    void loginSuccessIssuesCustomerTokenWithContractFields() {
        webTestClient.post().uri("/login")
                .bodyValue(new LoginController.LoginRequest("alice", "correct-password"))
                .exchange()
                .expectStatus().isOk()
                .expectBody()
                .jsonPath("$.token").value(token -> assertThat(((String) token).split("\\.")).hasSize(3))
                .jsonPath("$.tokenType").isEqualTo("Bearer")
                .jsonPath("$.expiresIn").isEqualTo(900)
                .jsonPath("$.channel").isEqualTo("customer")
                .jsonPath("$.username").isEqualTo("alice")
                .jsonPath("$.displayName").isEqualTo("王 POC-A")
                .jsonPath("$.clientId").isEqualTo(28);

        // token 可被同一密钥解析（sub / channel 断言）
        String token = loginToken("alice", "correct-password");
        JwtService.AuthToken parsed = jwtService.parse(token);
        assertThat(parsed.sub()).isEqualTo("28");
        assertThat(parsed.channel()).isEqualTo("customer");
    }

    @Test
    void boLoginIssuesInternalTokenWithContractFields() {
        webTestClient.post().uri("/bo/login")
                .bodyValue(new LoginController.LoginRequest("admin", "admin-password"))
                .exchange()
                .expectStatus().isOk()
                .expectBody()
                .jsonPath("$.token").value(token -> assertThat(((String) token).split("\\.")).hasSize(3))
                .jsonPath("$.tokenType").isEqualTo("Bearer")
                .jsonPath("$.expiresIn").isEqualTo(900)
                .jsonPath("$.channel").isEqualTo("internal")
                .jsonPath("$.username").isEqualTo("admin")
                .jsonPath("$.displayName").isEqualTo("运营管理员")
                .jsonPath("$.role").isEqualTo("ADMIN");

        String token = boLoginToken("admin", "admin-password");
        JwtService.AuthToken parsed = jwtService.parse(token);
        assertThat(parsed.sub()).isEqualTo("admin");
        assertThat(parsed.channel()).isEqualTo("internal");
    }

    @Test
    void internalUserOnCustomerLoginRejected() {
        // 通道严格匹配（契约 channel enum 单值）：admin 打 /login → 401
        webTestClient.post().uri("/login")
                .bodyValue(new LoginController.LoginRequest("admin", "admin-password"))
                .exchange()
                .expectStatus().isUnauthorized()
                .expectBody()
                .jsonPath("$.error").isEqualTo("invalid_credentials");
    }

    @Test
    void customerUserOnBoLoginRejected() {
        // alice 打 /bo/login → 401（不跨通道签发）
        webTestClient.post().uri("/bo/login")
                .bodyValue(new LoginController.LoginRequest("alice", "correct-password"))
                .exchange()
                .expectStatus().isUnauthorized()
                .expectBody()
                .jsonPath("$.error").isEqualTo("invalid_credentials");
    }

    @Test
    void wrongPasswordRejected() {
        webTestClient.post().uri("/login")
                .bodyValue(new LoginController.LoginRequest("alice", "wrong-password"))
                .exchange()
                .expectStatus().isUnauthorized()
                .expectBody()
                .jsonPath("$.error").isEqualTo("invalid_credentials");
    }

    @Test
    void unknownUserRejected() {
        webTestClient.post().uri("/login")
                .bodyValue(new LoginController.LoginRequest("nobody", "correct-password"))
                .exchange()
                .expectStatus().isUnauthorized()
                .expectBody()
                .jsonPath("$.error").isEqualTo("invalid_credentials");
    }

    private String loginToken(String username, String password) {
        return webTestClient.post().uri("/login")
                .bodyValue(new LoginController.LoginRequest(username, password))
                .exchange()
                .expectStatus().isOk()
                .expectBody(LoginController.LoginResponse.class)
                .returnResult()
                .getResponseBody()
                .token();
    }

    private String boLoginToken(String username, String password) {
        return webTestClient.post().uri("/bo/login")
                .bodyValue(new LoginController.LoginRequest(username, password))
                .exchange()
                .expectStatus().isOk()
                .expectBody(LoginController.BoLoginResponse.class)
                .returnResult()
                .getResponseBody()
                .token();
    }
}
