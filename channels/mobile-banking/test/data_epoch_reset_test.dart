import 'package:abnk_mobile/app_scope.dart';
import 'package:abnk_mobile/data/mock/data_locale.dart';
import 'package:abnk_mobile/data/mock/fixture_bundle.dart';
import 'package:abnk_mobile/data/mock/mock_account_repository.dart';
import 'package:abnk_mobile/data/mock/mock_auth_repository.dart';
import 'package:abnk_mobile/data/mock/mock_identity_repository.dart';
import 'package:abnk_mobile/data/mock/mock_loan_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 数据集运行时切换链路测试（Part03 Phase 7 D3 修订）：
/// activate 两态/幂等、UI→数据码映射、repo reset、setLocale 纪元递增。
/// Data-set runtime-switch chain tests (Part03 Phase 7 D3 revision):
/// activate both states and idempotence, the UI→data code mapping, the
/// repository reset, and the setLocale epoch bump.
void main() {
  tearDownAll(() {
    // 恢复编译期初始目录，避免静态状态泄漏到其他测试文件。
    // Restore the compile-time initial directory so no static state leaks
    // into other test files.
    FixtureBundle.activate(dataLocale);
  });

  test('① FixtureBundle.activate 两态切换与同目录幂等', () {
    expect(FixtureBundle.activeDir, fixtureDirFor(dataLocale));
    FixtureBundle.activate('en-us');
    expect(FixtureBundle.activeDir, 'en-us');
    FixtureBundle.activate('en-us'); // 同目录幂等（不清缓存路径，无异常即过）
    FixtureBundle.activate('zh-cn');
    expect(FixtureBundle.activeDir, 'zh-cn');
  });

  test('② dataLocaleCodeFor：UI 码 → 数据集码映射', () {
    expect(dataLocaleCodeFor('zh'), 'zh-cn');
    expect(dataLocaleCodeFor('en'), 'en-us');
    // 大小写鲁棒。
    // Case-insensitive robustness.
    expect(dataLocaleCodeFor('EN'), 'en-us');
  });

  test('③ MockAccountRepository.reset 幂等清空（回种子态）', () {
    final repo = MockAccountRepository(latency: Duration.zero);
    repo.reset();
    repo.reset(); // 幂等：重复调用无异常。
    // Idempotent: repeated calls never throw.
  });

  testWidgets('④ setLocale → 数据集随切 + 纪元递增（zh→en）', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final state = AppState(
      auth: MockAuthRepository(latency: Duration.zero),
      identity: MockIdentityRepository(latency: Duration.zero),
      account: MockAccountRepository(latency: Duration.zero),
      loan: MockLoanRepository(latency: Duration.zero),
      locale: const Locale('zh'),
      prefs: prefs,
    );
    final epochBefore = state.dataEpoch;
    await state.setLocale(const Locale('en'));
    // 纪元递增（AbnkApp 据此重建页面子树）。
    // The epoch bumped (AbnkApp rebuilds the page subtree on it).
    expect(state.dataEpoch, epochBefore + 1);
    // 数据集目录随 UI 语言切换（en → en-us）。
    // The data-set directory follows the UI locale (en → en-us).
    expect(FixtureBundle.activeDir, 'en-us');
    // 持久化写入。
    // The switch persisted.
    expect(prefs.getString(abnkLocaleKey), 'en');
    await state.setLocale(const Locale('zh'));
    expect(FixtureBundle.activeDir, 'zh-cn');
    expect(state.dataEpoch, epochBefore + 2);
  });
}
