package ai.amazingbank.gateway.customer;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.autoconfigure.web.reactive.AutoConfigureWebTestClient;
import org.springframework.test.web.reactive.server.WebTestClient;

/**
 * 对客通道黑名单 / 收敛单测（P2.3；无 token——BlacklistFilter order 在 BearerTokenFilter 之后，
 * 本组专注 filter 自身语义，鉴权路径由 MeControllerTest 覆盖）。
 *
 * <p>注意：无 token 请求在 BearerTokenFilter(-100) 已 401 短路，无法直接观测 403/404——
 * 因此本组请求全部携带 token（登录态用户），验证黑名单三路径与收敛 404 的 filter 语义。
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.MOCK)
@AutoConfigureWebTestClient
class BlacklistFilterTest {

    @Autowired
    WebTestClient webTestClient;

    @Autowired
    ai.amazingbank.gateway.auth.JwtService jwtService;

    private WebTestClient.RequestHeadersSpec<?> get(String uri) {
        return webTestClient.get().uri(uri)
                .headers(h -> h.setBearerAuth(jwtService.issue("28", ai.amazingbank.gateway.auth.JwtService.CHANNEL_CUSTOMER)));
    }

    @Test
    void jobsPathForbidden() {
        get("/abnk/api/v1/jobs").exchange().expectStatus().isForbidden()
                .expectBody().jsonPath("$.error").isEqualTo("forbidden");
    }

    @Test
    void internalPathForbidden() {
        get("/abnk/api/v1/internal/cache/evict").exchange().expectStatus().isForbidden()
                .expectBody().jsonPath("$.error").isEqualTo("forbidden");
    }

    @Test
    void configurationsPathForbidden() {
        get("/abnk/api/v1/configurations/44").exchange().expectStatus().isForbidden();
    }

    @Test
    void nonContractPathYields404() {
        // 非契约路径（loans/{id}/command——command 族属内部通道契约）
        get("/abnk/api/v1/loans/999/command").exchange().expectStatus().isNotFound()
                .expectBody().jsonPath("$.error").isEqualTo("not_found");
    }

    @Test
    void legacyForwardingPathCollapsedTo404() {
        // 骨架期（P2.1）曾全量转发的 /offices——P2.3 收敛后契约外 → 404
        get("/abnk/api/v1/offices").exchange().expectStatus().isNotFound();
    }

    @Test
    void nonContractMethodYields404() {
        // 契约内路径但方法不在契约（PUT /me）
        webTestClient.put().uri("/abnk/api/v1/me")
                .headers(h -> h.setBearerAuth(jwtService.issue("28", ai.amazingbank.gateway.auth.JwtService.CHANNEL_CUSTOMER)))
                .exchange().expectStatus().isNotFound();
    }
}
