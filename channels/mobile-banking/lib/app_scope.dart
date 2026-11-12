import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Future<void> setLocale(Locale value) async {
    if (value == locale) return;
    locale = value;
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
