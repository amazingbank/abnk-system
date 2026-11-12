import 'package:abnk_mobile/data/mock/data_locale.dart';
import 'package:flutter_test/flutter_test.dart';

// 测试侧镜像常量：与 data_locale.dart 的 dataLocale 同 define 名、同默认值。
// 经「产物常量 == 镜像常量」对称验证 --dart-define 烙入事实：默认态
// （flutter test 无 define）两边均为 zh-cn；以
// --dart-define=ABNK_DATA_LOCALE=en-us 复跑时两边均为 en-us（V4.2.5 ③
// 两向判据）。
// EN: a compile-time mirror constant on the test side, sharing the same
// define name and default as dataLocale in data_locale.dart. The symmetric
// "product constant == mirror constant" assertion proves that --dart-define
// is baked into fromEnvironment constants: both sides read zh-cn by default
// and en-us when re-run with --dart-define=ABNK_DATA_LOCALE=en-us (the
// two-direction criterion of V4.2.5 ③).
const _mirror =
    String.fromEnvironment('ABNK_DATA_LOCALE', defaultValue: 'zh-cn');

void main() {
  test('① fixtureDirFor 两态目录映射（zh-cn / en-us）', () {
    // 纯函数不依赖编译期常量，两态直证。
    // The pure function is independent of the compile-time constant.
    expect(fixtureDirFor('zh-cn'), 'zh-cn');
    expect(fixtureDirFor('en-us'), 'en-us');
    // 未知语言落回 zh-cn（与 dataLocale 缺省一致）。
    // Unknown codes fall back to zh-cn, matching the dataLocale default.
    expect(fixtureDirFor('fr'), 'zh-cn');
  });

  test('② note 兜底双语映射两态（zh 中文 / en 语义重写）', () {
    // 转账无备注兜底：本人账户转账 / Self transfer（D2 语义重写）。
    // Transfer without a user note — the en value is a semantic rewrite.
    expect(transferNoteFor('zh-cn'), '本人账户转账');
    expect(transferNoteFor('en-us'), 'Self transfer');
    // 定期开户兜底：定期开户 / Fixed deposit opening。
    // Fixed-deposit opening fallback.
    expect(fixedDepositOpenNoteFor('zh-cn'), '定期开户');
    expect(fixedDepositOpenNoteFor('en-us'), 'Fixed deposit opening');
  });

  test('③ dataLocale 编译期常量随 --dart-define 烙入（默认 zh-cn / define en-us 两向）',
      () {
    // 对称验证：lib 常量与测试镜像常量同 define、同编译批次——两向复跑时
    // 断言值随 define 翻转（默认态 'zh-cn'，en define 态 'en-us'）。
    // EN: symmetric verification — the lib constant and the test-side mirror
    // share the define and the compilation batch; the expected value flips
    // with the define across the two runs ('zh-cn' by default, 'en-us' under
    // the en define).
    expect(dataLocale, _mirror);
    expect(dataLocale, _mirror == 'en-us' ? 'en-us' : 'zh-cn');
  });
}
