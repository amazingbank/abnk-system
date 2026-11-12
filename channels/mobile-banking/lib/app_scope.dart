import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/mock/data_locale.dart';
import 'data/mock/fixture_bundle.dart';
import 'data/mock/resettable.dart';
import 'data/models/user.dart';
import 'data/repositories/account_repository.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/identity_repository.dart';
import 'data/repositories/loan_repository.dart';

/// locale 持久化存储键（Part03 P3.2，对齐 backoffice localStorage 键口径）。
/// Locale persistence key (Part03 P3.2, aligned with the backoffice
/// localStorage key convention).
const String abnkLocaleKey = 'abnk.locale';

/// 应用状态——持有 repository 集合与登录会话。
///
/// 页面层只经 [AppScope.of] 取依赖与状态，不直接构造 repository
/// （P3.1 接线 = 在 main 处把 mock 实现换成生成 client，页面零改动）。
class AppState extends ChangeNotifier {
  AppState({
    required this.auth,
    required this.identity,
    required this.account,
    required this.loan,
    Locale? locale,
    this._prefs,
  }) : locale = locale ?? const Locale('zh');

  final AuthRepository auth;
  final IdentityRepository identity;
  final AccountRepository account;
  final LoanRepository loan;

  /// 当前界面语言（zh/en，D8 小写简码）——经 [setLocale] 变更，
  /// notifyListeners 触发 MaterialApp 整树重建。
  /// Current UI locale (zh/en, D8 lowercase codes): mutated via [setLocale],
  /// whose notifyListeners rebuilds the whole MaterialApp tree.
  Locale locale;

  /// 偏好存储注入（Part03 P3.2）——main 异步启动时注入，测试注入 mock 形态。
  /// Injected preferences store (Part03 P3.2): provided by main during the
  /// async bootstrap, or a mock instance in tests.
  final SharedPreferences? _prefs;

  /// 数据纪元（Phase 7 D3 修订）：用户手动切换语言时自增——AbnkApp 以其为
  /// home 子树的 ValueKey，强制页面 State 重建、数据重新拉取（页面 future
  /// 在 initState 缓存，不感知 locale）。
  /// Data epoch (Phase 7 D3 revision): bumped on every manual language
  /// switch — AbnkApp uses it as the ValueKey of the home subtree, forcing
  /// page States to rebuild and refetch (page futures are cached in
  /// initState and unaware of the locale).
  int dataEpoch = 0;

  Session? _session;

  Session? get session => _session;

  bool get isLoggedIn => _session != null;

  Future<void> login(String username, String password) async {
    _session = await auth.login(username, password);
    notifyListeners();
  }

  Future<void> logout() async {
    await auth.logout();
    _session = null;
    notifyListeners();
  }

  /// 切换界面语言（Part03 P3.2）：更新 [locale] 并经 notifyListeners 整树
  /// 重建（ListenableBuilder → MaterialApp.locale），随后写入持久化存储
  /// （[abnkLocaleKey]）；未注入存储时仅切换不落盘。
  /// Switches the UI locale (Part03 P3.2): updates [locale] and rebuilds the
  /// whole tree via notifyListeners (ListenableBuilder → MaterialApp.locale),
  /// then persists it under [abnkLocaleKey]; without an injected store the
  /// switch simply does not persist.
  ///
  /// Phase 7 D3 修订（2026-11-12 用户拍板）：用户手动切换时数据集随切——
  /// [FixtureBundle.activate] 换目录 + Resettable repository 内存态清零 +
  /// [dataEpoch] 自增（AbnkApp 侧按 epoch 重建页面子树、重拉数据）。初始
  /// 数据语言 = 编译期 dataLocale 常量注入（与 UI 初始语言独立——zh 系统
  /// 用户首屏可为中文 UI + 英文数据）。remote 模式下无 Resettable 实现，
  /// 切换只影响 UI 词条（数据来自真实服务端，D3 边界）。
  /// Phase 7 revision of decision D3 (user's call, 2026-11-12): a manual
  /// switch also swaps the data set — [FixtureBundle.activate] flips the
  /// directory, Resettable repositories drop their in-memory state, and
  /// [dataEpoch] increments (AbnkApp rebuilds the page subtree per the epoch
  /// and refetches). The initial data locale stays the compile-time dataLocale
  /// injection, independent of the initial UI locale (a zh-system user may
  /// land on a Chinese UI with English data). Under remote mode nothing is
  /// Resettable, so the switch only affects UI strings (server data, D3
  /// boundary).
  Future<void> setLocale(Locale value) async {
    if (value == locale) return;
    locale = value;
    // 数据集随切 + 内存态重置（mock 模式；remote 模式下无 Resettable 实现者）。
    // The data set follows and in-memory state resets (mock mode; under
    // remote mode nothing implements Resettable).
    FixtureBundle.activate(dataLocaleCodeFor(value.languageCode));
    for (final repo in [auth, identity, account, loan]) {
      if (repo is Resettable) repo.reset();
    }
    dataEpoch += 1;
    notifyListeners();
    final prefs = _prefs;
    if (prefs == null) return;
    await prefs.setString(abnkLocaleKey, value.languageCode);
  }
}

/// repository + 会话的依赖注入入口。
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required super.notifier, required super.child});

  static AppScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!;

  AppState get state => notifier!;
}
