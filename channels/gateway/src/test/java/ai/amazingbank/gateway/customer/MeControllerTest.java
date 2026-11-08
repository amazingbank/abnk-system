package ai.amazingbank.gateway.customer;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.autoconfigure.web.reactive.AutoConfigureWebTestClient;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.reactive.server.WebTestClient;
import reactor.core.publisher.Mono;
import ai.amazingbank.gateway.auth.JwtService;

/**
 * me 聚合单测（P2.3）：脱敏字段 + 无 Fineract 内部字段泄漏 + 404/401/403 分支。
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.MOCK)
@AutoConfigureWebTestClient
class MeControllerTest {

    private static final ObjectMapper JSON = new ObjectMapper();

    @Autowired
    WebTestClient webTestClient;

    @Autowired
    JwtService jwtService;

    @MockitoBean
    FineractClient fineract;

    @Test
    void meReturnsMaskedProfile() {
        Mockito.when(fineract.get("/clients/28")).thenReturn(Mono.just(new FineractClient.FineractResponse(200,
                json("""
                        {"id":28,"accountNo":"000000028","externalId":"ABNK-POC-A-1107104347",
                         "firstname":"王","lastname":"POC-A1107104347","displayName":"王 POC-A1107104347",
                         "mobileNo":"13504347001","emailAddress":null,"officeName":"Head Office"}
                        """))));

        String body = webTestClient.get().uri("/abnk/api/v1/me")
                .headers(h -> h.setBearerAuth(jwtService.issue("28", JwtService.CHANNEL_CUSTOMER)))
                .exchange()
                .expectStatus().isOk()
                .expectBody(String.class)
                .returnResult()
                .getResponseBody();

        // 脱敏断言：姓 + 名首字；手机号尾号形态；无 Fineract 内部字段泄漏
        org.assertj.core.api.Assertions.assertThat(body)
                .contains("\"displayName\":\"王 P.\"")
                .contains("\"mobileNo\":\"135******01\"")
                .contains("\"externalId\":\"ABNK-POC-A-1107104347\"")
                .contains("\"officeName\":\"Head Office\"")
                .contains("\"clientId\":28")
                .doesNotContain("accountNo", "legalForm", "timeline", "13504347001", "王 POC-A1107104347");
    }

    @Test
    void unknownClientYields404() {
        Mockito.when(fineract.get("/clients/99"))
                .thenReturn(Mono.just(new FineractClient.FineractResponse(404, null)));

        webTestClient.get().uri("/abnk/api/v1/me")
                .headers(h -> h.setBearerAuth(jwtService.issue("99", JwtService.CHANNEL_CUSTOMER)))
                .exchange()
                .expectStatus().isNotFound()
                .expectBody()
                .jsonPath("$.error").isEqualTo("Not Found");
    }

    @Test
    void missingTokenYields401() {
        // BearerTokenFilter（P2.3 起为 WebFilter，覆盖本地 controller）回归断言
        webTestClient.get().uri("/abnk/api/v1/me")
                .exchange()
                .expectStatus().isUnauthorized()
                .expectBody()
                .jsonPath("$.error").isEqualTo("unauthorized");
    }

    @Test
    void internalTokenYields403() {
        webTestClient.get().uri("/abnk/api/v1/me")
                .headers(h -> h.setBearerAuth(jwtService.issue("admin", JwtService.CHANNEL_INTERNAL)))
                .exchange()
                .expectStatus().isForbidden();
    }

    private static com.fasterxml.jackson.databind.JsonNode json(String raw) {
        try {
            return JSON.readTree(raw);
        } catch (Exception e) {
            throw new IllegalStateException(e);
        }
    }
}
