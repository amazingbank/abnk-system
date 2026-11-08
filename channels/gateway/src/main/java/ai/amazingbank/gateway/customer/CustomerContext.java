package ai.amazingbank.gateway.customer;

import java.util.OptionalLong;
import org.springframework.web.server.ServerWebExchange;
import ai.amazingbank.gateway.auth.BearerTokenFilter;
import ai.amazingbank.gateway.auth.JwtService;

/**
 * 对客上下文：从请求属性（BearerTokenFilter 写入）解析当前 customer 通道 clientId。
 *
 * <p>非 customer 通道 token（internal / admin）或 sub 非数字 → empty，controller 统一按 403 拒绝
 * （对客面只认 customer token；反向隔离在 P2.5 BoRouteFilter）。
 */
public final class CustomerContext {

    private CustomerContext() {
    }

    public static OptionalLong clientIdOf(ServerWebExchange exchange) {
        Object sub = exchange.getAttributes().get(BearerTokenFilter.ATTR_SUB);
        Object channel = exchange.getAttributes().get(BearerTokenFilter.ATTR_CHANNEL);
        if (!JwtService.CHANNEL_CUSTOMER.equals(channel) || sub == null) {
            return OptionalLong.empty();
        }
        try {
            return OptionalLong.of(Long.parseLong(sub.toString()));
        } catch (NumberFormatException e) {
            return OptionalLong.empty();
        }
    }
}
