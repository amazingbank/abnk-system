package ai.amazingbank.gateway.customer;

import com.fasterxml.jackson.databind.JsonNode;
import java.util.ArrayList;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

/**
 * 账户总览与单账户交易明细（对客收敛，P2.3）。
 *
 * <ul>
 *   <li>GET /abnk/api/v1/me/accounts：聚合 Fineract GET /clients/{id}/accounts，
 *       账号尾号脱敏；定期账户（depositType.id=200）无 availableBalance 时回退账面余额。</li>
 *   <li>GET /abnk/api/v1/accounts/{id}/transactions：转发 Fineract
 *       GET /savingsaccounts/{id}/transactions/search（P0.2 VP0.2.4 实测：Spring 标准分页
 *       content/total；本 HEAD 无朴素列表 GET），item 收敛为 6 字段、runningBalance 透传；
 *       仅本人账户可达（归属校验 → 404）。</li>
 * </ul>
 */
@RestController
public class AccountsController {

    private static final long DEPOSIT_TYPE_FIXED = 200;

    private final FineractClient fineract;

    public AccountsController(FineractClient fineract) {
        this.fineract = fineract;
    }

    @GetMapping("/abnk/api/v1/me/accounts")
    public Mono<ResponseEntity<Object>> myAccounts(ServerWebExchange exchange) {
        var clientId = CustomerContext.clientIdOf(exchange);
        if (clientId.isEmpty()) {
            return forbidden();
        }
        return fineract.get("/clients/" + clientId.getAsLong() + "/accounts")
                .map(resp -> {
                    if (!resp.isOk() || resp.body() == null) {
                        return ResponseEntity.status(HttpStatus.NOT_FOUND)
                                .body((Object) new MeController.ApiError(404, "Not Found", "客户不存在"));
                    }
                    JsonNode savings = resp.body().path("savingsAccounts");
                    List<Account> savingsList = new ArrayList<>();
                    List<Account> fixedList = new ArrayList<>();
                    if (savings.isArray()) {
                        for (var a : savings) {
                            Account item = toAccount(a);
                            if (a.path("depositType").path("id").asLong() == DEPOSIT_TYPE_FIXED) {
                                fixedList.add(item);
                            } else {
                                savingsList.add(item);
                            }
                        }
                    }
                    return ResponseEntity.ok((Object) new AccountSummary(savingsList, fixedList));
                });
    }

    @GetMapping("/abnk/api/v1/accounts/{id}/transactions")
    public Mono<ResponseEntity<Object>> transactions(@PathVariable long id, ServerWebExchange exchange) {
        var clientId = CustomerContext.clientIdOf(exchange);
        if (clientId.isEmpty()) {
            return forbidden();
        }
        return fineract.get("/clients/" + clientId.getAsLong() + "/accounts")
                .flatMap(accounts -> {
                    if (!ownsAccount(accounts.body(), id)) {
                        return Mono.just(ResponseEntity.status(HttpStatus.NOT_FOUND)
                                .body((Object) new MeController.ApiError(404, "Not Found", "账户不存在或不属于当前客户")));
                    }
                    return fineract.get("/savingsaccounts/" + id + "/transactions/search")
                            .map(resp -> {
                                if (!resp.isOk() || resp.body() == null) {
                                    return ResponseEntity.status(HttpStatus.NOT_FOUND)
                                            .body((Object) new MeController.ApiError(404, "Not Found",
                                                    "账户不存在或不属于当前客户"));
                                }
                                List<TransactionItem> items = new ArrayList<>();
                                JsonNode content = resp.body().path("content");
                                if (content.isArray()) {
                                    for (var t : content) {
                                        String note = t.path("note").asText(null);
                                        items.add(new TransactionItem(
                                                t.path("id").asLong(),
                                                FineractClient.isoDate(t.get("date")),
                                                t.path("transactionType").path("value").asText(null),
                                                t.path("amount").asDouble(),
                                                t.path("runningBalance").asDouble(),
                                                note));
                                    }
                                }
                                return ResponseEntity.ok((Object) items);
                            });
                });
    }

    /** 归属校验：账户 id ∈ /clients/{id}/accounts 的 savingsAccounts（FD 账户也在此键下，实测）。 */
    static boolean ownsAccount(JsonNode accountsBody, long accountId) {
        if (accountsBody == null) {
            return false;
        }
        JsonNode savings = accountsBody.path("savingsAccounts");
        if (savings.isArray()) {
            for (var a : savings) {
                if (a.path("id").asLong() == accountId) {
                    return true;
                }
            }
        }
        return false;
    }

    private static Account toAccount(JsonNode a) {
        // 注意保持 Double 装箱类型——三元混用 double/Double 会拆箱 NPE（部分账户投影缺余额键）
        Double balance = a.path("accountBalance").isNumber() ? Double.valueOf(a.path("accountBalance").asDouble())
                : null;
        Double available = a.path("availableBalance").isNumber() ? Double.valueOf(a.path("availableBalance").asDouble())
                : balance;
        return new Account(
                a.path("id").asLong(),
                Masking.accountNo(a.path("accountNo").asText("")),
                a.path("productName").asText(null),
                a.path("depositType").path("id").asLong() == DEPOSIT_TYPE_FIXED ? "FIXED_DEPOSIT" : "SAVINGS",
                a.path("currency").path("code").asText(null),
                balance,
                available,
                a.path("status").path("value").asText(null));
    }

    private static Mono<ResponseEntity<Object>> forbidden() {
        return Mono.just(ResponseEntity.status(HttpStatus.FORBIDDEN)
                .body((Object) new MeController.ApiError(403, "Forbidden", "customer channel required")));
    }

    /** 契约 Account（interestRate / maturityDate 为定期可选项，本收敛面不投影——实测列表无此数据）。 */
    public record Account(Long id, String accountNo, String productName, String accountType, String currency,
            Double accountBalance, Double availableBalance, String status) {
    }

    public record AccountSummary(List<Account> savingsAccounts, List<Account> fixedDepositAccounts) {
    }

    /** 契约 TransactionItem（6 字段；note 可空）。 */
    public record TransactionItem(Long id, String date, String transactionType, Double amount,
            Double runningBalance, String note) {
    }
}
