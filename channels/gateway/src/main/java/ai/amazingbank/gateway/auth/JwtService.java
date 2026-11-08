package ai.amazingbank.gateway.auth;

import com.nimbusds.jose.JWSAlgorithm;
import com.nimbusds.jose.JWSHeader;
import com.nimbusds.jose.JWSSigner;
import com.nimbusds.jose.JWSVerifier;
import com.nimbusds.jose.crypto.MACSigner;
import com.nimbusds.jose.crypto.MACVerifier;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;
import java.security.SecureRandom;
import java.text.ParseException;
import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.util.Date;
import java.util.Set;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * HS256 JWT 签发/解析（D2 简化登录口径：网关自签短时效 token，Bearer 形态）。
 *
 * <p>密钥：env {@code ABNK_JWT_SECRET} 注入——开发默认值入 public 仓，生产值入 .github-private。
 * 时钟经 {@link Clock} bean 注入，单测用固定/偏移时钟覆盖过期分支（时钟偏移注入）。
 */
@Component
public class JwtService {

    public static final String CLAIM_CHANNEL = "channel";
    public static final String CHANNEL_CUSTOMER = "customer";
    public static final String CHANNEL_INTERNAL = "internal";
    private static final Set<String> VALID_CHANNELS = Set.of(CHANNEL_CUSTOMER, CHANNEL_INTERNAL);

    private final JWSSigner signer;
    private final JWSVerifier verifier;
    private final Clock clock;
    private final Duration ttl;

    private final SecureRandom random = new SecureRandom();

    public JwtService(@Value("${abnk.jwt.secret}") String secret,
            @Value("${abnk.jwt.ttl:PT15M}") Duration ttl,
            Clock clock) {
        try {
            this.signer = new MACSigner(secret);
            this.verifier = new MACVerifier(secret);
        } catch (Exception e) {
            throw new IllegalStateException("ABNK_JWT_SECRET invalid for HS256 (need >= 32 bytes)", e);
        }
        this.clock = clock;
        this.ttl = ttl;
    }

    /** 签发：claims = sub（clientId 或 username）+ channel + iat/exp（TTL 15min）。 */
    public String issue(String subject, String channel) {
        Instant now = clock.instant();
        JWTClaimsSet claims = new JWTClaimsSet.Builder()
                .subject(subject)
                .claim(CLAIM_CHANNEL, channel)
                .jwtID(String.format("%016x", random.nextLong()))
                .issueTime(Date.from(now))
                .expirationTime(Date.from(now.plus(ttl)))
                .build();
        try {
            SignedJWT jwt = new SignedJWT(new JWSHeader.Builder(JWSAlgorithm.HS256).build(), claims);
            jwt.sign(signer);
            return jwt.serialize();
        } catch (Exception e) {
            throw new IllegalStateException("JWT signing failed", e);
        }
    }

    public AuthToken parse(String token) {
        final SignedJWT jwt;
        try {
            jwt = SignedJWT.parse(token);
            if (!jwt.verify(verifier)) {
                throw new InvalidTokenException("signature verification failed");
            }
        } catch (ParseException e) {
            throw new InvalidTokenException("malformed JWT", e);
        } catch (InvalidTokenException e) {
            throw e;
        } catch (Exception e) {
            throw new InvalidTokenException("signature verification error", e);
        }
        try {
            JWTClaimsSet claims = jwt.getJWTClaimsSet();
            Date expiration = claims.getExpirationTime();
            if (expiration == null || !expiration.toInstant().isAfter(clock.instant())) {
                throw new TokenExpiredException("token expired");
            }
            String channel = claims.getStringClaim(CLAIM_CHANNEL);
            if (channel == null || !VALID_CHANNELS.contains(channel)) {
                throw new InvalidTokenException("missing or invalid channel claim");
            }
            if (claims.getSubject() == null || claims.getSubject().isBlank()) {
                throw new InvalidTokenException("missing subject claim");
            }
            return new AuthToken(claims.getSubject(), channel);
        } catch (ParseException e) {
            throw new InvalidTokenException("claims parsing failed", e);
        }
    }

    public long ttlSeconds() {
        return ttl.toSeconds();
    }

    public record AuthToken(String sub, String channel) {
    }

    /** 通道鉴权失败族——BearerTokenFilter 一律按 401 处理，异常类型仅供单测区分断言。 */
    public static class JwtAuthException extends RuntimeException {

        JwtAuthException(String message) {
            super(message);
        }

        JwtAuthException(String message, Throwable cause) {
            super(message, cause);
        }
    }

    public static final class InvalidTokenException extends JwtAuthException {

        InvalidTokenException(String message) {
            super(message);
        }

        InvalidTokenException(String message, Throwable cause) {
            super(message, cause);
        }
    }

    public static final class TokenExpiredException extends JwtAuthException {

        TokenExpiredException(String message) {
            super(message);
        }
    }
}
