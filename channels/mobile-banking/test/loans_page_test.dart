import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'helpers/test_app.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('贷款页：产品展示与申请提交回显', (tester) async {
    await loginAndSettle(tester);
    await switchTab(tester, 2);
    expect(find.text('ABNK 消费贷'), findsOneWidget);
    expect(find.text('12.0%'), findsOneWidget);
    expect(find.text('等额本息'), findsOneWidget);

    // 打开申请表单并提交
    await tester.tap(find.byKey(const Key('loan-apply-11')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('loan-amount')), '20000');
    await tester.tap(find.byKey(const Key('loan-submit')));
    await tester.pumpAndSettle();

    expect(find.textContaining('申请已提交'), findsOneWidget);
    expect(find.textContaining('等待审批'), findsOneWidget);
  });
}
