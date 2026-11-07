import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'helpers/test_app.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('明细页：流水列表含类型、金额与 runningBalance（种子快照值）',
      (tester) async {
    await loginAndSettle(tester);
    await switchTab(tester, 1);

    // alice 默认账户 11（存入 10000 → 余额 10000）
    expect(find.text('初始存入'), findsOneWidget);
    expect(find.text('2027-01-17 · 存入'), findsOneWidget);
    expect(find.text('+¥10,000.00'), findsOneWidget);
    expect(find.text('余额 ¥10,000.00'), findsOneWidget);
  });

  testWidgets('明细页：切换账户加载另一账户流水', (tester) async {
    await loginAndSettle(tester);
    await switchTab(tester, 1);

    // 切换到账户 12（空流水）
    await tester.tap(find.byKey(const Key('tx-account')));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('0000**0012').last);
    await tester.pumpAndSettle();

    expect(find.text('暂无交易'), findsOneWidget);
  });
}
