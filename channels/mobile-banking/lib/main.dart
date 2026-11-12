import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show SemanticsBinding;
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'app_scope.dart';
import 'data/repository_factory.dart';

/// locale 持久化合法值集合（D8 小写简码，zh/en）。
/// The set of valid persisted locale values (D8 lowercase codes, zh/en).
const Set<String> kSupportedLocaleCodes = {'zh', 'en'};

/// 解析初始 locale（D1 口径）：存储合法值（[kSupportedLocaleCodes]）优先，
/// 否则跟随系统语言——任一系统语言以 zh 开头 → zh，否则 en。
///
/// 独立成顶层函数供 main 与单测共用（测试经参数注入系统语言列表）。
/// Resolves the initial locale (D1): a valid persisted value wins
/// ([kSupportedLocaleCodes]); otherwise the system languages decide — any
/// locale starting with zh yields zh, else en.
///
/// Kept as a top-level function shared by main and unit tests (tests inject
/// the system locale list through the parameters).
Locale resolveInitialLocale(
  SharedPreferences prefs,
  List<Locale> platformLocales,
) {
  final stored = prefs.getString(abnkLocaleKey);
  if (stored != null && kSupportedLocaleCodes.contains(stored)) {
    return Locale(stored);
  }
  final followsZh = platformLocales
      .any((locale) => locale.languageCode.toLowerCase().startsWith('zh'));
  return followsZh ? const Locale('zh') : const Locale('en');
}

Future<void> main() async {
  // 自托管字体口径（P1.2 锁定）：禁运行时拉取，字体经 assets/fonts/
  // 内置打包进产物（对齐官网 no-CDN 约束）。
  GoogleFonts.config.allowRuntimeFetching = false;
  // 异步启动前置（Part03 P3.2）：读取语言偏好（shared_preferences）前必须
  // 完成绑定初始化。
  // Async bootstrap precondition (Part03 P3.2): the binding must be
  // initialized before reading the persisted locale (shared_preferences).
  WidgetsFlutterBinding.ensureInitialized();
  // 走查口径（P3.1）：自动化浏览器走查经 `--dart-define=ABNK_ENABLE_SEMANTICS=true`
  // 显式启用语义树（新 Flutter web 无可见 Enable accessibility 按钮，AT 探测
  // 无法自动触发）；默认关闭，不影响生产产物。
  if (kIsWeb && const bool.fromEnvironment('ABNK_ENABLE_SEMANTICS')) {
    SemanticsBinding.instance.ensureSemantics();
  }
  // 初始语言（D1）：持久化合法值优先，否则跟随系统语言。
  // Initial locale (D1): a valid persisted value wins, else follow the
  // system languages.
  final prefs = await SharedPreferences.getInstance();
  final locale = resolveInitialLocale(prefs, PlatformDispatcher.instance.locales);
  runApp(AbnkApp(state: buildAppState(locale: locale, prefs: prefs)));
}
