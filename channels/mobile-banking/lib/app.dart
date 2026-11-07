import 'package:flutter/material.dart';

import 'app_scope.dart';
import 'core/theme/app_theme.dart';
import 'features/login/login_page.dart';
import 'main_scaffold.dart';

/// ABNK 手机银行 App 入口组件。
///
/// [state] 由调用方注入（main 用 mock 实现；测试用快速 mock 或替换实现）。
class AbnkApp extends StatelessWidget {
  const AbnkApp({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      notifier: state,
      child: ListenableBuilder(
        listenable: state,
        builder: (context, _) => MaterialApp(
          title: 'ABNK 手机银行',
          debugShowCheckedModeBanner: false,
          theme: AbnkTheme.light(),
          home: state.isLoggedIn ? const MainScaffold() : const LoginPage(),
        ),
      ),
    );
  }
}
