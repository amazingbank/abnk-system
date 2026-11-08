package ai.amazingbank.gateway.internal;

import ai.amazingbank.gateway.auth.BearerTokenFilter;
import ai.amazingbank.gateway.auth.JwtService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.reactive.AutoConfigureWebTestClient;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpStatus;
import org.springframework.mock.http.server.reactive.MockServerHttpRequest;
import org.springframework.mock.web.server.MockServerWebExchange;
import org.springframework.test.web.reactive.server.WebTestClient;
import org.springframework.web.server.WebFilterChain;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * 通道隔离单测（P2.5）：customer token 打 bo 面 403、admin（internal）token 放行、
 * fineract.json 404。
 *
 * <p>两层覆盖：
 * <ul>
 *   <li>filter 直测（MockServerWebExchange + 桩链）——放行语义以「链被调用」为准，
 *       桩链写 200 代表 SCG 转发发生（不触真实下游，保持单测密闭）</li>
 *   <li>全链路 WebTestClient（真实 JWT + WebFilter 链）——403/401/404 短路发生在路由
 *       匹配之前，不触下游；internal token 的 200 放行由 VP2.5.2 运行时判据承载
 *       （MOCK 环境下 SCG 会真实转发，故不在本组发起 internal token 的 bo 请求）</li>
 * </ul>
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.MOCK)
@AutoConfigureWebTestClient
class BoRouteFilterTest {

    @Autowired
    WebTestClient webTestClient;

    @Autowired
    JwtService jwtService;

    private final BoRouteFilter filter = new BoRouteFilter();

    /** 桩链：链被调用即视为放行（写 200，代表请求交由 SCG 转发）。 */
    private static WebFilterChain passThroughChain() {
        return exchange -> {
            exchange.getResponse().setStatusCode(HttpStatus.OK);
            return exchange.getResponse().setComplete();
        };
    }

    private static MockServerWebExchange exchange(String method, String uri, String channel) {
        MockServerWebExchange exchange = MockServerWebExchange.from(
                MockServerHttpRequest.method(method, uri).build());
        if (channel != null) {
            exchange.getAttributes().put(BearerTokenFilter.ATTR_CHANNEL, channel);
        }
        return exchange;
    }

    // ── filter 直测：三类隔离用例 ──────────────────────────────

    @Test
    void customerTokenOnBoChannelForbidden() {
        MockServerWebExchange exchange = exchange("GET", "/bo/api/v1/clients",
                JwtService.CHANNEL_CUSTOMER);
        filter.filter(exchange, passThroughChain()).block();
        assertEquals(HttpStatus.FORBIDDEN, exchange.getResponse().getStatusCode());
    }

    @Test
    void internalTokenPassesThrough() {
        MockServerWebExchange exchange = exchange("GET", "/bo/api/v1/clients?limit=10",
                JwtService.CHANNEL_INTERNAL);
        filter.filter(exchange, passThroughChain()).block();
        assertEquals(HttpStatus.OK, exchange.getResponse().getStatusCode());
    }

    @Test
    void fineractJsonBlockedOnInternalChannel() {
        MockServerWebExchange exchange = exchange("GET", "/bo/api/v1/fineract.json",
                JwtService.CHANNEL_INTERNAL);
        filter.filter(exchange, passThroughChain()).block();
        assertEquals(HttpStatus.NOT_FOUND, exchange.getResponse().getStatusCode());
    }

    // ── filter 直测：放行矩阵余项 ─────────────────────────────

    @Test
    void jobsAllowedOnInternalChannel() {
        // jobs / configurations 对内合法（运维操作属 Backoffice 职责）
        MockServerWebExchange exchange = exchange("GET", "/bo/api/v1/jobs",
                JwtService.CHANNEL_INTERNAL);
        filter.filter(exchange, passThroughChain()).block();
        assertEquals(HttpStatus.OK, exchange.getResponse().getStatusCode());
    }

    @Test
    void configurationsAllowedOnInternalChannel() {
        MockServerWebExchange exchange = exchange("GET", "/bo/api/v1/configurations",
                JwtService.CHANNEL_INTERNAL);
        filter.filter(exchange, passThroughChain()).block();
        assertEquals(HttpStatus.OK, exchange.getResponse().getStatusCode());
    }

    @Test
    void missingChannelAttributeBlocked() {
        // BearerTokenFilter 异常路径防御：无通道属性按非 internal 处理
        MockServerWebExchange exchange = exchange("GET", "/bo/api/v1/clients", null);
        filter.filter(exchange, passThroughChain()).block();
        assertEquals(HttpStatus.FORBIDDEN, exchange.getResponse().getStatusCode());
    }

    @Test
    void nonBoPathsUntouched() {
        // 非 /bo/api/ 前缀不归本过滤器管（对客面走 BlacklistFilter）
        MockServerWebExchange exchange = exchange("GET", "/abnk/api/v1/me",
                JwtService.CHANNEL_CUSTOMER);
        filter.filter(exchange, passThroughChain()).block();
        assertEquals(HttpStatus.OK, exchange.getResponse().getStatusCode());
    }

    // ── 全链路（真实 JWT + WebFilter 链，短路型断言）──────────

    @Test
    void customerTokenOnBoChannelThroughFullChain() {
        webTestClient.get().uri("/bo/api/v1/clients?limit=10")
                .headers(h -> h.setBearerAuth(
                        jwtService.issue("28", JwtService.CHANNEL_CUSTOMER)))
                .exchange().expectStatus().isForbidden()
                .expectBody().jsonPath("$.error").isEqualTo("forbidden");
    }

    @Test
    void missingTokenOnBoChannelStill401() {
        // 鉴权先行：无 token 由 BearerTokenFilter 401（先于通道隔离 403）
        webTestClient.get().uri("/bo/api/v1/clients")
                .exchange().expectStatus().isUnauthorized()
                .expectBody().jsonPath("$.error").isEqualTo("unauthorized");
    }

    @Test
    void fineractJsonThroughFullChain() {
        webTestClient.get().uri("/bo/api/v1/fineract.json")
                .headers(h -> h.setBearerAuth(
                        jwtService.issue("admin", JwtService.CHANNEL_INTERNAL)))
                .exchange().expectStatus().isNotFound()
                .expectBody().jsonPath("$.error").isEqualTo("not_found");
    }
}
