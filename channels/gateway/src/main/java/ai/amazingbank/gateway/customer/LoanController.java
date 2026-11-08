package ai.amazingbank.gateway.customer;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

/**
 * 对客贷款与产品面（P2.3 契约收敛）。
 *
 * <ul>
 *   <li>GET /abnk/api/v1/loan-products：转发 Fineract GET /loanproducts（裸数组），
 *       termFrequency = numberOfRepayments × repaymentEvery（实测 loanTermFrequency 为 null）。</li>
 *   <li>GET /abnk/api/v1/fixed-deposit-products：转发 GET /fixeddepositproducts；
 *       interestRate = nominalAnnualInterestRate（实测产品 API 投影不含 chart——charts:null，
 *       chart 细化利率在账户层 nominalAnnualInterestRate 呈现）；depositPeriod = minDepositTerm
 *       （最短存期口径）；minDepositAmount = depositAmount（P0.3 种子起存金额字段）。</li>
 *   <li>POST /abnk/api/v1/loans：转发 Fineract POST /loans（P0.2 VP0.2.2 实测链路）；
 *       网关侧按产品 min/max 与期限校验（契约 400 口径）；locale/dateFormat 由网关注入。</li>
 *   <li>GET /abnk/api/v1/loans/{id}：转发 GET /loans/{id}，对客收敛字段；仅本人贷款可达。</li>
 * </ul>
 */
@RestController
public class LoanController {

    private final FineractClient fineract;
    private final com.fasterxml.jackson.databind.ObjectMapper mapper =
            new com.fasterxml.jackson.databind.ObjectMapper();

    public LoanController(FineractClient fineract) {
        this.fineract = fineract;
    }

    // ── 产品清单（对客收敛字段）──────────────────────────────────

    @Operation(responses = @ApiResponse(responseCode = "200",
            content = @Content(array = @ArraySchema(schema = @Schema(implementation = LoanProduct.class)))))
    @GetMapping("/abnk/api/v1/loan-products")
    public Mono<ResponseEntity<Object>> loanProducts() {
        return fineract.get("/loanproducts").map(resp -> {
            if (!resp.isOk() || resp.body() == null || !resp.body().isArray()) {
                return ResponseEntity.status(HttpStatus.BAD_GATEWAY)
                        .body((Object) new MeController.ApiError(502, "Bad Gateway", "下游产品查询失败"));
            }
            java.util.List<LoanProduct> items = new java.util.ArrayList<>();
            for (JsonNode p : resp.body()) {
                items.add(toLoanProduct(p));
            }
            return ResponseEntity.ok((Object) items);
        });
    }

    @Operation(responses = @ApiResponse(responseCode = "200",
            content = @Content(array = @ArraySchema(schema = @Schema(implementation = FixedDepositProduct.class)))))
    @GetMapping("/abnk/api/v1/fixed-deposit-products")
    public Mono<ResponseEntity<Object>> fixedDepositProducts() {
        return fineract.get("/fixeddepositproducts").map(resp -> {
            if (!resp.isOk() || resp.body() == null || !resp.body().isArray()) {
                return ResponseEntity.status(HttpStatus.BAD_GATEWAY)
                        .body((Object) new MeController.ApiError(502, "Bad Gateway", "下游产品查询失败"));
            }
            java.util.List<FixedDepositProduct> items = new java.util.ArrayList<>();
            for (JsonNode p : resp.body()) {
                items.add(new FixedDepositProduct(
                        p.path("id").asLong(),
                        p.path("name").asText(null),
                        p.path("description").asText(null),
                        p.path("nominalAnnualInterestRate").isNumber() ? p.path("nominalAnnualInterestRate").asDouble()
                                : 0.0,
                        p.path("minDepositTerm").isNumber() ? p.path("minDepositTerm").asInt() : null,
                        p.path("depositAmount").isNumber() ? p.path("depositAmount").asDouble() : null));
            }
            return ResponseEntity.ok((Object) items);
        });
    }

    // ── 贷款申请与详情 ──────────────────────────────────────────

    /** 契约 LoanApplicationRequest（purpose 可选——Fineract 申请载荷无 purpose 字段，对客保留不落库）。 */
    public record LoanApplicationRequest(Long productId, Double principal, Integer termMonths, String purpose) {
    }

    public record LoanApplicationResult(Long loanId, String status) {
    }

    @Operation(responses = @ApiResponse(responseCode = "200",
            content = @Content(schema = @Schema(implementation = LoanApplicationResult.class))))
    @PostMapping("/abnk/api/v1/loans")
    public Mono<ResponseEntity<Object>> applyLoan(@RequestBody LoanApplicationRequest request,
            ServerWebExchange exchange) {
        var clientId = CustomerContext.clientIdOf(exchange);
        if (clientId.isEmpty()) {
            return forbidden();
        }
        if (request == null || request.productId() == null || request.principal() == null
                || request.termMonths() == null || request.principal() <= 0 || request.termMonths() <= 0) {
            return Mono.just(ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body((Object) new MeController.ApiError(400, "Bad Request", "参数校验失败（金额 / 期限须为正）")));
        }
        long cid = clientId.getAsLong();
        return fineract.get("/loanproducts/" + request.productId())
                .flatMap(product -> {
                    if (!product.isOk() || product.body() == null) {
                        return Mono.just(ResponseEntity.status(HttpStatus.NOT_FOUND)
                                .body((Object) new MeController.ApiError(404, "Not Found", "贷款产品不存在")));
                    }
                    JsonNode p = product.body();
                    double min = p.path("minPrincipal").asDouble(0);
                    double max = p.path("maxPrincipal").asDouble(Double.MAX_VALUE);
                    int termMonths = p.path("numberOfRepayments").asInt(0) * Math.max(1, p.path("repaymentEvery").asInt(1));
                    if (request.principal() < min || request.principal() > max) {
                        return Mono.just(ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                .body((Object) new MeController.ApiError(400, "Bad Request",
                                        "申请本金须在产品区间 [" + min + ", " + max + "] 内")));
                    }
                    if (request.termMonths() != termMonths) {
                        return Mono.just(ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                .body((Object) new MeController.ApiError(400, "Bad Request",
                                        "期限与产品不符（产品期限 " + termMonths + " 个月）")));
                    }
                    return IdentityController.businessDateOfHolder(fineract).flatMap(today -> {
                        ObjectNode payload = mapper.createObjectNode();
                        payload.put("productId", request.productId());
                        payload.put("clientId", cid);
                        payload.put("loanType", "individual");
                        payload.put("principal", request.principal());
                        payload.put("loanTermFrequency", request.termMonths());
                        payload.put("loanTermFrequencyType", 2); // MONTHS
                        payload.put("numberOfRepayments", p.path("numberOfRepayments").asInt());
                        payload.put("repaymentEvery", p.path("repaymentEvery").asInt());
                        payload.put("repaymentFrequencyType", 2); // MONTHS
                        double rate = p.path("annualInterestRate").isNumber() ? p.path("annualInterestRate").asDouble()
                                : p.path("interestRatePerPeriod").asDouble(0);
                        payload.put("interestRatePerPeriod", rate);
                        if (p.path("amortizationType").path("id").isNumber()) {
                            payload.put("amortizationType", p.path("amortizationType").path("id").asInt());
                        } else {
                            payload.put("amortizationType", 1);
                        }
                        if (p.path("interestType").path("id").isNumber()) {
                            payload.put("interestType", p.path("interestType").path("id").asInt());
                        } else {
                            payload.put("interestType", 0);
                        }
                        payload.put("interestCalculationPeriodType", 1);
                        if (p.path("transactionProcessingStrategyCode").isTextual()) {
                            payload.put("transactionProcessingStrategyCode",
                                    p.path("transactionProcessingStrategyCode").asText());
                        } else {
                            payload.put("transactionProcessingStrategyCode", "mifos-standard-strategy");
                        }
                        payload.put("submittedOnDate", today.toString());
                        payload.put("expectedDisbursementDate", today.toString());
                        payload.put("locale", "en");
                        payload.put("dateFormat", "yyyy-MM-dd");
                        return fineract.post("/loans", payload).flatMap(created -> {
                            if (!created.isOk() || created.body() == null) {
                                return Mono.just(ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                        .body((Object) new MeController.ApiError(400, "Bad Request",
                                                downstreamMessage(created.body(), "贷款申请被拒绝"))));
                            }
                            long loanId = created.body().path("loanId").asLong(created.body().path("resourceId").asLong());
                            if (loanId <= 0) {
                                return Mono.just(ResponseEntity.status(HttpStatus.BAD_GATEWAY)
                                        .body((Object) new MeController.ApiError(502, "Bad Gateway",
                                                "下游未返回贷款编号")));
                            }
                            // 回查初始状态（契约 status：Submitted and pending approval）
                            return fineract.get("/loans/" + loanId).map(loan -> ResponseEntity.ok((Object) new LoanApplicationResult(
                                    loanId, loan.body() == null ? null
                                            : loan.body().path("status").path("value").asText(null))));
                        });
                    });
                });
    }

    @Operation(responses = @ApiResponse(responseCode = "200",
            content = @Content(schema = @Schema(implementation = LoanDetail.class))))
    @GetMapping("/abnk/api/v1/loans/{id}")
    public Mono<ResponseEntity<Object>> loanDetail(@PathVariable long id, ServerWebExchange exchange) {
        var clientId = CustomerContext.clientIdOf(exchange);
        if (clientId.isEmpty()) {
            return forbidden();
        }
        return fineract.get("/loans/" + id).map(resp -> {
            if (!resp.isOk() || resp.body() == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body((Object) new MeController.ApiError(404, "Not Found", "贷款不存在"));
            }
            JsonNode loan = resp.body();
            if (loan.path("clientId").asLong() != clientId.getAsLong()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body((Object) new MeController.ApiError(404, "Not Found", "贷款不存在或不属于当前客户"));
            }
            Integer termMonths = loan.path("loanTermFrequency").isNumber() ? loan.path("loanTermFrequency").asInt()
                    : (loan.path("numberOfRepayments").isNumber()
                            ? loan.path("numberOfRepayments").asInt() * Math.max(1, loan.path("repaymentEvery").asInt(1))
                            : null);
            String disbursed = FineractClient.isoDate(FineractClient.at(loan, "timeline", "actualDisbursementDate"));
            Double outstanding = FineractClient.at(loan, "summary", "totalOutstanding") != null
                    && FineractClient.at(loan, "summary", "totalOutstanding").isNumber()
                            ? FineractClient.at(loan, "summary", "totalOutstanding").asDouble()
                            : null;
            return ResponseEntity.ok((Object) new LoanDetail(
                    loan.path("id").asLong(),
                    loan.path("loanProductName").asText(loan.path("productName").asText(null)),
                    loan.path("principal").isNumber() ? loan.path("principal").asDouble() : null,
                    loan.path("annualInterestRate").isNumber() ? loan.path("annualInterestRate").asDouble() : null,
                    termMonths,
                    loan.path("status").path("value").asText(null),
                    FineractClient.isoDate(FineractClient.at(loan, "timeline", "submittedOnDate")),
                    disbursed,
                    outstanding));
        });
    }

    // ── 私有 ────────────────────────────────────────────────────

    private LoanProduct toLoanProduct(JsonNode p) {
        Double rate = p.path("annualInterestRate").isNumber() ? p.path("annualInterestRate").asDouble()
                : (p.path("interestRatePerPeriod").isNumber() ? p.path("interestRatePerPeriod").asDouble() : null);
        int term = p.path("numberOfRepayments").asInt(0) * Math.max(1, p.path("repaymentEvery").asInt(1));
        String frequency = p.path("repaymentFrequencyType").path("value").asText("Months").toUpperCase()
                .replace(" ", "_");
        String amortization = p.path("amortizationType").path("value").asText("");
        String repaymentMethod = amortization.toLowerCase().contains("equal installment") ? "EQUAL_INSTALLMENTS"
                : (amortization.isBlank() ? "EQUAL_INSTALLMENTS" : amortization.toUpperCase().replace(" ", "_"));
        return new LoanProduct(
                p.path("id").asLong(),
                p.path("name").asText(null),
                p.path("description").asText(null),
                rate,
                term,
                frequency,
                p.path("minPrincipal").isNumber() ? p.path("minPrincipal").asDouble() : null,
                p.path("maxPrincipal").isNumber() ? p.path("maxPrincipal").asDouble() : null,
                repaymentMethod);
    }

    public static String downstreamMessage(JsonNode errorBody, String fallback) {
        if (errorBody != null) {
            String msg = errorBody.path("defaultUserMessage").asText(null);
            if (msg != null) {
                return msg;
            }
            if (errorBody.has("errors") && errorBody.get("errors").isArray() && !errorBody.get("errors").isEmpty()) {
                return errorBody.get("errors").get(0).path("defaultUserMessage").asText(fallback);
            }
        }
        return fallback;
    }

    private static Mono<ResponseEntity<Object>> forbidden() {
        return Mono.just(ResponseEntity.status(HttpStatus.FORBIDDEN)
                .body((Object) new MeController.ApiError(403, "Forbidden", "customer channel required")));
    }

    // ── 契约 DTO ────────────────────────────────────────────────

    public record LoanProduct(Long id, String name, String description, Double interestRate, Integer termFrequency,
            String termPeriodFrequencyType, Double minPrincipalAmount, Double maxPrincipalAmount,
            String repaymentMethod) {
    }

    public record FixedDepositProduct(Long id, String name, String description, Double interestRate,
            Integer depositPeriod, Double minDepositAmount) {
    }

    public record LoanDetail(Long loanId, String productName, Double principal, Double interestRate,
            Integer termMonths, String status, String submittedOnDate, String disbursedOnDate,
            Double totalOutstanding) {
    }
}
