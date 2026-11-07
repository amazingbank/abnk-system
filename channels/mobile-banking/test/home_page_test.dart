import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'helpers/test_app.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('首页：账户总览展示活期余额与账户卡片（种子快照值）',
      (tester) async {
    await loginAndSettle(tester);

    // 活期总余额（alice：10000 + 0）
    expect(find.text('活期总余额'), findsOneWidget);
    expect(find.text('¥10,000.00'), findsWidgets);

    // 账户卡片（源/目标账户，P0.3 种子：account 11 / 12）
    expect(find.textContaining('0000**0011'), findsOneWidget);
    expect(find.textContaining('0000**0012'), findsOneWidget);

    // 快捷操作四入口
    expect(find.text('转账'), findsOneWidget);
    expect(find.text('定期'), findsOneWidget);
  });

  testWidgets('首页：bob 登录展示定期账户与到期日', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.enterText(find.byKey(const Key('login-username')), 'bob');
    await tester.enterText(find.byKey(const Key('login-password')), 'password');
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle();

    expect(find.text('你好，Bob Brown'), findsOneWidget);
    expect(find.text('定期账户'), findsOneWidget);
    expect(find.textContaining('2028-01-17'), findsOneWidget);
  });
}
