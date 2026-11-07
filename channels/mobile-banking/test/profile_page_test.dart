import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'helpers/test_app.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('我的页：客户资料与证照有效期只读展示（种子快照：过期）',
      (tester) async {
    await loginAndSettle(tester);
    await switchTab(tester, 3);

    // 客户资料
    expect(find.text('Alice Green'), findsOneWidget);
    expect(find.text('用户名'), findsOneWidget);
    expect(find.text('alice'), findsOneWidget);

    // 证照信息（P0.3 种子：客户 A 证照 2020-01-01 过期）
    expect(find.text('证件信息（只读）'), findsOneWidget);
    expect(find.text('2020-01-01'), findsOneWidget);
    expect(find.text('已过期'), findsOneWidget);
  });

  testWidgets('我的页：退出登录回到登录页', (tester) async {
    await loginAndSettle(tester);
    await switchTab(tester, 3);

    await tester.scrollUntilVisible(
      find.byKey(const Key('profile-logout')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('profile-logout')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('login-username')), findsOneWidget);
    expect(find.text('你好，Alice Green'), findsNothing);
  });
}
