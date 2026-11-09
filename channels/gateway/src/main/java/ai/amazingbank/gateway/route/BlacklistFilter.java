package ai.amazingbank.gateway.route;

import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.List;
import org.springframework.core.Ordered;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.util.AntPathMatcher;
import org.springframework.web.server.ServerWebExchange;
import org.springframework.web.server.WebFilter;
import org.springframework.web.server.WebFilterChain;
import reactor.core.publisher.Mono;

/**
 * 对客通道路由级收敛 + 黑名单（P2.3；planning 层 api-gateway.md §3 生产黑名单口径）。
 *
 * <p>实现为 WebFilter（非 GlobalFilter——对客收敛面为网关本地 controller，本地请求不过
 * SCG 路由链；WebFilter 对本地 controller 与 SCG 转发两类请求统一生效）。order 在
 * BearerTokenFilter(-100) 之后：先鉴权（401）再收敛（403/404）。
 *
 * <p>规则（仅作用于 {@code /abnk/api/} 前缀）：
 * <ol>
 *   <li>黑名单路径段（jobs / internal / configurations / fineract.json）→ 403
 *       （Fineract 运维/诊断面——对客通道永不可达）</li>
 *   <li>不在契约收敛模式表（method + path）内 → 404（客户端不可见 Fineract 内部形态——
 *       含骨架期曾可达的 /offices 等全量转发面）</li>
 *   <li>契约内 → 放行（交由本地 controller 处理）</li>
 * </ol>
 */
@Component
public class BlacklistFilter implements WebFilter, Ordered {

    /** 生产黑名单路径段（对客通道语义：凡出现即 403）。 */
    private static final List<String> BLACKLIST_SEGMENTS = List.of("jobs", "internal", "configurations",
            "fineract.json");

    /** 契约对客收敛模式表（冻结契约 openapi.yaml 的对客面 method + path 全集）。 */
    private static final List<ContractRoute> CONTRACT_ROUTES = List.of(
            new ContractRoute(HttpMethod.GET, "/abnk/api/v1/me"),
            new ContractRoute(HttpMethod.GET, "/abnk/api/v1/me/identity"),
            new ContractRoute(HttpMethod.GET, "/abnk/api/v1/me/accounts"),
            new ContractRoute(HttpMethod.GET, "/abnk/api/v1/accounts/*/transactions"),
            // P2.4 转账聚合端点（契约内；controller 由 P2.4 落地，收敛面先行放行）
            new ContractRoute(HttpMethod.POST, "/abnk/api/v1/accounts/*/transfer"),
            new ContractRoute(HttpMethod.POST, "/abnk/api/v1/savings"),
            new ContractRoute(HttpMethod.GET, "/abnk/api/v1/loan-products"),
            new ContractRoute(HttpMethod.GET, "/abnk/api/v1/fixed-deposit-products"),
            new ContractRoute(HttpMethod.POST, "/abnk/api/v1/loans"),
            new ContractRoute(HttpMethod.GET, "/abnk/api/v1/loans/*"));

    private static final AntPathMatcher MATCHER = new AntPathMatcher();

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, WebFilterChain chain) {
        // CORS preflight 直通（P3.1 接线）：OPTIONS 预检无业务语义（契约表均为
        // GET/POST），不参与收敛判定，交由 CorsWebFilter 应答（order 在其后）。
        if (HttpMethod.OPTIONS.equals(exchange.getRequest().getMethod())) {
            return chain.filter(exchange);
        }
        String path = exchange.getRequest().getPath().value();
        if (!path.startsWith("/abnk/api/")) {
            return chain.filter(exchange);
        }
        if (isBlacklisted(path)) {
            return respond(exchange, HttpStatus.FORBIDDEN,
                    "{\"error\":\"forbidden\",\"message\":\"path not available on customer channel\"}");
        }
        HttpMethod method = exchange.getRequest().getMethod();
        boolean inContract = CONTRACT_ROUTES.stream()
                .anyMatch(route -> route.method().equals(method) && MATCHER.match(route.pattern(), path));
        if (!inContract) {
            return respond(exchange, HttpStatus.NOT_FOUND,
                    "{\"error\":\"not_found\",\"message\":\"no such endpoint on customer channel\"}");
        }
        return chain.filter(exchange);
    }

    private static boolean isBlacklisted(String path) {
        return Arrays.stream(path.split("/"))
                .anyMatch(segment -> BLACKLIST_SEGMENTS.contains(segment));
    }

    private static Mono<Void> respond(ServerWebExchange exchange, HttpStatus status, String body) {
        ServerHttpResponse response = exchange.getResponse();
        response.setStatusCode(status);
        response.getHeaders().setContentType(MediaType.APPLICATION_JSON);
        return response.writeWith(Mono.just(response.bufferFactory().wrap(body.getBytes(StandardCharsets.UTF_8))));
    }

    @Override
    public int getOrder() {
        // BearerTokenFilter(-100) 之后：鉴权先行（无 token 的黑名单请求也按 401 归位）
        return -90;
    }

    private record ContractRoute(HttpMethod method, String pattern) {
    }
}
