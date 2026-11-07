import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'helpers/test_app.dart';

void main() {
  setUpAll(() {
    // 与 main.dart 同口径：测试内禁运行时字体拉取，走自托管资产。
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('登录页：渲染品牌标题与占位元素', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    // ASDM logo（assets/brand/asdm-logo.png）出现在品牌标题上方。
    expect(find.byKey(const Key('login-logo')), findsOneWidget);
    expect(find.text('Amazing Bank'), findsOneWidget);
    expect(find.text('手机银行'), findsOneWidget);
    expect(find.byIcon(Icons.fingerprint), findsOneWidget);
    expect(find.byKey(const Key('login-username')), findsOneWidget);
    expect(find.byKey(const Key('login-password')), findsOneWidget);
  });

  testWidgets('登录页：错误凭据回显错误提示，不进入首页', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.enterText(find.byKey(const Key('login-username')), 'alice');
    await tester.enterText(find.byKey(const Key('login-password')), 'wrong');
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle();

    expect(find.text('用户名或密码错误'), findsOneWidget);
    expect(find.text('你好，Alice Green'), findsNothing);
  });

  testWidgets('登录页：正确凭据进入首页（问候语出现）', (tester) async {
    await loginAndSettle(tester);

    expect(find.text('你好，Alice Green'), findsOneWidget);
    expect(find.byKey(const Key('login-username')), findsNothing);
  });
}
