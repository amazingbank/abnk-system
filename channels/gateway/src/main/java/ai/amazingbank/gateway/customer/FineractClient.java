package ai.amazingbank.gateway.customer;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

/**
 * 网关侧 Fineract 调用客户端（对客收敛面聚合的数据源）。
 *
 * <p>dev/bootRun 直连本地生产形态栈（{@code http://localhost:8081}）；服务器形态经
 * {@code ABNK_FINERACT_BASE} / {@code ABNK_FINERACT_PREFIX} 指向容器内网（与 SCG bo 路由同口径）。
 * Fineract 租户头与 Basic 双头在此统一注入（客户端传入的同名头不透传——WebClient 侧天然隔离）。
 *
 * <p>响应形态：{@link FineractResponse}（HTTP 状态 + JsonNode body）；body 可为 null（空响应体）。
 * 404 与其它非 2xx 由调用方按契约语义转换（404 资源不存在 / 400 参数校验失败等）。
 */
@Component
public class FineractClient {

    private static final DateTimeFormatter ISO = DateTimeFormatter.ISO_LOCAL_DATE;
    private static final ObjectMapper MAPPER = new ObjectMapper();

    private final WebClient webClient;

    public FineractClient(@Value("${abnk.fineract.base:http://localhost:8081}") String base,
            @Value("${abnk.fineract.prefix:/fineract-provider}") String prefix, WebClient.Builder builder) {
        this.webClient = builder.baseUrl(base + prefix + "/api/v1")
                .defaultHeader("Fineract-Platform-TenantId", "default")
                .defaultHeader("Authorization", "Basic bWlmb3M6cGFzc3dvcmQ=")
                .build();
    }

    public Mono<FineractResponse> get(String path) {
        return exchange(HttpMethod.GET, path, null, null);
    }

    public Mono<FineractResponse> get(String path, String query) {
        return exchange(HttpMethod.GET, path, null, query);
    }

    public Mono<FineractResponse> post(String path, ObjectNode body) {
        return exchange(HttpMethod.POST, path, body, null);
    }

    /** POST 带 command 查询参数（Fineract command 族：approve / activate / deposit 等）。 */
    public Mono<FineractResponse> post(String path, ObjectNode body, String query) {
        return exchange(HttpMethod.POST, path, body, query);
    }

    private Mono<FineractResponse> exchange(HttpMethod method, String path, ObjectNode body, String query) {
        return webClient.method(method).uri(uriBuilder -> {
            uriBuilder.path(path);
            if (query != null && !query.isBlank()) {
                for (String pair : query.split("&")) {
                    int eq = pair.indexOf('=');
                    if (eq > 0) {
                        uriBuilder.queryParam(pair.substring(0, eq), pair.substring(eq + 1));
                    }
                }
            }
            return uriBuilder.build();
        }).contentType(MediaType.APPLICATION_JSON)
                .bodyValue(body == null ? "{}" : body)
                .exchangeToMono(response -> response.bodyToMono(String.class)
                        .defaultIfEmpty("")
                        .map(raw -> {
                            JsonNode json = null;
                            if (!raw.isBlank()) {
                                try {
                                    json = MAPPER.readTree(raw);
                                } catch (Exception e) {
                                    json = null;
                                }
                            }
                            return new FineractResponse(response.statusCode().value(), json);
                        }));
    }

    /** Fineract 响应元组：status = 原始 HTTP 状态码；body = 解析后的 JSON（可为 null）。 */
    public record FineractResponse(int status, JsonNode body) {

        public boolean isOk() {
            return status >= 200 && status < 300;
        }

        /** body 为 JSON 数组时返回元素个数（null 安全）。 */
        public int arraySize() {
            return body != null && body.isArray() ? body.size() : 0;
        }
    }

    // ── Fineract JSON 形态工具（对客聚合共用）────────────────────

    /**
     * Fineract 日期字段（[2027,1,17] 数组形态）→ ISO 字符串；已是字符串则原样返回。
     */
    public static String isoDate(JsonNode node) {
        LocalDate d = localDate(node);
        return d != null ? d.format(ISO) : (node != null && node.isTextual() ? node.asText() : null);
    }

    /** Fineract 日期字段 → LocalDate；无效 / 缺失返回 null。 */
    public static LocalDate localDate(JsonNode node) {
        if (node == null) {
            return null;
        }
        if (node.isArray() && node.size() == 3) {
            return LocalDate.of(node.get(0).asInt(), node.get(1).asInt(), node.get(2).asInt());
        }
        if (node.isTextual()) {
            try {
                return LocalDate.parse(node.asText(), ISO);
            } catch (Exception e) {
                return null;
            }
        }
        return null;
    }

    /** 嵌套取值（null 安全）：obj.path("a").path("b") 形态的捷径。 */
    public static JsonNode at(JsonNode node, String... path) {
        JsonNode cur = node;
        for (String p : path) {
            cur = cur == null ? null : cur.path(p);
        }
        return cur == null || cur.isMissingNode() ? null : cur;
    }
}
