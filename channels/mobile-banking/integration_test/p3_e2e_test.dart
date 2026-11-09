import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:abnk_mobile/main.dart' as app;

/// 截图策略（P3.1 实测口径 2026-11-09）：integration_test 内不做
/// takeScreenshot——Android 的 convertFlutterSurfaceToImage 在本模拟器
/// 组合（API 36）上会挂起 request_data（P1 walkthrough 同逻辑当时可用，
/// 属环境敏感 flaky）。三载体截图统一走外部通道：
/// web = playwright、iOS = `simctl io screenshot`、Android = `adb screencap`。
Future<void> _shot(IntegrationTestWidgetsFlutterBinding binding, String name) async {}

/// P3.1 端到端走查（VP3.1.3，web 载体 + 真实网关）：
/// 登录 → 首页总览（真实余额）→ 转账 100 → 提交成功 → 明细出现新流水。
///
/// 运行口径（口令经 dart-define 注入，不落 public 仓）：
/// ```sh
/// flutter drive -d chrome \
///   --dart-define=ABNK_API_BASE=http://localhost:8080/abnk/api/v1 \
///   --dart-define=ABNK_DEMO_PASSWORD=<alice 口令> \
///   --target=integration_test/p3_e2e_test.dart \
///   --screenshot-dir=<归档目录>
/// ```
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const apiBase = String.fromEnvironment('ABNK_API_BASE');
  const password = String.fromEnvironment('ABNK_DEMO_PASSWORD');

  testWidgets('P3.1 手机银行端到端闭环（remote 模式）', (tester) async {
    // 前置自检：必须 remote 模式 + 口令注入（防误跑 mock）。
    expect(apiBase, isNotEmpty,
        reason: 'P3 走查必须 --dart-define=ABNK_API_BASE');
    expect(password, isNotEmpty,
        reason: 'P3 走查必须 --dart-define=ABNK_DEMO_PASSWORD');

    // 附言带唯一时间戳——明细页新流水的确定性断言锚点。
    final note = 'P3E2E-${DateTime.now().millisecondsSinceEpoch}';

    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));
    await _shot(binding, 'web-01-login');

    // ── 第 1 步：登录（网关 PBKDF2 凭据 + JWT） ──
    await tester.enterText(find.byKey(const Key('login-username')), 'alice');
    await tester.enterText(find.byKey(const Key('login-password')), password);
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    await _shot(binding, 'web-02-home');

    // ── 第 2 步：首页总览（真实 Fineract 余额 = P0.3 种子口径） ──
    expect(find.text('你好，王 P.'), findsOneWidget,
        reason: '登录后显示网关脱敏 displayName');
    final balance = _readTotalBalance(tester);
    expect(balance, matches(RegExp(r'^¥[\d,]+\.\d{2}$')),
        reason: '总余额以货币格式渲染（真实数据）');
    // ignore: avoid_print
    print('[P3-E2E] 首页活期总余额快照: $balance');

    // ── 第 3 步：转账 100（默认转出=11 → 转入=12） ──
    await tester.tap(find.text('转账'));
    await tester.pumpAndSettle(const Duration(seconds: 3));
    await tester.enterText(find.byKey(const Key('transfer-amount')), '100');
    await tester.enterText(find.byKey(const Key('transfer-note')), note);
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await _shot(binding, 'web-03-transfer');

    // ── 第 4 步：提交成功（网关聚合幂等 + 补偿链路） ──
    await tester.tap(find.byKey(const Key('transfer-submit')));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    await _shot(binding, 'web-04-success');
    expect(find.text('转账成功'), findsOneWidget, reason: '成功对话框出现');
    final dialogText = tester
        .widget<Text>(find.textContaining('转出账户新余额'))
        .data!
        .replaceAll('\n', ' | ');
    // ignore: avoid_print
    print('[P3-E2E] 转账成功对话框: $dialogText');
    await tester.tap(find.text('知道了'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // ── 第 5 步：明细出现新流水（runningBalance 变化） ──
    await tester.tap(find.byType(NavigationDestination).at(1));
    await tester.pumpAndSettle(const Duration(seconds: 3));
    await _shot(binding, 'web-05-transactions');
    expect(find.textContaining(note), findsOneWidget,
        reason: '明细出现本次转账新流水');
    // ignore: avoid_print
    print('[P3-E2E] 明细新流水断言 PASS: 附言 $note');
  });
}

/// 从首页「活期总余额」卡片抓取余额文本（不依赖 features 层 key，
/// 接线零改动断言的配套约束——走查脚本不反向要求页面加 key）。
String _readTotalBalance(WidgetTester tester) {
  final card = find
      .ancestor(
        of: find.text('活期总余额'),
        matching: find.byType(Container),
      )
      .first;
  final texts = tester
      .widgetList<Text>(find.descendant(of: card, matching: find.byType(Text)))
      .map((t) => t.data)
      .whereType<String>()
      .toList();
  return texts.firstWhere((t) => t.startsWith('¥'));
}
