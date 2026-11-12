package ai.amazingbank.gateway.auth;

import java.nio.charset.StandardCharsets;
import java.util.List;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.Ordered;
import org.springframework.http.HttpHeaders;
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
 * Bearer 校验过滤器（WebFilter）：放行清单（/login、/actuator/health，application.yml
 * abnk.security.public-paths）之外的路径强制 Authorization: Bearer；解析成功后
 * sub / channel 写入请求属性（P2.3 对客聚合按 sub 反查、P2.5 通道隔离按 channel 判定）。
 *
 * <p>**P2.3 架构调整**：由 GlobalFilter 改为 WebFilter——对客收敛面（/abnk/api/v1/*）自 P2.3
 * 起为网关本地 @RestController 聚合，本地请求不经 SCG 路由链（GlobalFilter 只包裹 route 执行），
 * WebFilter 对本地 controller 与 SCG 转发（bo 通道）统一生效。放行清单 / 401 载荷 / 属性键
 * 均保持 P2.2 口径不变。
 */
@Component
public class BearerTokenFilter implements WebFilter, Ordered {

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
    public Mono<Void> filter(ServerWebExchange exchange, WebFilterChain chain) {
        // CORS preflight 直通（P3.1 接线）：OPTIONS 预检不带业务语义与 Bearer 头，
        // 交由 SCG globalcors 的 CorsWebFilter 应答（本过滤器 order -100 先于其执行）。
        // 网关无业务 OPTIONS 端点，真实请求仍走下方鉴权链。
        if (HttpMethod.OPTIONS.equals(exchange.getRequest().getMethod())) {
            return chain.filter(exchange);
        }
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
        // CORS 回显（错误路径）：本过滤器(-100)短路响应不经过 SCG CorsWebFilter
        // （order LOWEST），浏览器跨域读取 401 需 ACAO——否则 SPA 把会话过期
        // 误报成网络故障。口径同 globalcors：allowedOriginPatterns "*" +
        // allowCredentials true（回显具体 Origin，非通配 *）。
        String origin = exchange.getRequest().getHeaders().getFirst(HttpHeaders.ORIGIN);
        if (origin != null && !origin.isBlank()) {
            response.getHeaders().set(HttpHeaders.ACCESS_CONTROL_ALLOW_ORIGIN, origin);
            response.getHeaders().set(HttpHeaders.ACCESS_CONTROL_ALLOW_CREDENTIALS, "true");
        }
        byte[] body = ("{\"error\":\"unauthorized\",\"message\":\"" + message + "\"}")
                .getBytes(StandardCharsets.UTF_8);
        return response.writeWith(Mono.just(response.bufferFactory().wrap(body)));
    }

    @Override
    public int getOrder() {
        // 全链路最前置（早于 BlacklistFilter(-90) 与 SCG 路由转发）
        return -100;
    }
}
