import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show SemanticsBinding;
import 'package:google_fonts/google_fonts.dart';

import 'app.dart';
import 'data/repository_factory.dart';

void main() {
  // 自托管字体口径（P1.2 锁定）：禁运行时拉取，字体经 assets/fonts/
  // 内置打包进产物（对齐官网 no-CDN 约束）。
  GoogleFonts.config.allowRuntimeFetching = false;
  // 走查口径（P3.1）：自动化浏览器走查经 `--dart-define=ABNK_ENABLE_SEMANTICS=true`
  // 显式启用语义树（新 Flutter web 无可见 Enable accessibility 按钮，AT 探测
  // 无法自动触发）；默认关闭，不影响生产产物。
  if (kIsWeb && const bool.fromEnvironment('ABNK_ENABLE_SEMANTICS')) {
    WidgetsFlutterBinding.ensureInitialized();
    SemanticsBinding.instance.ensureSemantics();
  }
  runApp(AbnkApp(state: buildAppState()));
}
