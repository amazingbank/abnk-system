import 'package:abnk_mobile/app.dart';
import 'package:abnk_mobile/app_scope.dart';
import 'package:abnk_mobile/data/mock/mock_account_repository.dart';
import 'package:abnk_mobile/data/mock/mock_auth_repository.dart';
import 'package:abnk_mobile/data/mock/mock_identity_repository.dart';
import 'package:abnk_mobile/data/mock/mock_loan_repository.dart';
import 'package:abnk_mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// locale 状态链测试（Part03 P3.2）：初始语言解析三断言
/// （存储优先 / 系统跟随 / setLocale 持久化 + 整树重建）。
/// Locale state chain tests (Part03 P3.2): three assertions on the initial
/// locale resolution (stored value wins / system fallback / setLocale
/// persistence + full-tree rebuild).
void main() {
  test('① 存储合法值优先：abnk.locale=en → 初始 en；非法值走系统兜底', () async {
    SharedPreferences.setMockInitialValues({'abnk.locale': 'en'});
    final prefs = await SharedPreferences.getInstance();
    expect(
      resolveInitialLocale(prefs, const [Locale('zh', 'CN')]),
      const Locale('en'),
    );
    // 非法存储值不采纳，落回系统语言探测。
    // An invalid stored value is rejected and the system detection applies.
    SharedPreferences.setMockInitialValues({'abnk.locale': 'fr'});
    final prefsInvalid = await SharedPreferences.getInstance();
    expect(
      resolveInitialLocale(prefsInvalid, const [Locale('zh', 'CN')]),
      const Locale('zh'),
    );
  });

  test('② 无存储跟随系统语言：任一 zh 开头 → zh，否则 → en', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    expect(
      resolveInitialLocale(prefs, const [Locale('zh', 'CN'), Locale('en', 'US')]),
      const Locale('zh'),
    );
    expect(
      resolveInitialLocale(prefs, const [Locale('en', 'US')]),
      const Locale('en'),
    );
  });

  testWidgets('③ setLocale 写存储并触发 MaterialApp 整树重建', (tester) async {
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
    await tester.pumpWidget(AbnkApp(state: state));
    await tester.pumpAndSettle();
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).locale,
      const Locale('zh'),
    );
    await state.setLocale(const Locale('en'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).locale,
      const Locale('en'),
    );
    // 切换结果已写入持久化存储。
    // The switch has been persisted.
    expect(prefs.getString(abnkLocaleKey), 'en');
  });
}
