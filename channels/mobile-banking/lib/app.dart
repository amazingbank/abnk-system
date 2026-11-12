import 'package:flutter/material.dart';

import 'app_scope.dart';
import 'core/theme/app_theme.dart';
import 'features/login/login_page.dart';
import 'l10n/app_localizations.dart';
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
          // l10n 接线（Part03 P3.2）：delegates 驱动 Material 内建文案与
          // AppLocalizations 词条随 locale 切换；locale 取自 AppState（单一
          // 事实源，setLocale → notifyListeners 整树重建）；title 经
          // onGenerateTitle 取词条（应用名随语言切换）。
          // l10n wiring (Part03 P3.2): the delegates make Material built-in
          // texts and AppLocalizations lookups follow the locale; the locale
          // comes from AppState (single source of truth — setLocale →
          // notifyListeners rebuilds the whole tree); the title resolves via
          // onGenerateTitle so the app name follows the language too.
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: state.locale,
          debugShowCheckedModeBanner: false,
          theme: AbnkTheme.light(),
          home: state.isLoggedIn ? const MainScaffold() : const LoginPage(),
        ),
      ),
    );
  }
}
