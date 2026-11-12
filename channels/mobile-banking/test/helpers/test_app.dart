import 'dart:convert';
import 'dart:io';

import 'package:abnk_mobile/app.dart';
import 'package:abnk_mobile/app_scope.dart';
import 'package:abnk_mobile/data/mock/fixture_bundle.dart';
import 'package:abnk_mobile/data/mock/mock_account_repository.dart';
import 'package:abnk_mobile/data/mock/mock_auth_repository.dart';
import 'package:abnk_mobile/data/mock/mock_identity_repository.dart';
import 'package:abnk_mobile/data/mock/mock_loan_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _fixtureNames = [
  'me.json',
  'identity.json',
  'accounts.json',
  'transactions.json',
  'loan_products.json',
];

/// 测试前置：从磁盘直读 fixtures 预置 FixtureBundle 缓存（固定 zh-cn 态——
/// 与 `flutter test` 无 define 时 `dataLocale` 默认 zh-cn 一致，Phase 4
/// 任务 4.2 口径）。
///
/// flutter_test 的 FakeAsync 用例边界会让 rootBundle 的真实异步资产加载
/// 回复悬置，污染 CachingAssetBundle 的跨用例缓存——故测试路径完全绕开
/// rootBundle（运行时路径不受影响）。
/// Test bootstrap: seeds the FixtureBundle cache by reading fixtures
/// directly from disk, pinned to the zh-cn data set (matching the default
/// of `dataLocale` when `flutter test` runs without a define — the Phase 4
/// task 4.2 contract). The test path bypasses rootBundle entirely because
/// real async asset loading would suspend across FakeAsync cases and pollute
/// the CachingAssetBundle.
void seedFixtureBundle() {
  FixtureBundle.seedForTests({
    for (final name in _fixtureNames)
      name: jsonDecode(File('fixtures/zh-cn/$name').readAsStringSync())
          as Map<String, dynamic>,
  });
}

/// 测试用 app 装配——mock repository 零延迟注入。
AppState testAppState() => AppState(
      auth: MockAuthRepository(latency: Duration.zero),
      identity: MockIdentityRepository(latency: Duration.zero),
      account: MockAccountRepository(latency: Duration.zero),
      loan: MockLoanRepository(latency: Duration.zero),
    );

Widget buildTestApp() {
  seedFixtureBundle();
  return AbnkApp(state: testAppState());
}

/// 走登录主路径：alice / password → 首页就绪。
Future<void> loginAndSettle(WidgetTester tester) async {
  await tester.pumpWidget(buildTestApp());
  await tester.enterText(find.byKey(const Key('login-username')), 'alice');
  await tester.enterText(find.byKey(const Key('login-password')), 'password');
  await tester.tap(find.byKey(const Key('login-submit')));
  await tester.pumpAndSettle();
}

/// 切换主脚手架页签（IndexedStack 未选中页签对默认 finder 不可见）。
/// 0=首页 1=明细 2=贷款 3=我的。
Future<void> switchTab(WidgetTester tester, int index) async {
  await tester.tap(find.byType(NavigationDestination).at(index));
  await tester.pumpAndSettle();
}
