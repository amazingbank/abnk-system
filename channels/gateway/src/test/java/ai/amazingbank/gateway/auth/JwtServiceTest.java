package ai.amazingbank.gateway.auth;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.time.ZoneOffset;
import org.junit.jupiter.api.Test;

class JwtServiceTest {

    private static final String SECRET = "unit-test-jwt-secret-0123456789abcdef";
    private static final Instant NOW = Instant.parse("2026-11-08T00:00:00Z");
    private static final Duration TTL = Duration.ofMinutes(15);

    private static Clock fixedAt(Instant instant) {
        return Clock.fixed(instant, ZoneOffset.UTC);
    }

    @Test
    void issueParseRoundTripCarriesSubAndChannel() {
        JwtService service = new JwtService(SECRET, TTL, fixedAt(NOW));
        String token = service.issue("28", "customer");

        // JWT 三段式
        assertThat(token.split("\\.")).hasSize(3);

        JwtService.AuthToken parsed = service.parse(token);
        assertThat(parsed.sub()).isEqualTo("28");
        assertThat(parsed.channel()).isEqualTo("customer");
    }

    @Test
    void tokenExpiresAfterTtl() {
        JwtService signer = new JwtService(SECRET, TTL, fixedAt(NOW));
        String token = signer.issue("28", "customer");

        // 时钟偏移注入：解析侧推进到 TTL 之后（15min + 1s）
        JwtService verifier = new JwtService(SECRET, TTL, fixedAt(NOW.plus(TTL).plusSeconds(1)));
        assertThatThrownBy(() -> verifier.parse(token))
                .isInstanceOf(JwtService.TokenExpiredException.class);
    }

    @Test
    void tokenStillValidJustBeforeExpiry() {
        JwtService signer = new JwtService(SECRET, TTL, fixedAt(NOW));
        String token = signer.issue("1", "internal");

        JwtService verifier = new JwtService(SECRET, TTL, fixedAt(NOW.plus(TTL).minusSeconds(1)));
        assertThat(verifier.parse(token).sub()).isEqualTo("1");
    }

    @Test
    void wrongSecretRejected() {
        JwtService signer = new JwtService(SECRET, TTL, fixedAt(NOW));
        String token = signer.issue("28", "customer");

        JwtService otherSecret = new JwtService(SECRET + "-other", TTL, fixedAt(NOW));
        assertThatThrownBy(() -> otherSecret.parse(token))
                .isInstanceOf(JwtService.InvalidTokenException.class);
    }

    @Test
    void malformedTokenRejected() {
        JwtService service = new JwtService(SECRET, TTL, fixedAt(NOW));
        assertThatThrownBy(() -> service.parse("not-a-jwt"))
                .isInstanceOf(JwtService.InvalidTokenException.class);
        assertThatThrownBy(() -> service.parse("aaa.bbb.ccc"))
                .isInstanceOf(JwtService.InvalidTokenException.class);
    }

    @Test
    void internalChannelClaimRoundTrip() {
        JwtService service = new JwtService(SECRET, TTL, fixedAt(NOW));
        String token = service.issue("admin", "internal");
        assertThat(service.parse(token).channel()).isEqualTo("internal");
    }
}
