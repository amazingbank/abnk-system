package ai.amazingbank.gateway.transfer;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.reactive.AutoConfigureWebTestClient;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.reactive.server.WebTestClient;
import reactor.core.publisher.Mono;
import ai.amazingbank.gateway.auth.JwtService;
import ai.amazingbank.gateway.customer.FineractClient;

/**
 * 转账聚合单测（P2.4）：正向成功、幂等重放（缓存 + Fineract 兜底恢复）、第二步失败触发冲正、
 * 冲正也失败终态 502、跨账户 403、余额不足透传 400、同账户 400、源账户不属 403（本人账户约束）。
 * Fineract 响应形态按 capability-probe.json / 源码核实口径（CommandProcessingResult.resourceId =
 * 交易 ID；externalId 唯一索引 uk_m_sat_external_id）构造。
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.MOCK)
@AutoConfigureWebTestClient
class TransferControllerTest {

    private static final ObjectMapper JSON = new ObjectMapper();

    @Autowired
    WebTestClient webTestClient;

    @Autowired
    JwtService jwtService;

    @MockitoBean
    FineractClient fineract;

    /** 全局默认 stub：未覆盖的下游调用返回空 Mono（防 null NPE——switchIfEmpty 参数组装即求值）。 */
    @org.junit.jupiter.api.BeforeEach
    void defaultStubs() {
        Mockito.when(fineract.get(Mockito.anyString())).thenReturn(Mono.empty());
        Mockito.when(fineract.post(Mockito.anyString(), Mockito.any(), Mockito.anyString()))
                .thenReturn(Mono.empty());
    }

    // ── 1. 正向成功 ───────────────────────────────────────────

    @Test
    void transferHappyPathReturnsResult() {
        stubOwnership(11, 12);
        Mockito.when(fineract.get("/businessdate")).thenReturn(Mono.just(
                new FineractClient.FineractResponse(200, json(
                        "[{\"type\":\"BUSINESS_DATE\",\"date\":[2027,3,29]}]"))));
        Mockito.when(fineract.get("/savingsaccounts/11/transactions/external-id/T-HP-w")).thenReturn(
                Mono.just(new FineractClient.FineractResponse(404, null)));
        Mockito.when(fineract.post(Mockito.eq("/savingsaccounts/11/transactions"), Mockito.any(),
                Mockito.eq("command=withdrawal"))).thenReturn(Mono.just(
                        new FineractClient.FineractResponse(200, json("{\"resourceId\":21}"))));
        Mockito.when(fineract.post(Mockito.eq("/savingsaccounts/12/transactions"), Mockito.any(),
                Mockito.eq("command=deposit"))).thenReturn(Mono.just(
                        new FineractClient.FineractResponse(200, json("{\"resourceId\":22}"))));
        Mockito.when(fineract.get("/savingsaccounts/11")).thenReturn(Mono.just(
                new FineractClient.FineractResponse(200, json(
                        "{\"summary\":{\"accountBalance\":9900.0}}"))));

        webTestClient.post().uri("/abnk/api/v1/accounts/11/transfer")
                .headers(h -> h.setBearerAuth(jwtService.issue("28", JwtService.CHANNEL_CUSTOMER)))
                .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                .bodyValue("{\"toAccountId\":12,\"amount\":100,\"externalId\":\"T-HP\"}")
                .exchange()
                .expectStatus().isOk()
                .expectBody()
                .jsonPath("$.transactionId").isEqualTo(21)
                .jsonPath("$.newSourceBalance").isEqualTo(9900.0);
    }

    // ── 2. 幂等重放（缓存命中同结果，不重复落账） ───────────────

    @Test
    void replaySameKeyReturnsCachedResultWithoutNewTransactions() {
        stubOwnership(11, 12);
        Mockito.when(fineract.get("/businessdate")).thenReturn(Mono.just(
                new FineractClient.FineractResponse(200, json(
                        "[{\"type\":\"BUSINESS_DATE\",\"date\":[2027,3,29]}]"))));
        Mockito.when(fineract.get("/savingsaccounts/11/transactions/external-id/T-RP-w")).thenReturn(
                Mono.just(new FineractClient.FineractResponse(404, null)));
        Mockito.when(fineract.post(Mockito.eq("/savingsaccounts/11/transactions"), Mockito.any(),
                Mockito.eq("command=withdrawal"))).thenReturn(Mono.just(
                        new FineractClient.FineractResponse(200, json("{\"resourceId\":31}"))));
        Mockito.when(fineract.post(Mockito.eq("/savingsaccounts/12/transactions"), Mockito.any(),
                Mockito.eq("command=deposit"))).thenReturn(Mono.just(
                        new FineractClient.FineractResponse(200, json("{\"resourceId\":32}"))));
        Mockito.when(fineract.get("/savingsaccounts/11")).thenReturn(Mono.just(
                new FineractClient.FineractResponse(200, json(
                        "{\"summary\":{\"accountBalance\":9900.0}}"))));

        var first = webTestClient.post().uri("/abnk/api/v1/accounts/11/transfer")
                .headers(h -> h.setBearerAuth(jwtService.issue("28", JwtService.CHANNEL_CUSTOMER)))
                .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                .bodyValue("{\"toAccountId\":12,\"amount\":100,\"externalId\":\"T-RP\"}")
                .exchange()
                .expectStatus().isOk()
                .expectBody(String.class).returnResult().getResponseBody();

        var second = webTestClient.post().uri("/abnk/api/v1/accounts/11/transfer")
                .headers(h -> h.setBearerAuth(jwtService.issue("28", JwtService.CHANNEL_CUSTOMER)))
                .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                .bodyValue("{\"toAccountId\":12,\"amount\":100,\"externalId\":\"T-RP\"}")
                .exchange()
                .expectStatus().isOk()
                .expectBody(String.class).returnResult().getResponseBody();

        org.junit.jupiter.api.Assertions.assertEquals(first, second);
        // 重放不产生新子交易（withdrawal / deposit 各恰一次）
        Mockito.verify(fineract, Mockito.times(1)).post(Mockito.eq("/savingsaccounts/11/transactions"),
                Mockito.any(), Mockito.eq("command=withdrawal"));
        Mockito.verify(fineract, Mockito.times(1)).post(Mockito.eq("/savingsaccounts/12/transactions"),
                Mockito.any(), Mockito.eq("command=deposit"));
    }

    // ── 3. 幂等兜底（缓存丢失后按 Fineract 落账痕迹恢复） ───────

    @Test
    void replayAfterCacheLossRecoversFromFineractLedger() {
        // 场景 = 网关重启（缓存空）：-w 与 -d 双子交易已落账 → 重建首次结果
        Mockito.when(fineract.get("/savingsaccounts/11/transactions/external-id/T-RC-w")).thenReturn(
                Mono.just(new FineractClient.FineractResponse(200, json(
                        "{\"id\":21,\"runningBalance\":9900.0}"))));
        Mockito.when(fineract.get("/savingsaccounts/12/transactions/external-id/T-RC-d")).thenReturn(
                Mono.just(new FineractClient.FineractResponse(200, json(
                        "{\"id\":22,\"runningBalance\":100.0}"))));

        webTestClient.post().uri("/abnk/api/v1/accounts/11/transfer")
                .headers(h -> h.setBearerAuth(jwtService.issue("28", JwtService.CHANNEL_CUSTOMER)))
                .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                .bodyValue("{\"toAccountId\":12,\"amount\":100,\"externalId\":\"T-RC\"}")
                .exchange()
                .expectStatus().isOk()
                .expectBody()
                .jsonPath("$.transactionId").isEqualTo(21)
                .jsonPath("$.newSourceBalance").isEqualTo(9900.0);

        // 恢复路径不重复落账
        Mockito.verify(fineract, Mockito.never()).post(Mockito.anyString(), Mockito.any(), Mockito.anyString());
    }

    // ── 4. 第二步失败触发冲正（502 + 冲正单号） ─────────────────

    @Test
    void depositFailureTriggersReversalAndReturns502() {
        stubOwnership(11, 12);
        Mockito.when(fineract.get("/businessdate")).thenReturn(Mono.just(
                new FineractClient.FineractResponse(200, json(
                        "[{\"type\":\"BUSINESS_DATE\",\"date\":[2027,3,29]}]"))));
        Mockito.when(fineract.get("/savingsaccounts/11/transactions/external-id/T-DF-w")).thenReturn(
                Mono.just(new FineractClient.FineractResponse(404, null)));
        Mockito.when(fineract.post(Mockito.eq("/savingsaccounts/11/transactions"), Mockito.any(),
                Mockito.eq("command=withdrawal"))).thenReturn(Mono.just(
                        new FineractClient.FineractResponse(200, json("{\"resourceId\":21}"))));
        // 第二步 deposit 失败（下游 500）
        Mockito.when(fineract.post(Mockito.eq("/savingsaccounts/12/transactions"), Mockito.any(),
                Mockito.eq("command=deposit"))).thenReturn(Mono.just(
                        new FineractClient.FineractResponse(500, json(
                                "{\"defaultUserMessage\":\"deposit rejected\"}"))));
        // 冲正 = 对源账户的反向 deposit（<key>-r）
        Mockito.when(fineract.post(Mockito.eq("/savingsaccounts/11/transactions"), Mockito.any(),
                Mockito.eq("command=deposit"))).thenReturn(Mono.just(
                        new FineractClient.FineractResponse(200, json("{\"resourceId\":23}"))));

        webTestClient.post().uri("/abnk/api/v1/accounts/11/transfer")
                .headers(h -> h.setBearerAuth(jwtService.issue("28", JwtService.CHANNEL_CUSTOMER)))
                .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                .bodyValue("{\"toAccountId\":12,\"amount\":100,\"externalId\":\"T-DF\"}")
                .exchange()
                .expectStatus().isEqualTo(502)
                .expectBody()
                .jsonPath("$.error").isEqualTo("Bad Gateway")
                .jsonPath("$.reversalTransactionId").isEqualTo(23)
                .jsonPath("$.message").value(
                        msg -> org.junit.jupiter.api.Assertions.assertTrue(msg.toString().contains("冲正"),
                                "message 应说明已冲正，实际: " + msg));

        // 冲正落账恰一次
        Mockito.verify(fineract, Mockito.times(1)).post(Mockito.eq("/savingsaccounts/11/transactions"),
                Mockito.any(), Mockito.eq("command=deposit"));
    }

    // ── 5. 冲正也失败 → 终态 502（人工对账口径） ────────────────

    @Test
    void reversalFailureYieldsTerminal502() {
        stubOwnership(11, 12);
        Mockito.when(fineract.get("/businessdate")).thenReturn(Mono.just(
                new FineractClient.FineractResponse(200, json(
                        "[{\"type\":\"BUSINESS_DATE\",\"date\":[2027,3,29]}]"))));
        Mockito.when(fineract.get("/savingsaccounts/11/transactions/external-id/T-RF-w")).thenReturn(
                Mono.just(new FineractClient.FineractResponse(404, null)));
        Mockito.when(fineract.post(Mockito.eq("/savingsaccounts/11/transactions"), Mockito.any(),
                Mockito.eq("command=withdrawal"))).thenReturn(Mono.just(
                        new FineractClient.FineractResponse(200, json("{\"resourceId\":21}"))));
        Mockito.when(fineract.post(Mockito.eq("/savingsaccounts/12/transactions"), Mockito.any(),
                Mockito.eq("command=deposit"))).thenReturn(Mono.just(
                        new FineractClient.FineractResponse(500, json(
                                "{\"defaultUserMessage\":\"deposit rejected\"}"))));
        // 冲正也失败（终态悬挂——人工对账口径）
        Mockito.when(fineract.post(Mockito.eq("/savingsaccounts/11/transactions"), Mockito.any(),
                Mockito.eq("command=deposit"))).thenReturn(Mono.just(
                        new FineractClient.FineractResponse(500, json(
                                "{\"defaultUserMessage\":\"reversal rejected\"}"))));

        webTestClient.post().uri("/abnk/api/v1/accounts/11/transfer")
                .headers(h -> h.setBearerAuth(jwtService.issue("28", JwtService.CHANNEL_CUSTOMER)))
                .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                .bodyValue("{\"toAccountId\":12,\"amount\":100,\"externalId\":\"T-RF\"}")
                .exchange()
                .expectStatus().isEqualTo(502)
                .expectBody()
                .jsonPath("$.error").isEqualTo("Bad Gateway")
                .jsonPath("$.reversalTransactionId").doesNotExist()
                .jsonPath("$.message").value(
                        msg -> org.junit.jupiter.api.Assertions.assertTrue(msg.toString().contains("人工对账"),
                                "message 应声明人工对账口径，实际: " + msg));
    }

    // ── 6. 越权负向：目标账户非本人 → 403 ──────────────────────

    @Test
    void transferToForeignAccountYields403() {
        Mockito.when(fineract.get("/clients/28/accounts")).thenReturn(Mono.just(
                new FineractClient.FineractResponse(200, json(
                        "{\"savingsAccounts\":[{\"id\":11}]}"))));

        webTestClient.post().uri("/abnk/api/v1/accounts/11/transfer")
                .headers(h -> h.setBearerAuth(jwtService.issue("28", JwtService.CHANNEL_CUSTOMER)))
                .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                .bodyValue("{\"toAccountId\":99,\"amount\":100,\"externalId\":\"T-403\"}")
                .exchange()
                .expectStatus().isForbidden()
                .expectBody()
                .jsonPath("$.error").isEqualTo("Forbidden");

        // 越权即短路：不触达任何下游交易
        Mockito.verify(fineract, Mockito.never()).post(Mockito.anyString(), Mockito.any(), Mockito.anyString());
    }

    // ── 7. 余额不足透传 4xx（Fineract 403 → 契约 400） ──────────

    @Test
    void insufficientBalanceYields400WithDownstreamMessage() {
        stubOwnership(11, 12);
        Mockito.when(fineract.get("/businessdate")).thenReturn(Mono.just(
                new FineractClient.FineractResponse(200, json(
                        "[{\"type\":\"BUSINESS_DATE\",\"date\":[2027,3,29]}]"))));
        Mockito.when(fineract.get("/savingsaccounts/11/transactions/external-id/T-IB-w")).thenReturn(
                Mono.just(new FineractClient.FineractResponse(404, null)));
        Mockito.when(fineract.post(Mockito.eq("/savingsaccounts/11/transactions"), Mockito.any(),
                Mockito.eq("command=withdrawal"))).thenReturn(Mono.just(
                        new FineractClient.FineractResponse(403, json(
                                "{\"defaultUserMessage\":\"Insufficient account balance.\"}"))));

        webTestClient.post().uri("/abnk/api/v1/accounts/11/transfer")
                .headers(h -> h.setBearerAuth(jwtService.issue("28", JwtService.CHANNEL_CUSTOMER)))
                .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                .bodyValue("{\"toAccountId\":12,\"amount\":100,\"externalId\":\"T-IB\"}")
                .exchange()
                .expectStatus().isBadRequest()
                .expectBody()
                .jsonPath("$.message").isEqualTo("Insufficient account balance.");

        // 第一步即失败：无 deposit、无冲正
        Mockito.verify(fineract, Mockito.never()).post(Mockito.anyString(), Mockito.any(),
                Mockito.eq("command=deposit"));
    }

    // ── 8. 同账户 / 源账户不属 ─────────────────────────────────

    @Test
    void sameAccountYields400() {
        webTestClient.post().uri("/abnk/api/v1/accounts/11/transfer")
                .headers(h -> h.setBearerAuth(jwtService.issue("28", JwtService.CHANNEL_CUSTOMER)))
                .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                .bodyValue("{\"toAccountId\":11,\"amount\":100,\"externalId\":\"T-SA\"}")
                .exchange()
                .expectStatus().isBadRequest()
                .expectBody()
                .jsonPath("$.error").isEqualTo("Bad Request");
    }

    @Test
    void sourceNotOwnedYields403() {
        Mockito.when(fineract.get("/clients/28/accounts")).thenReturn(Mono.just(
                new FineractClient.FineractResponse(200, json(
                        "{\"savingsAccounts\":[{\"id\":11}]}"))));

        webTestClient.post().uri("/abnk/api/v1/accounts/55/transfer")
                .headers(h -> h.setBearerAuth(jwtService.issue("28", JwtService.CHANNEL_CUSTOMER)))
                .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                .bodyValue("{\"toAccountId\":11,\"amount\":100,\"externalId\":\"T-403S\"}")
                .exchange()
                .expectStatus().isForbidden()
                .expectBody()
                .jsonPath("$.error").isEqualTo("Forbidden");
    }

    // ── 辅助 ───────────────────────────────────────────────────

    private void stubOwnership(long src, long dst) {
        Mockito.when(fineract.get("/clients/28/accounts")).thenReturn(Mono.just(
                new FineractClient.FineractResponse(200, json(String.format(
                        "{\"savingsAccounts\":[{\"id\":%d},{\"id\":%d}]}", src, dst)))));
    }

    private static JsonNode json(String raw) {
        try {
            return JSON.readTree(raw);
        } catch (Exception e) {
            throw new IllegalStateException(e);
        }
    }
}
