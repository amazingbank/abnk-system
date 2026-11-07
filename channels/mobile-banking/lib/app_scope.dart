import 'package:flutter/widgets.dart';

import 'data/models/user.dart';
import 'data/repositories/account_repository.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/identity_repository.dart';
import 'data/repositories/loan_repository.dart';

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
  });

  final AuthRepository auth;
  final IdentityRepository identity;
  final AccountRepository account;
  final LoanRepository loan;

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
}

/// repository + 会话的依赖注入入口。
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required super.notifier, required super.child});

  static AppScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!;

  AppState get state => notifier!;
}
