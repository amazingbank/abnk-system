package ai.amazingbank.gateway.customer;

import static org.assertj.core.api.Assertions.assertThat;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import java.time.LocalDate;
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
 * identity 端点单测（P2.3）：到期状态三态（纯读计算）+ 脱敏 + 无证照 404 + 通道防线。
 *
 * <p>EXPIRING_SOON 分支在此直接覆盖（联调种子无临期客户——VP2.3.3 已声明该口径）。
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.MOCK)
@AutoConfigureWebTestClient
class IdentityControllerTest {

    private static final ObjectMapper JSON = new ObjectMapper();
    private static final LocalDate BUSINESS_DATE = LocalDate.of(2027, 3, 29);

    @Autowired
    WebTestClient webTestClient;

    @Autowired
    JwtService jwtService;

    @MockitoBean
    FineractClient fineract;

    // ── 纯函数：deriveStatus 三态边界 ──────────────────────────

    @Test
    void deriveStatusBoundaries() {
        LocalDate today = LocalDate.of(2027, 3, 29);
        // 已过期：expiry 严格早于业务日期
        assertThat(IdentityController.deriveStatus(today, LocalDate.of(2020, 1, 1))).isEqualTo("EXPIRED");
        // 当天到期 → 临期
        assertThat(IdentityController.deriveStatus(today, today)).isEqualTo("EXPIRING_SOON");
        // +30 天 → 临期（窗口含端点）
        assertThat(IdentityController.deriveStatus(today, today.plusDays(30))).isEqualTo("EXPIRING_SOON");
        // +31 天 → 有效
        assertThat(IdentityController.deriveStatus(today, today.plusDays(31))).isEqualTo("VALID");
        // 有效（对照组 bob：2099-12-31）
        assertThat(IdentityController.deriveStatus(today, LocalDate.of(2099, 12, 31))).isEqualTo("VALID");
        // 无到期日 → 视为有效
        assertThat(IdentityController.deriveStatus(today, null)).isEqualTo("VALID");
    }

    // ── API：alice 过期种子 → EXPIRED ──────────────────────────

    @Test
    void aliceExpiredSeedYieldsExpiredStatus() {
        mockBusinessDate(BUSINESS_DATE);
        mockIdentifiers("2020-01-01", "ID-A-1107104347");

        webTestClient.get().uri("/abnk/api/v1/me/identity")
                .headers(h -> h.setBearerAuth(jwtService.issue("28", JwtService.CHANNEL_CUSTOMER)))
                .exchange()
                .expectStatus().isOk()
                .expectBody()
                .jsonPath("$.status").isEqualTo("EXPIRED")
                .jsonPath("$.expiryDate").isEqualTo("2020-01-01")
                .jsonPath("$.issuanceDate").isEqualTo("2015-01-01")
                .jsonPath("$.documentTypeId").isEqualTo(1)
                .jsonPath("$.documentTypeName").isEqualTo("Passport")
                .jsonPath("$.documentKey").isEqualTo("ID-A********347");
    }

    @Test
    void bobValidSeedYieldsValidStatus() {
        mockBusinessDate(BUSINESS_DATE);
        mockIdentifiers("2099-12-31", "ID-B-1107104347");

        webTestClient.get().uri("/abnk/api/v1/me/identity")
                .headers(h -> h.setBearerAuth(jwtService.issue("29", JwtService.CHANNEL_CUSTOMER)))
                .exchange()
                .expectStatus().isOk()
                .expectBody()
                .jsonPath("$.status").isEqualTo("VALID")
                .jsonPath("$.expiryDate").isEqualTo("2099-12-31");
    }

    @Test
    void expiringSoonWindowDirectlyCovered() {
        // 种子无临期客户——单测直接覆盖（VP2.3.3 声明口径）
        mockBusinessDate(BUSINESS_DATE);
        mockIdentifiers(BUSINESS_DATE.plusDays(10).toString(), "ID-X");

        webTestClient.get().uri("/abnk/api/v1/me/identity")
                .headers(h -> h.setBearerAuth(jwtService.issue("28", JwtService.CHANNEL_CUSTOMER)))
                .exchange()
                .expectStatus().isOk()
                .expectBody()
                .jsonPath("$.status").isEqualTo("EXPIRING_SOON");
    }

    @Test
    void noIdentifierYields404() {
        mockBusinessDate(BUSINESS_DATE);
        Mockito.when(fineract.get("/clients/28/identifiers"))
                .thenReturn(Mono.just(new FineractClient.FineractResponse(200, JSON.createArrayNode())));

        webTestClient.get().uri("/abnk/api/v1/me/identity")
                .headers(h -> h.setBearerAuth(jwtService.issue("28", JwtService.CHANNEL_CUSTOMER)))
                .exchange()
                .expectStatus().isNotFound()
                .expectBody()
                .jsonPath("$.error").isEqualTo("Not Found");
    }

    @Test
    void internalTokenRejectedOnCustomerFace() {
        webTestClient.get().uri("/abnk/api/v1/me/identity")
                .headers(h -> h.setBearerAuth(jwtService.issue("admin", JwtService.CHANNEL_INTERNAL)))
                .exchange()
                .expectStatus().isForbidden();
    }

    // ── mock helpers ───────────────────────────────────────────

    private void mockBusinessDate(LocalDate date) {
        ArrayNode businessDates = JSON.createArrayNode();
        ObjectNode bd = businessDates.addObject();
        bd.put("type", "BUSINESS_DATE");
        ArrayNode arr = bd.putArray("date");
        arr.add(date.getYear()).add(date.getMonthValue()).add(date.getDayOfMonth());
        Mockito.when(fineract.get("/businessdate"))
                .thenReturn(Mono.just(new FineractClient.FineractResponse(200, businessDates)));
    }

    private void mockIdentifiers(String expiryDate, String documentKey) {
        ArrayNode identifiers = JSON.createArrayNode();
        ObjectNode id = identifiers.addObject();
        ObjectNode docType = id.putObject("documentType");
        docType.put("id", 1).put("name", "Passport");
        id.put("documentKey", documentKey);
        id.put("status", "clientIdentifierStatusType.active");
        id.put("issuanceDate", "2015-01-01");
        id.put("expiryDate", expiryDate);
        Mockito.when(fineract.get("/clients/28/identifiers"))
                .thenReturn(Mono.just(new FineractClient.FineractResponse(200, identifiers)));
        Mockito.when(fineract.get("/clients/29/identifiers"))
                .thenReturn(Mono.just(new FineractClient.FineractResponse(200, identifiers)));
    }
}
