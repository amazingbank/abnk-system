package ai.amazingbank.gateway.transfer;

import ai.amazingbank.gateway.customer.CustomerContext;
import ai.amazingbank.gateway.customer.MeController.ApiError;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

/**
 * POST /abnk/api/v1/accounts/{id}/transfer —— 本人账户间转账（网关聚合，P2.4）。
 *
 * <p>Fineract 无满足语义的原生单端点（planning 层 mobile-banking-mvp.md M7 缺口表），
 * 由 {@link TransferService} 编排 withdrawal → deposit 两步；本 controller 承接入参校验
 * 与 customer 通道上下文（幂等键路由与归属校验在 service）。
 *
 * <p>契约 400 口径：金额非正 / 账户相同 / 余额不足（余额不足为下游拒绝的透传形态）。
 */
@RestController
public class TransferController {

    /**
     * 幂等键长度上限：Fineract 交易 externalId 上限 100 字符（validator），预留派生后缀
     * {@code -w/-d/-r}（2 字符）后客户端键最长 98。
     */
    static final int EXTERNAL_ID_MAX = 98;

    private final TransferService transferService;

    public TransferController(TransferService transferService) {
        this.transferService = transferService;
    }

    /** 契约 TransferRequest（externalId 为客户端幂等键）。 */
    public record TransferRequest(Long toAccountId, Double amount, String externalId, String note) {
    }

    @PostMapping("/abnk/api/v1/accounts/{id}/transfer")
    public Mono<ResponseEntity<Object>> transfer(@PathVariable long id, @RequestBody TransferRequest request,
            ServerWebExchange exchange) {
        var clientId = CustomerContext.clientIdOf(exchange);
        if (clientId.isEmpty()) {
            return Mono.just(ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body((Object) new ApiError(403, "Forbidden", "customer channel required")));
        }
        if (invalid(request)) {
            return Mono.just(ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body((Object) new ApiError(400, "Bad Request",
                            "参数校验失败（toAccountId / amount / externalId 必填，金额须为正）")));
        }
        if (request.toAccountId() == id) {
            return Mono.just(ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body((Object) new ApiError(400, "Bad Request", "转出与转入账户不能相同")));
        }
        return transferService.transfer(clientId.getAsLong(), id, request);
    }

    private static boolean invalid(TransferRequest request) {
        return request == null || request.toAccountId() == null || request.amount() == null
                || request.amount() <= 0 || request.externalId() == null || request.externalId().isBlank()
                || request.externalId().length() > EXTERNAL_ID_MAX;
    }
}
