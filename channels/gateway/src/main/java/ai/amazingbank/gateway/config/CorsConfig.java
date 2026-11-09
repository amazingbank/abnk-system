package ai.amazingbank.gateway.config;

import java.util.List;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.reactive.CorsWebFilter;
import org.springframework.web.cors.reactive.UrlBasedCorsConfigurationSource;

/**
 * 全局 CORS 过滤器（P3.1 前后端接线）。
 *
 * <p>覆盖口径：WebFlux WebFilter 层，对本网关全部请求生效——含对客收敛面
 * {@code /abnk/api/v1/*}（本地 @RestController，P2.3 起不经 SCG 路由链，
 * SCG globalcors 的 CorsGatewayFilterApplicationListener 只覆盖路由转发）
 * 与 bo 通道转发。preflight OPTIONS 由本过滤器直接应答（BearerTokenFilter
 * 已对 OPTIONS 直通，order -100 先行放行）。
 *
 * <p>生产拓扑（P3.4）api 与静态站同域反代，CORS 头为冗余放行、无安全减损；
 * dev 形态 web 载体（:6280）跨 origin 访问依赖此配置。
 */
@Configuration
public class CorsConfig {

    @Bean
    CorsWebFilter corsWebFilter() {
        CorsConfiguration config = new CorsConfiguration();
        config.setAllowedOriginPatterns(List.of("*"));
        config.addAllowedMethod("*");
        config.addAllowedHeader("*");
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);
        return new CorsWebFilter(source);
    }
}
