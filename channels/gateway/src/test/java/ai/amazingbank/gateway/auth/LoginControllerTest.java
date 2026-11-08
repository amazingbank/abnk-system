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
 * 正/误口令、未知用户、admin 无 clientId 三类分支。
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
    void loginSuccessIssuesCustomerToken() {
        webTestClient.post().uri("/login")
                .bodyValue(new LoginController.LoginRequest("alice", "correct-password"))
                .exchange()
                .expectStatus().isOk()
                .expectBody()
                .jsonPath("$.token").value(token -> assertThat(((String) token).split("\\.")).hasSize(3))
                .jsonPath("$.channel").isEqualTo("customer")
                .jsonPath("$.sub").isEqualTo("28")
                .jsonPath("$.expiresIn").isEqualTo(900);

        // token 可被同一密钥解析（sub / channel 断言）
        String token = loginToken("alice", "correct-password");
        JwtService.AuthToken parsed = jwtService.parse(token);
        assertThat(parsed.sub()).isEqualTo("28");
        assertThat(parsed.channel()).isEqualTo("customer");
    }

    @Test
    void adminHasNoClientSubFallsBackToUsernameAsInternal() {
        webTestClient.post().uri("/login")
                .bodyValue(new LoginController.LoginRequest("admin", "admin-password"))
                .exchange()
                .expectStatus().isOk()
                .expectBody()
                .jsonPath("$.channel").isEqualTo("internal")
                .jsonPath("$.sub").isEqualTo("admin");
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
}
