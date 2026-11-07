import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'helpers/test_app.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('定期开户页：产品展示（利率/期限/起存）与开户成功回显',
      (tester) async {
    await loginAndSettle(tester);

    await tester.tap(find.text('定期'));
    await tester.pumpAndSettle();

    // 产品卡片（P0.3 种子：定期产品 20）
    expect(find.text('ABNK 定期存款'), findsOneWidget);
    expect(find.text('3.0%'), findsOneWidget);
    expect(find.text('12 个月'), findsOneWidget);

    // 提交开户
    await tester.enterText(find.byKey(const Key('fd-amount')), '5000');
    await tester.tap(find.byKey(const Key('fd-submit')));
    await tester.pumpAndSettle();

    expect(find.text('定期开户成功'), findsOneWidget);
    expect(find.textContaining('到期日：'), findsOneWidget);
  });
}
