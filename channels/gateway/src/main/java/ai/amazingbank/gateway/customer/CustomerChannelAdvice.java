package ai.amazingbank.gateway.customer;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import reactor.core.publisher.Mono;

/**
 * 对客面统一异常出口（P2.3）：编排类端点（定期开户链路）的下游失败按 502 收敛
 * （契约 Bad Gateway 口径——下游操作失败，含需人工核对的中间态说明）。
 */
@RestControllerAdvice
public class CustomerChannelAdvice {

    @ExceptionHandler(IllegalStateException.class)
    public Mono<ResponseEntity<Object>> downstreamFailure(IllegalStateException e) {
        return Mono.just(ResponseEntity.status(HttpStatus.BAD_GATEWAY)
                .body((Object) new MeController.ApiError(502, "Bad Gateway",
                        "下游操作失败（可能存在中间态，需人工核对）：" + e.getMessage())));
    }
}
