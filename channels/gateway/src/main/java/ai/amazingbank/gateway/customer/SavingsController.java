package ai.amazingbank.gateway.customer;

import com.fasterxml.jackson.databind.node.ObjectNode;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

/**
 * POST /abnk/api/v1/savings —— 定期开户（从源活期账户扣款转入新定期账户，P2.3）。
 *
 * <p>网关侧编排 Fineract 三段链路（P0.2 VP0.2.3 实测）：
 * 申请 POST /fixeddepositaccounts → approve → activate，再对源账户提交 withdrawal 扣款。
 * 到期日 = 激活日（业务日期）+ 12 个月，对年对月对日（月末 Clamp——java.time plusMonths 语义）。
 *
 * <p>校验（契约 400/404 口径）：金额须为正且 ≥ 产品起存金额（depositAmount 字段——P0.3 种子口径，
 * 实测产品投影无 minDepositAmount）；源账户须为本人账户且可用余额充足（否则 400）。
 */
@RestController
public class SavingsController {

    /** POC 基线定期存期（月）——契约 FixedDepositRequest 无期限入参，基线按 12 个月口径。 */
    static final int DEPOSIT_PERIOD_MONTHS = 12;

    private final FineractClient fineract;
    private final com.fasterxml.jackson.databind.ObjectMapper mapper =
            new com.fasterxml.jackson.databind.ObjectMapper();

    public SavingsController(FineractClient fineract) {
        this.fineract = fineract;
    }

    public record FixedDepositRequest(Long productId, Long sourceAccountId, Double amount) {
    }

    public record FixedDepositResult(Long accountId, String maturityDate) {
    }

    @PostMapping("/abnk/api/v1/savings")
    public Mono<ResponseEntity<Object>> openFixedDeposit(@RequestBody FixedDepositRequest request,
            ServerWebExchange exchange) {
        var clientId = CustomerContext.clientIdOf(exchange);
        if (clientId.isEmpty()) {
            return Mono.just(ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body((Object) new MeController.ApiError(403, "Forbidden", "customer channel required")));
        }
        if (request == null || request.productId() == null || request.sourceAccountId() == null
                || request.amount() == null || request.amount() <= 0) {
            return Mono.just(ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body((Object) new MeController.ApiError(400, "Bad Request", "参数校验失败（金额须为正）")));
        }
        long cid = clientId.getAsLong();
        return fineract.get("/fixeddepositproducts/" + request.productId())
                .flatMap(product -> {
                    if (!product.isOk() || product.body() == null) {
                        return Mono.just(ResponseEntity.status(HttpStatus.NOT_FOUND)
                                .body((Object) new MeController.ApiError(404, "Not Found", "定期产品不存在")));
                    }
                    double minDeposit = product.body().path("depositAmount").asDouble(0);
                    if (request.amount() < minDeposit) {
                        return Mono.just(ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                .body((Object) new MeController.ApiError(400, "Bad Request",
                                        "存入金额低于起存金额 " + minDeposit)));
                    }
                    return fineract.get("/clients/" + cid + "/accounts").flatMap(accounts -> {
                        if (!AccountsController.ownsAccount(accounts.body(), request.sourceAccountId())) {
                            return Mono.just(ResponseEntity.status(HttpStatus.NOT_FOUND).body((Object) new MeController.ApiError(
                                    404, "Not Found", "源账户不存在或不属于当前客户")));
                        }
                        return fineract.get("/savingsaccounts/" + request.sourceAccountId()).flatMap(source -> {
                            double balance = FineractClient.at(source.body(), "summary", "accountBalance") != null
                                    && FineractClient.at(source.body(), "summary", "accountBalance").isNumber()
                                            ? FineractClient.at(source.body(), "summary", "accountBalance").asDouble()
                                            : 0;
                            if (balance < request.amount()) {
                                return Mono.just(ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                        .body((Object) new MeController.ApiError(400, "Bad Request", "源账户余额不足")));
                            }
                            return IdentityController.businessDateOfHolder(fineract)
                                    .flatMap(today -> submitChain(cid, request, today));
                        });
                    });
                });
    }

    /** 申请 → 审批 → 激活 → 源账户扣款（顺序链，任一步失败按契约语义短路）。 */
    private Mono<ResponseEntity<Object>> submitChain(long clientId, FixedDepositRequest request,
            java.time.LocalDate today) {
        ObjectNode application = mapper.createObjectNode();
        application.put("clientId", clientId);
        application.put("productId", request.productId());
        application.put("submittedOnDate", today.toString());
        application.put("depositAmount", request.amount());
        application.put("depositPeriod", DEPOSIT_PERIOD_MONTHS);
        application.put("depositPeriodFrequencyId", 2); // MONTHS
        application.put("locale", "en");
        application.put("dateFormat", "yyyy-MM-dd");

        return fineract.post("/fixeddepositaccounts", application).flatMap(created -> {
            if (!created.isOk() || created.body() == null) {
                return badRequest(LoanController.downstreamMessage(created.body(), "定期开户申请被拒绝"));
            }
            long accountId = created.body().path("savingsId").asLong(created.body().path("resourceId").asLong());
            if (accountId <= 0) {
                return Mono.just(ResponseEntity.status(HttpStatus.BAD_GATEWAY)
                        .body((Object) new MeController.ApiError(502, "Bad Gateway", "下游未返回账户编号")));
            }
            ObjectNode approve = mapper.createObjectNode();
            approve.put("approvedOnDate", today.toString());
            approve.put("locale", "en");
            approve.put("dateFormat", "yyyy-MM-dd");
            return fineract.post("/fixeddepositaccounts/" + accountId, approve, "command=approve")
                    .flatMap(ignored -> {
                        ObjectNode activate = mapper.createObjectNode();
                        activate.put("activatedOnDate", today.toString());
                        activate.put("locale", "en");
                        activate.put("dateFormat", "yyyy-MM-dd");
                        return fineract.post("/fixeddepositaccounts/" + accountId, activate, "command=activate");
                    })
                    .flatMap(ignored -> withdrawFromSource(request, today))
                    .map(ignored -> ResponseEntity.ok((Object) new FixedDepositResult(accountId,
                            today.plusMonths(DEPOSIT_PERIOD_MONTHS).toString())));
        });
    }

    private Mono<Void> withdrawFromSource(FixedDepositRequest request, java.time.LocalDate today) {
        ObjectNode withdrawal = mapper.createObjectNode();
        withdrawal.put("transactionDate", today.toString());
        withdrawal.put("transactionAmount", request.amount());
        withdrawal.put("note", "定期开户扣款（网关编排）");
        withdrawal.put("locale", "en");
        withdrawal.put("dateFormat", "yyyy-MM-dd");
        return fineract.post("/savingsaccounts/" + request.sourceAccountId() + "/transactions", withdrawal,
                "command=withdrawal").flatMap(resp -> {
                    if (!resp.isOk()) {
                        return Mono.error(new IllegalStateException(
                                "withdrawal failed: " + LoanController.downstreamMessage(resp.body(), "unknown")));
                    }
                    return Mono.empty();
                });
    }

    private static Mono<ResponseEntity<Object>> badRequest(String message) {
        return Mono.just(ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body((Object) new MeController.ApiError(400, "Bad Request", message)));
    }
}
