package ai.amazingbank.gateway.customer;

import com.fasterxml.jackson.databind.JsonNode;
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
 * 账户总览与交易明细单测（P2.3）：depositType 分组、尾号脱敏、runningBalance 透传、归属 404。
 * Fineract 响应形态按 capability-probe.json（P0.2 实测）构造。
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.MOCK)
@AutoConfigureWebTestClient
class AccountsControllerTest {

    private static final ObjectMapper JSON = new ObjectMapper();

    @Autowired
    WebTestClient webTestClient;

    @Autowired
    JwtService jwtService;

    @MockitoBean
    FineractClient fineract;

    // ── 账户总览 ───────────────────────────────────────────────

    @Test
    void myAccountsGroupsByDepositTypeAndMasksAccountNo() {
        Mockito.when(fineract.get("/clients/28/accounts")).thenReturn(Mono.just(
                new FineractClient.FineractResponse(200, json("""
                        {"savingsAccounts":[
                          {"id":11,"accountNo":"000000011","productName":"ABNK-POC活期1107104347",
                           "status":{"value":"Active"},"currency":{"code":"CNY"},
                           "accountBalance":10000.0,"availableBalance":10000.0,
                           "depositType":{"id":100,"value":"Savings"}},
                          {"id":12,"accountNo":"000000012","productName":"ABNK-POC活期1107104347",
                           "status":{"value":"Active"},"currency":{"code":"CNY"},
                           "accountBalance":0.0,"availableBalance":0.0,
                           "depositType":{"id":100,"value":"Savings"}},
                          {"id":14,"accountNo":"000000014","productName":"ABNK-POC定期1107104347",
                           "status":{"value":"Active"},"currency":{"code":"CNY"},
                           "accountBalance":10000.0,
                           "depositType":{"id":200,"value":"Fixed Deposit"}}]}
                        """))));

        webTestClient.get().uri("/abnk/api/v1/me/accounts")
                .headers(h -> h.setBearerAuth(jwtService.issue("28", JwtService.CHANNEL_CUSTOMER)))
                .exchange()
                .expectStatus().isOk()
                .expectBody()
                .jsonPath("$.savingsAccounts.length()").isEqualTo(2)
                .jsonPath("$.fixedDepositAccounts.length()").isEqualTo(1)
                .jsonPath("$.savingsAccounts[0].accountNo").isEqualTo("0000**0011")
                .jsonPath("$.savingsAccounts[0].accountType").isEqualTo("SAVINGS")
                .jsonPath("$.savingsAccounts[0].currency").isEqualTo("CNY")
                .jsonPath("$.savingsAccounts[0].accountBalance").isEqualTo(10000.0)
                .jsonPath("$.fixedDepositAccounts[0].accountType").isEqualTo("FIXED_DEPOSIT")
                // 定期无 availableBalance 时回退账面余额（契约口径）
                .jsonPath("$.fixedDepositAccounts[0].availableBalance").isEqualTo(10000.0);
    }

    // ── 交易明细 ───────────────────────────────────────────────

    @Test
    void transactionsCarryRunningBalance() {
        Mockito.when(fineract.get("/clients/28/accounts")).thenReturn(Mono.just(new FineractClient.FineractResponse(
                200, json("""
                        {"savingsAccounts":[{"id":11,"accountNo":"000000011",
                          "depositType":{"id":100,"value":"Savings"}}]}
                        """))));
        Mockito.when(fineract.get("/savingsaccounts/11/transactions/search")).thenReturn(Mono.just(
                new FineractClient.FineractResponse(200, json("""
                        {"total":2,"content":[
                          {"id":15,"date":[2027,1,17],
                           "transactionType":{"value":"Deposit"},
                           "amount":10000.0,"runningBalance":10000.0,"note":"POC 源账户初始余额"},
                          {"id":16,"date":[2027,2,17],
                           "transactionType":{"value":"Withdrawal"},
                           "amount":2000.0,"runningBalance":8000.0,"note":null}]}
                        """))));

        webTestClient.get().uri("/abnk/api/v1/accounts/11/transactions")
                .headers(h -> h.setBearerAuth(jwtService.issue("28", JwtService.CHANNEL_CUSTOMER)))
                .exchange()
                .expectStatus().isOk()
                .expectBody()
                .jsonPath("$.length()").isEqualTo(2)
                .jsonPath("$[0].id").isEqualTo(15)
                .jsonPath("$[0].date").isEqualTo("2027-01-17")
                .jsonPath("$[0].transactionType").isEqualTo("Deposit")
                .jsonPath("$[0].amount").isEqualTo(10000.0)
                .jsonPath("$[0].runningBalance").isEqualTo(10000.0)
                .jsonPath("$[1].transactionType").isEqualTo("Withdrawal")
                .jsonPath("$[1].runningBalance").isEqualTo(8000.0);
    }

    @Test
    void transactionsOfForeignAccountYields404() {
        // 归属校验：账户 999 不在本人 /clients/28/accounts 内 → 404（不透传 Fineract 资源）
        Mockito.when(fineract.get("/clients/28/accounts")).thenReturn(Mono.just(new FineractClient.FineractResponse(
                200, json("""
                        {"savingsAccounts":[{"id":11,"accountNo":"000000011",
                          "depositType":{"id":100,"value":"Savings"}}]}
                        """))));

        webTestClient.get().uri("/abnk/api/v1/accounts/999/transactions")
                .headers(h -> h.setBearerAuth(jwtService.issue("28", JwtService.CHANNEL_CUSTOMER)))
                .exchange()
                .expectStatus().isNotFound()
                .expectBody()
                .jsonPath("$.error").isEqualTo("Not Found");

        // 归属失败即短路：不触达下游交易明细查询
        Mockito.verify(fineract, Mockito.never())
                .get(Mockito.startsWith("/savingsaccounts/999"));
    }

    private static JsonNode json(String raw) {
        try {
            return JSON.readTree(raw);
        } catch (Exception e) {
            throw new IllegalStateException(e);
        }
    }
}
