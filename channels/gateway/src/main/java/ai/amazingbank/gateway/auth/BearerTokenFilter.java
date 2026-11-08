package ai.amazingbank.gateway.auth;

import java.nio.charset.StandardCharsets;
import java.util.List;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.core.Ordered;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.util.AntPathMatcher;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

/**
 * Bearer 校验过滤器（GlobalFilter）：放行清单（/login、/actuator/health，application.yml
 * abnk.security.public-paths）之外的路径强制 Authorization: Bearer；解析成功后
 * sub / channel 写入请求属性（P2.3+ 对客聚合按 sub 反查、P2.5 通道隔离按 channel 判定）。
 */
@Component
public class BearerTokenFilter implements GlobalFilter, Ordered {

    /** 请求属性键：token subject（customerId 或 username）与通道。 */
    public static final String ATTR_SUB = "abnk.auth.sub";
    public static final String ATTR_CHANNEL = "abnk.auth.channel";

    private static final AntPathMatcher MATCHER = new AntPathMatcher();

    private final JwtService jwtService;
    private final List<String> publicPaths;

    public BearerTokenFilter(JwtService jwtService,
            @Value("${abnk.security.public-paths}") List<String> publicPaths) {
        this.jwtService = jwtService;
        this.publicPaths = List.copyOf(publicPaths);
    }

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        String path = exchange.getRequest().getPath().value();
        if (publicPaths.stream().anyMatch(pattern -> MATCHER.match(pattern, path))) {
            return chain.filter(exchange);
        }
        String authorization = exchange.getRequest().getHeaders().getFirst(HttpHeaders.AUTHORIZATION);
        String token = authorization != null && authorization.startsWith("Bearer ")
                ? authorization.substring("Bearer ".length())
                : null;
        if (token == null || token.isBlank()) {
            return unauthorized(exchange, "missing bearer token");
        }
        try {
            JwtService.AuthToken parsed = jwtService.parse(token);
            exchange.getAttributes().put(ATTR_SUB, parsed.sub());
            exchange.getAttributes().put(ATTR_CHANNEL, parsed.channel());
            return chain.filter(exchange);
        } catch (JwtService.JwtAuthException e) {
            return unauthorized(exchange, "invalid or expired token");
        }
    }

    private Mono<Void> unauthorized(ServerWebExchange exchange, String message) {
        ServerHttpResponse response = exchange.getResponse();
        response.setStatusCode(HttpStatus.UNAUTHORIZED);
        response.getHeaders().setContentType(MediaType.APPLICATION_JSON);
        byte[] body = ("{\"error\":\"unauthorized\",\"message\":\"" + message + "\"}")
                .getBytes(StandardCharsets.UTF_8);
        return response.writeWith(Mono.just(response.bufferFactory().wrap(body)));
    }

    @Override
    public int getOrder() {
        // 早于路由转发类 GlobalFilter（NettyRoutingFilter 等），晚于 SCG 内部核心过滤器
        return -100;
    }
}
