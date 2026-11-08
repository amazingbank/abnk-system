package ai.amazingbank.gateway.customer;

/**
 * 对客脱敏口径（P2.3 契约冻结口径的单一实现点；P1 原型 mock 同款形态）。
 *
 * <ul>
 *   <li>displayName：姓 + 名首字（「王 POC-A1107104347」→「王 P.」——Fineract displayName
 *       首词 = 中文语境的姓，次词收敛为首字；单词名原样）</li>
 *   <li>mobileNo：前 3 + 中间掩码 + 后 2（「13504347001」→「135******01」）</li>
 *   <li>accountNo：前 4 + ** + 后 4（「000000011」→「0000**0011」；短于 9 位全掩码）</li>
 *   <li>documentKey：前 4 + 掩码 + 后 3（「ID-A-1107104347」→「ID-A*********347」）</li>
 * </ul>
 */
public final class Masking {

    private Masking() {
    }

    /** 姓 + 名首字（对客契约 UserProfile.displayName 口径）。 */
    public static String displayName(String raw) {
        if (raw == null || raw.isBlank()) {
            return "";
        }
        String trimmed = raw.trim();
        int sp = trimmed.indexOf(' ');
        if (sp < 0) {
            return trimmed;
        }
        String family = trimmed.substring(0, sp);
        String given = trimmed.substring(sp + 1).trim();
        return given.isEmpty() ? family : family + " " + given.charAt(0) + ".";
    }

    /** 手机号掩码：保留前 3 后 2，中间位数以 * 逐位替换（11 位 → 135******01）。 */
    public static String mobile(String raw) {
        return maskKeepEnds(raw, 3, 2);
    }

    /** 账号尾号脱敏：保留前 4 后 4，中间折叠为 **（000000011 → 0000**0011）。 */
    public static String accountNo(String raw) {
        if (raw == null || raw.isBlank()) {
            return "";
        }
        if (raw.length() <= 8) {
            return "*".repeat(raw.length());
        }
        return raw.substring(0, 4) + "**" + raw.substring(raw.length() - 4);
    }

    /** 证件号脱敏：保留前 4 后 3，中间逐位 *（ID-A-1107104347 → ID-A*********347）。 */
    public static String documentKey(String raw) {
        return maskKeepEnds(raw, 4, 3);
    }

    private static String maskKeepEnds(String raw, int keepHead, int keepTail) {
        if (raw == null || raw.isBlank()) {
            return "";
        }
        if (raw.length() <= keepHead + keepTail) {
            return "*".repeat(raw.length());
        }
        int masked = raw.length() - keepHead - keepTail;
        return raw.substring(0, keepHead) + "*".repeat(masked) + raw.substring(raw.length() - keepTail);
    }
}
