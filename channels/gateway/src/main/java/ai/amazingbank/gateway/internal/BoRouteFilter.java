package ai.amazingbank.gateway.internal;

import ai.amazingbank.gateway.auth.BearerTokenFilter;
import ai.amazingbank.gateway.auth.JwtService;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.List;
import org.springframework.core.Ordered;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import org.springframework.web.server.WebFilter;
import org.springframework.web.server.WebFilterChain;
import reactor.core.publisher.Mono;

/**
 * 内部通道路由过滤器（P2.5；附 2 决策——bo 公网可达 + 网关鉴权兜底）。
 *
 * <p>实现为 WebFilter（与 {@code BlacklistFilter} 同型——bo 通道为 SCG 转发，
 * WebFilter 对转发请求统一生效）。order 在 BearerTokenFilter(-100) 与
 * BlacklistFilter(-90) 之后：先鉴权（401）再通道隔离（403/404）。
 *
 * <p>规则（仅作用于 {@code /bo/api/} 前缀）：
 * <ol>
 *   <li>channel ≠ internal（customer token 或无通道属性）→ 403——对客 token
 *       永不可达内部面（通道隔离核心断言）</li>
 *   <li>黑名单残余段 fineract.json → 404（Fineract 运维/诊断面——对内部通道
 *       同样不可达；jobs / configurations 对内合法放行——运维操作属 Backoffice 职责）</li>
 *   <li>其余全量放行（含贷款 command 族与 identifiers PUT——旅程 Step 7 修复端点）</li>
 * </ol>
 *
 * <p>放行矩阵（application.yml bo-channel 路由注释同源维护）：
 * channel=internal → jobs ✅ / configurations ✅ / fineract.json ❌(404) / 其余 ✅；
 * channel=customer → /bo/api/** 全部 ❌(403)。
 */
@Component
public class BoRouteFilter implements WebFilter, Ordered {

    /** 内部通道黑名单残余段（fineract.json——对内对外均不可达）。 */
    private static final List<String> FORBIDDEN_SEGMENTS = List.of("fineract.json");

    private static final String BO_PREFIX = "/bo/api/";

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, WebFilterChain chain) {
        String path = exchange.getRequest().getPath().value();
        if (!path.startsWith(BO_PREFIX)) {
            return chain.filter(exchange);
        }
        String channel = exchange.getAttribute(BearerTokenFilter.ATTR_CHANNEL);
        if (!JwtService.CHANNEL_INTERNAL.equals(channel)) {
            return respond(exchange, HttpStatus.FORBIDDEN,
                    "{\"error\":\"forbidden\",\"message\":\"internal channel requires internal channel token\"}");
        }
        if (containsForbiddenSegment(path)) {
            return respond(exchange, HttpStatus.NOT_FOUND,
                    "{\"error\":\"not_found\",\"message\":\"path not available on internal channel\"}");
        }
        return chain.filter(exchange);
    }

    private static boolean containsForbiddenSegment(String path) {
        return Arrays.stream(path.split("/"))
                .anyMatch(segment -> FORBIDDEN_SEGMENTS.contains(segment));
    }

    private static Mono<Void> respond(ServerWebExchange exchange, HttpStatus status, String body) {
        ServerHttpResponse response = exchange.getResponse();
        response.setStatusCode(status);
        response.getHeaders().setContentType(MediaType.APPLICATION_JSON);
        return response.writeWith(Mono.just(response.bufferFactory().wrap(body.getBytes(StandardCharsets.UTF_8))));
    }

    @Override
    public int getOrder() {
        // BearerTokenFilter(-100) → BlacklistFilter(-90) → 本过滤器(-80)：
        // 无 token 401 先行，对客黑名单次之，内部通道隔离最后
        return -80;
    }
}
