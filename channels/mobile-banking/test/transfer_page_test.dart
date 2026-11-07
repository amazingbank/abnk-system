import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'helpers/test_app.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('转账页：表单校验拦截无效金额', (tester) async {
    await loginAndSettle(tester);

    await tester.tap(find.text('转账'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('transfer-amount')), '0');
    await tester.tap(find.byKey(const Key('transfer-submit')));
    await tester.pumpAndSettle();

    expect(find.text('请输入有效金额'), findsOneWidget);
  });

  testWidgets('转账页：本人转账成功回显新余额', (tester) async {
    await loginAndSettle(tester);

    await tester.tap(find.text('转账'));
    await tester.pumpAndSettle();

    // 默认源账户 11（¥10,000）→ 目标账户 12
    await tester.enterText(find.byKey(const Key('transfer-amount')), '2500');
    await tester.enterText(find.byKey(const Key('transfer-note')), '测试转账');
    await tester.tap(find.byKey(const Key('transfer-submit')));
    await tester.pumpAndSettle();

    expect(find.text('转账成功'), findsOneWidget);
    expect(find.textContaining('¥7,500.00'), findsOneWidget);
  });
}
