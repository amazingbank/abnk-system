package ai.amazingbank.gateway.transfer;

import ai.amazingbank.gateway.customer.AccountsController;
import ai.amazingbank.gateway.customer.FineractClient;
import ai.amazingbank.gateway.customer.FineractClient.FineractResponse;
import ai.amazingbank.gateway.customer.IdentityController;
import ai.amazingbank.gateway.customer.LoanController;
import ai.amazingbank.gateway.customer.MeController;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.github.benmanes.caffeine.cache.Cache;
import com.github.benmanes.caffeine.cache.Caffeine;
import java.time.Duration;
import java.time.LocalDate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

/**
 * 转账聚合服务（P2.4）：本人账户归属校验 → withdrawal → deposit 两步编排。
 *
 * <p><b>幂等</b>：客户端 {@code externalId} 为幂等键（缓存键按 clientId 隔离）。缓存命中直接返回
 * 首次结果；缓存未命中（如网关重启）兜底查 Fineract——两条子交易以派生 externalId
 * {@code <key>-w}/{@code <key>-d} 落账（Fineract 载荷实测支持，DB 层
 * {@code uk_m_sat_external_id} 全局唯一索引），回读 {@code GET /savingsaccounts/{id}/transactions/external-id/<key>-w}。
 *
 * <p><b>唯一索引的幂等推论</b>：交易 external_id 全局唯一，同键重复提交 withdrawal 会被 Fineract
 * 拒绝——并发双击天然被 DB 约束挡住；冲正（{@code <key>-r} 反向 deposit）后的同键重放返回
 * 失败终态（不重新执行，否则撞唯一约束），如需重试须换幂等键。
 *
 * <p><b>补偿</b>：deposit 失败时对已成功的 withdrawal 提交反向 deposit 冲正（accounting NONE
 * 产品口径——P0.3 种子声明），冲正成功回传 502 + 冲正单号；冲正也失败则终态告警日志 + 502
 * （人工对账口径，风险表声明）。
 *
 * <p>基线不做证件校验（POC 演示增量）。
 */
@Service
public class TransferService {

    /** 幂等缓存 TTL（计划口径 24h）。 */
    static final Duration IDEMPOTENCY_TTL = Duration.ofHours(24);

    private static final Logger log = LoggerFactory.getLogger(TransferService.class);

    private final FineractClient fineract;
    private final ObjectMapper mapper = new ObjectMapper();
    private final Cache<String, TransferResult> idempotency = Caffeine.newBuilder()
            .expireAfterWrite(IDEMPOTENCY_TTL)
            .maximumSize(10_000)
            .build();

    public TransferService(FineractClient fineract) {
        this.fineract = fineract;
    }

    /** 契约 TransferResult（幂等重放返回同值）。 */
    public record TransferResult(Long transactionId, Double newSourceBalance) {
    }

    /** 失败终态 502 载荷（reversalTransactionId 缺省 = 冲正未落账，人工对账口径）。 */
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public record TransferFailure(int status, String error, String message, Long reversalTransactionId) {
    }

    public Mono<ResponseEntity<Object>> transfer(long clientId, long sourceAccountId,
            TransferController.TransferRequest request) {
        TransferResult cached = idempotency.getIfPresent(cacheKey(clientId, request.externalId()));
        if (cached != null) {
            return Mono.just(ResponseEntity.ok((Object) cached));
        }
        return replayFromFineract(clientId, sourceAccountId, request)
                .switchIfEmpty(ownershipThenExecute(clientId, sourceAccountId, request));
    }

    // ── 幂等兜底（缓存未命中，如网关重启后）──────────────────────

    /**
     * 按 Fineract 落账痕迹恢复幂等：空 Mono = 无痕迹（走执行链）；非空 = 恢复首次结果（成功或失败终态）。
     *
     * <ul>
     *   <li>{@code <key>-w} 不存在 → 未执行过 → 空（执行链）</li>
     *   <li>{@code -w} + {@code -d} 均存在 → 转账完成 → 重建首次成功结果（transactionId = -w 交易，
     *       newSourceBalance = -w 的 runningBalance）</li>
     *   <li>{@code -w} 存在、{@code -d} 不存在、{@code -r} 存在 → 上次失败已冲正 → 502 终态
     *       （同键重放不重新执行——唯一索引会拒绝二次 -w；换键重试）</li>
     *   <li>{@code -w} 存在、{@code -d}/{@code -r} 均不存在 → 悬挂中间态 → 502 人工对账</li>
     * </ul>
     */
    private Mono<ResponseEntity<Object>> replayFromFineract(long clientId, long sourceAccountId,
            TransferController.TransferRequest request) {
        String key = request.externalId();
        return fetchTransaction(sourceAccountId, key + "-w")
                .flatMap(w -> fetchTransaction(request.toAccountId(), key + "-d")
                        .<ResponseEntity<Object>>map(d -> {
                            TransferResult result = new TransferResult(
                                    w.body().path("id").asLong(),
                                    w.body().path("runningBalance").isNumber()
                                            ? Double.valueOf(w.body().path("runningBalance").asDouble())
                                            : Double.valueOf(0));
                            idempotency.put(cacheKey(clientId, key), result);
                            return ResponseEntity.ok((Object) result);
                        })
                        .switchIfEmpty(fetchTransaction(sourceAccountId, key + "-r")
                                .<ResponseEntity<Object>>flatMap(reversal -> Mono.just(ResponseEntity
                                        .status(HttpStatus.BAD_GATEWAY)
                                        .body((Object) new TransferFailure(502, "Bad Gateway",
                                                "该转账上次未完成，已自动冲正（资金已退回转出账户）；如需重试请使用新的幂等键",
                                                reversal.body().path("id").asLong()))))
                                .switchIfEmpty(Mono.just(ResponseEntity.status(HttpStatus.BAD_GATEWAY)
                                        .body((Object) new TransferFailure(502, "Bad Gateway",
                                                "该转账处于中间态（withdrawal 已落账、deposit 与冲正记录缺失），需人工对账",
                                                null))))));
    }

    /** externalId 交易查询；非 2xx（404 = 不存在）→ 空 Mono。 */
    private Mono<FineractResponse> fetchTransaction(long accountId, String transactionExternalId) {
        return fineract
                .get("/savingsaccounts/" + accountId + "/transactions/external-id/" + transactionExternalId)
                .flatMap(resp -> resp.isOk() ? Mono.just(resp) : Mono.empty());
    }

    // ── 归属校验 + 执行链 ──────────────────────────────────────

    private Mono<ResponseEntity<Object>> ownershipThenExecute(long clientId, long sourceAccountId,
            TransferController.TransferRequest request) {
        return fineract.get("/clients/" + clientId + "/accounts").flatMap(accounts -> {
            if (!AccountsController.ownsAccount(accounts.body(), sourceAccountId)) {
                // 本人账户约束（写操作明确拒绝口径——VP2.4.4：转出账户非本人 → 403）
                return Mono.just(forbidden("转出账户不属于当前客户"));
            }
            if (!AccountsController.ownsAccount(accounts.body(), request.toAccountId())) {
                return Mono.just(forbidden("目标账户不属于当前客户"));
            }
            return IdentityController.businessDateOfHolder(fineract)
                    .flatMap(today -> executeTransfer(clientId, sourceAccountId, request, today));
        });
    }

    private Mono<ResponseEntity<Object>> executeTransfer(long clientId, long sourceAccountId,
            TransferController.TransferRequest request, LocalDate today) {
        return postTransaction(sourceAccountId, "withdrawal", request.externalId() + "-w", request, today)
                .flatMap(w -> {
                    if (!w.isOk()) {
                        if (w.status() >= 500) {
                            return Mono.just(gateway502("转出账户扣款失败（下游 " + w.status() + "）", null));
                        }
                        // 4xx 透传为契约 400（余额不足等 Fineract 拒绝语义，实测 403）
                        return Mono.just(badRequest(
                                LoanController.downstreamMessage(w.body(), "转账被拒绝")));
                    }
                    long withdrawalId = w.body().path("resourceId").asLong();
                    return postTransaction(request.toAccountId(), "deposit", request.externalId() + "-d", request,
                            today).flatMap(d -> {
                        if (d.isOk()) {
                            return newSourceBalance(sourceAccountId).<ResponseEntity<Object>>map(balance -> {
                                TransferResult result = new TransferResult(withdrawalId, balance);
                                idempotency.put(cacheKey(clientId, request.externalId()), result);
                                return ResponseEntity.ok((Object) result);
                            });
                        }
                        return compensate(sourceAccountId, request, today);
                    });
                });
    }

    /** deposit 失败 → 对已成功的 withdrawal 提交反向 deposit 冲正（{@code <key>-r}）。 */
    private Mono<ResponseEntity<Object>> compensate(long sourceAccountId, TransferController.TransferRequest request,
            LocalDate today) {
        return postTransaction(sourceAccountId, "deposit", request.externalId() + "-r", request, today)
                .flatMap(reversal -> {
                    if (reversal.isOk()) {
                        long reversalId = reversal.body().path("resourceId").asLong();
                        log.warn("[TRANSFER] deposit failed for key {} (src={} amount={}), compensated by reversal tx {}",
                                request.externalId(), sourceAccountId, request.amount(), reversalId);
                        return Mono.just(ResponseEntity.status(HttpStatus.BAD_GATEWAY)
                                .body((Object) new TransferFailure(502, "Bad Gateway",
                                        "转入账户入账失败，已自动冲正（资金已退回转出账户）；如需重试请使用新的幂等键",
                                        reversalId)));
                    }
                    log.error("[TRANSFER] reversal ALSO failed for key {} (src={} amount={}) — 终态悬挂，需人工对账",
                            request.externalId(), sourceAccountId, request.amount());
                    return Mono.just(ResponseEntity.status(HttpStatus.BAD_GATEWAY)
                            .body((Object) new TransferFailure(502, "Bad Gateway",
                                    "转入失败且冲正未成功，需人工对账", null)));
                })
                .onErrorResume(e -> {
                    log.error("[TRANSFER] reversal request error for key {} — 终态悬挂，需人工对账",
                            request.externalId(), e);
                    return Mono.just(ResponseEntity.status(HttpStatus.BAD_GATEWAY)
                            .body((Object) new TransferFailure(502, "Bad Gateway",
                                    "转入失败且冲正未成功，需人工对账", null)));
                });
    }

    /** 转账成功后回读转出账户当前余额（summary.accountBalance——P2.3 同款投影口径）。 */
    private Mono<Double> newSourceBalance(long sourceAccountId) {
        return fineract.get("/savingsaccounts/" + sourceAccountId).map(resp -> {
            JsonNode balance = FineractClient.at(resp.body(), "summary", "accountBalance");
            return balance != null && balance.isNumber() ? Double.valueOf(balance.asDouble())
                    : Double.valueOf(0);
        });
    }

    /** Fineract 交易提交（command=withdrawal|deposit；载荷字段均在请求白名单，validator 实测口径）。 */
    private Mono<FineractResponse> postTransaction(long accountId, String command, String transactionExternalId,
            TransferController.TransferRequest request, LocalDate today) {
        ObjectNode body = mapper.createObjectNode();
        body.put("transactionDate", today.toString());
        body.put("transactionAmount", request.amount());
        body.put("externalId", transactionExternalId);
        body.put("paymentTypeId", 1);
        body.put("note", "网关转账 " + request.externalId() + (request.note() == null ? "" : "：" + request.note()));
        body.put("locale", "en");
        body.put("dateFormat", "yyyy-MM-dd");
        return fineract.post("/savingsaccounts/" + accountId + "/transactions", body, "command=" + command);
    }

    private static String cacheKey(long clientId, String externalId) {
        return clientId + ":" + externalId;
    }

    private static ResponseEntity<Object> badRequest(String message) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body((Object) new MeController.ApiError(400, "Bad Request", message));
    }

    private static ResponseEntity<Object> forbidden(String message) {
        return ResponseEntity.status(HttpStatus.FORBIDDEN)
                .body((Object) new MeController.ApiError(403, "Forbidden", message));
    }

    private static ResponseEntity<Object> gateway502(String message, Long reversalTransactionId) {
        return ResponseEntity.status(HttpStatus.BAD_GATEWAY)
                .body((Object) new TransferFailure(502, "Bad Gateway", message, reversalTransactionId));
    }
}
