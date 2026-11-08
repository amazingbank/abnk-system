package ai.amazingbank.gateway.auth;

import java.time.Clock;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.reactive.EnableWebFluxSecurity;
import org.springframework.security.config.web.server.ServerHttpSecurity;
import org.springframework.security.web.server.SecurityWebFilterChain;

/**
 * Spring Security 配套配置（P2.2 引入 starter-security 的放行清单落地）。
 *
 * <p>鉴权策略刻意为全放行（permitAll）：真正的通道鉴权由 {@link BearerTokenFilter}
 * （GlobalFilter，D2 简化登录口径——网关自签 JWT）执行。Spring Security 在此只占框架位：
 * 若不显式放行，starter 默认会把全部端点锁 401（P2.1 延后引入的原因）；P3 若换
 * Keycloak/OIDC，替换点即本层（改 resource-server JWT 校验），业务过滤器不动。
 */
@Configuration
@EnableWebFluxSecurity
public class SecurityConfig {

    @Bean
    SecurityWebFilterChain securityWebFilterChain(ServerHttpSecurity http) {
        return http
                .csrf(ServerHttpSecurity.CsrfSpec::disable)
                .httpBasic(ServerHttpSecurity.HttpBasicSpec::disable)
                .formLogin(ServerHttpSecurity.FormLoginSpec::disable)
                .authorizeExchange(exchanges -> exchanges.anyExchange().permitAll())
                .build();
    }

    /** JwtService 时钟注入点：单测经固定/偏移 Clock 覆盖过期分支。 */
    @Bean
    Clock clock() {
        return Clock.systemUTC();
    }
}
