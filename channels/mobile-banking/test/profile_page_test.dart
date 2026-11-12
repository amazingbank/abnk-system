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

  testWidgets('我的页：语言区块标题与两选项展示（Part03 P3.3）',
      (tester) async {
    await loginAndSettle(tester);
    await switchTab(tester, 3);

    // 语言区块位于视口下方，先滚动可见（对齐退出登录测试的滚动口径）。
    // The language section sits below the fold: scroll it into view first
    // (same scrolling approach as the logout test).
    await tester.scrollUntilVisible(
      find.byKey(const Key('profile-language-zh')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    // 语言切换区块：标题 + 中文/English 两选项（zh 态默认选中中文）。
    // Language section: the title plus both options, with Chinese selected
    // by default in the zh state.
    expect(find.text('语言'), findsOneWidget);
    expect(find.text('中文'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.byKey(const Key('profile-language-zh')), findsOneWidget);
    expect(find.byKey(const Key('profile-language-en')), findsOneWidget);
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
