package ai.amazingbank.gateway.customer;

import com.fasterxml.jackson.databind.JsonNode;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

/**
 * GET /abnk/api/v1/me —— 当前客户资料（对客收敛 + 脱敏口径，P2.3）。
 *
 * <p>按 token sub（clientId）反查 Fineract GET /clients/{id}；姓名（姓 + 名首字）与手机号
 * （尾号形态）脱敏；不透传证件号等任何 Fineract 内部字段（对照断言见 taskP2.3 证据）。
 */
@RestController
public class MeController {

    /** 统一错误载荷（契约 ErrorResponse 口径）。 */
    public record ApiError(int status, String error, String message) {
    }

    private final FineractClient fineract;

    public MeController(FineractClient fineract) {
        this.fineract = fineract;
    }

    @Operation(responses = @ApiResponse(responseCode = "200",
            content = @Content(schema = @Schema(implementation = UserProfile.class))))
    @GetMapping("/abnk/api/v1/me")
    public Mono<ResponseEntity<Object>> me(ServerWebExchange exchange) {
        var clientId = CustomerContext.clientIdOf(exchange);
        if (clientId.isEmpty()) {
            return Mono.just(ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body((Object) new ApiError(403, "Forbidden", "customer channel required")));
        }
        return fineract.get("/clients/" + clientId.getAsLong())
                .map(resp -> {
                    if (!resp.isOk() || resp.body() == null) {
                        return ResponseEntity.status(HttpStatus.NOT_FOUND)
                                .body((Object) new ApiError(404, "Not Found", "客户不存在"));
                    }
                    JsonNode c = resp.body();
                    return ResponseEntity.ok((Object) new UserProfile(
                            c.path("id").asLong(),
                            text(c, "externalId"),
                            text(c, "firstname"),
                            text(c, "lastname"),
                            Masking.displayName(text(c, "displayName")),
                            Masking.mobile(text(c, "mobileNo")),
                            text(c, "emailAddress"),
                            text(c, "officeName")));
                });
    }

    static String text(JsonNode node, String field) {
        JsonNode v = node.get(field);
        return v == null || v.isNull() ? null : v.asText();
    }

    /** 契约 UserProfile（全部必填字段；emailAddress/officeName 可为 null 时按契约仍输出键）。 */
    public record UserProfile(Long clientId, String externalId, String firstname, String lastname,
            String displayName, String mobileNo, String emailAddress, String officeName) {
    }
}
