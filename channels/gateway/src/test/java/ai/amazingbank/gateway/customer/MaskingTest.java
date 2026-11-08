package ai.amazingbank.gateway.customer;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;

/**
 * 对客脱敏口径单测（P2.3；形态与 P1 原型 mock fixtures 同款——me.json / accounts.json 互验）。
 */
class MaskingTest {

    @Test
    void displayNameFamilyPlusGivenInitial() {
        // 种子客户 A（中文姓在前）：全名 → 姓 + 名首字
        assertThat(Masking.displayName("王 POC-A1107104347")).isEqualTo("王 P.");
        // 英文形态：首词保留 + 次词首字
        assertThat(Masking.displayName("Alice Green")).isEqualTo("Alice G.");
    }

    @Test
    void displayNameEdgeCases() {
        assertThat(Masking.displayName("单名")).isEqualTo("单名");
        assertThat(Masking.displayName("王 ")).isEqualTo("王");
        assertThat(Masking.displayName(null)).isEmpty();
        assertThat(Masking.displayName("")).isEmpty();
    }

    @Test
    void mobileKeepsHeadAndTail() {
        assertThat(Masking.mobile("13504347001")).isEqualTo("135******01");
        assertThat(Masking.mobile("13800138000")).isEqualTo("138******00");
    }

    @Test
    void mobileShortInputFullyMasked() {
        assertThat(Masking.mobile("135")).isEqualTo("***");
        assertThat(Masking.mobile(null)).isEmpty();
    }

    @Test
    void accountNoKeepsHead4Tail4() {
        // Fineract accountNo=000000011（9 位）→ 0000**0011（P1 mock 同款形态）
        assertThat(Masking.accountNo("000000011")).isEqualTo("0000**0011");
        assertThat(Masking.accountNo("000000012")).isEqualTo("0000**0012");
    }

    @Test
    void accountNoShortInputFullyMasked() {
        assertThat(Masking.accountNo("00012")).isEqualTo("*****");
        assertThat(Masking.accountNo(null)).isEmpty();
    }

    @Test
    void documentKeyKeepsHead4Tail3() {
        // 15 位（前4 + 8星 + 后3）；18 位身份证（前4 + 11星 + 后3）
        assertThat(Masking.documentKey("ID-A-1107104347")).isEqualTo("ID-A********347");
        assertThat(Masking.documentKey("33010619900101001X")).isEqualTo("3301***********01X");
    }
}
