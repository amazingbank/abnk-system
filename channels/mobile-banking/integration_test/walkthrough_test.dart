import 'dart:io';

import 'package:abnk_mobile/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// 三载体走查核心路径（VP1.3.5 iOS / VP1.3.6 Android）：
/// 登录 → 首页 → 转账 → 明细，四页各截屏归档。
/// Android surface 已转换为可截图视图（一次性转换标记）。
var _surfaceConverted = false;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('ABNK 手机银行四页核心路径走查', (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));
    await _shot(binding, tester, '01-login');

    await tester.enterText(find.byKey(const Key('login-username')), 'alice');
    await tester.enterText(find.byKey(const Key('login-password')), 'password');
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle(const Duration(seconds: 3));
    await _shot(binding, tester, '02-home');

    await tester.tap(find.text('转账'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.enterText(find.byKey(const Key('transfer-amount')), '2500');
    await tester.enterText(find.byKey(const Key('transfer-note')), '还房贷');
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await _shot(binding, tester, '03-transfer');

    await tester.tap(find.byKey(const Key('transfer-submit')));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.tap(find.text('知道了'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await tester.tap(find.byType(NavigationDestination).at(1));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await _shot(binding, tester, '04-transactions');

    // 核心断言：转账后的新流水出现在明细（交易闭环可见）。
    expect(find.textContaining('还房贷'), findsOneWidget);
  });
}

Future<void> _shot(
  IntegrationTestWidgetsFlutterBinding binding,
  WidgetTester tester,
  String name,
) async {
  if (Platform.isAndroid && !_surfaceConverted) {
    // Android 截图前须把 Flutter surface 转为可截图视图（仅一次；
    // 本 Flutter 版本未提供 revert API，转换后保持即可）。
    await binding.convertFlutterSurfaceToImage();
    _surfaceConverted = true;
    await tester.pumpAndSettle();
  }
  await binding.takeScreenshot(name);
}
