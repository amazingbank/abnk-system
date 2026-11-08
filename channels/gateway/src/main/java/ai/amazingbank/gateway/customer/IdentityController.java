package ai.amazingbank.gateway.customer;

import java.time.LocalDate;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

/**
 * GET /abnk/api/v1/me/identity —— 当前客户证照信息（只读，P2.3）。
 *
 * <p>聚合 Fineract GET /clients/{id}/identifiers 首条证照；status 为纯读计算值
 * （expiryDate 对 Fineract 业务日期比较：EXPIRED / EXPIRING_SOON(30 天窗口) / VALID）。
 * **基线无任何拦截行为**——证照过期横幅 / 交易拦截为 POC 演示增量（插入点见 planning 层设计）。
 */
@RestController
public class IdentityController {

    /** 临期窗口（天）：expiry ∈ (业务日, 业务日+30] → EXPIRING_SOON。 */
    static final int EXPIRING_SOON_DAYS = 30;

    private final FineractClient fineract;

    public IdentityController(FineractClient fineract) {
        this.fineract = fineract;
    }

    @GetMapping("/abnk/api/v1/me/identity")
    public Mono<ResponseEntity<Object>> identity(ServerWebExchange exchange) {
        var clientId = CustomerContext.clientIdOf(exchange);
        if (clientId.isEmpty()) {
            return Mono.just(ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body((Object) new MeController.ApiError(403, "Forbidden", "customer channel required")));
        }
        long cid = clientId.getAsLong();
        return businessDateOfHolder(fineract).flatMap(businessDate -> fineract
                .get("/clients/" + cid + "/identifiers")
                .map(resp -> {
                    if (!resp.isOk() || resp.body() == null || !resp.body().isArray()
                            || resp.body().isEmpty()) {
                        return ResponseEntity.status(HttpStatus.NOT_FOUND)
                                .body((Object) new MeController.ApiError(404, "Not Found", "无证照记录"));
                    }
                    var identifier = resp.body().get(0);
                    LocalDate expiry = FineractClient.localDate(identifier.get("expiryDate"));
                    LocalDate issuance = FineractClient.localDate(identifier.get("issuanceDate"));
                    return ResponseEntity.ok((Object) new IdentityInfo(
                            identifier.path("documentType").path("id").asLong(),
                            FineractClient.at(identifier, "documentType", "name") == null ? null
                                    : identifier.path("documentType").path("name").asText(),
                            Masking.documentKey(identifier.path("documentKey").asText(null)),
                            deriveStatus(businessDate, expiry),
                            issuance == null ? null : issuance.toString(),
                            expiry == null ? null : expiry.toString()));
                }));
    }

    /** 拉取 Fineract 业务日期（BUSINESS_DATE 条目；缺失 / 失败回退系统当前日期）。 */
    public static Mono<LocalDate> businessDateOfHolder(FineractClient fineract) {
        return fineract.get("/businessdate")
                .map(resp -> businessDateOf(resp.body()))
                .defaultIfEmpty(LocalDate.now());
    }

    /** 业务日期（Fineract GET /businessdate 的 BUSINESS_DATE 条目）；缺失时回退系统当前日期。 */
    static LocalDate businessDateOf(com.fasterxml.jackson.databind.JsonNode businessDateArray) {
        if (businessDateArray != null && businessDateArray.isArray()) {
            for (var item : businessDateArray) {
                if ("BUSINESS_DATE".equals(item.path("type").asText())) {
                    LocalDate d = FineractClient.localDate(item.get("date"));
                    if (d != null) {
                        return d;
                    }
                }
            }
        }
        return LocalDate.now();
    }

    /** 到期状态三态（纯读计算——契约 enum VALID / EXPIRING_SOON / EXPIRED）。 */
    static String deriveStatus(LocalDate businessDate, LocalDate expiry) {
        if (expiry == null) {
            return "VALID";
        }
        if (expiry.isBefore(businessDate)) {
            return "EXPIRED";
        }
        if (!expiry.isAfter(businessDate.plusDays(EXPIRING_SOON_DAYS))) {
            return "EXPIRING_SOON";
        }
        return "VALID";
    }

    /** 契约 IdentityInfo（documentKey 为脱敏形态）。 */
    public record IdentityInfo(Long documentTypeId, String documentTypeName, String documentKey, String status,
            String issuanceDate, String expiryDate) {
    }
}
