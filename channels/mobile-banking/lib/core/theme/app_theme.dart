/// ABNK 手机银行设计系统主题（Sprint v0.0.1 Part02 任务 P1.2）。
///
/// 数值单一事实源：`channels/shared/design-tokens.json`
/// （提取自官网 `channels/website/tailwind.config.js` 的 theme.extend，
/// 经 `channels/shared/scripts/tokens_sync.py` 比对零差异——VP1.2.1）。
///
/// 字体栈对齐官网自托管 no-CDN 口径：Latin = Oxanium、CJK 回退 Noto Sans SC、
/// 品牌衬线大标题 = Noto Serif SC、等宽 = JetBrains Mono——经 `google_fonts`
/// 引用；web 载体的字体自托管打包（GoogleFonts.config 禁运行时拉取 + 资产内置）
/// 在任务 P1.3 工程创建时落地，本文件只锁定 token 数值与结构。
///
/// 本文件先于 `flutter create` 产出（P1.2），编译验证由任务 P1.3 的
/// VP1.3.1 `flutter analyze` 承接（`flutter create` 对非空目录合法，合并生成）。
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ABNK 色板——十族品牌色，数值与 `design-tokens.json` 的 `colors` 逐值一致。
///
/// 命名约定：`<族名>` = DEFAULT 档；`<族名><档位>` = 数字档（如 `ivory50`）。
abstract final class AbnkColors {
  // ── ivory 象牙底色族 ──
  static const Color ivory = Color(0xFFFAF7F2); // #FAF7F2
  static const Color ivory50 = Color(0xFFFDFBF8); // #FDFBF8
  static const Color ivory100 = Color(0xFFFAF7F2); // #FAF7F2
  static const Color ivory200 = Color(0xFFF2ECE2); // #F2ECE2
  static const Color ivory300 = Color(0xFFE8DFD1); // #E8DFD1

  // ── char 深炭文字族 ──
  static const Color char = Color(0xFF26201A); // #26201A
  static const Color char700 = Color(0xFF2F2820); // #2F2820
  static const Color char800 = Color(0xFF26201A); // #26201A
  static const Color char900 = Color(0xFF1C1813); // #1C1813
  static const Color char950 = Color(0xFF15110D); // #15110D

  // ── espresso 浓咖次级文字族 ──
  static const Color espresso = Color(0xFF3D322A); // #3D322A
  static const Color espresso400 = Color(0xFF6B5D51); // #6B5D51
  static const Color espresso500 = Color(0xFF5A4C41); // #5A4C41
  static const Color espresso600 = Color(0xFF4A3E35); // #4A3E35
  static const Color espresso700 = Color(0xFF3D322A); // #3D322A

  // ── warmwhite 暖白（单值族）──
  static const Color warmwhite = Color(0xFFF5EFE6); // #F5EFE6

  // ── copper 铜金主色族 ──
  static const Color copper = Color(0xFFB08A4F); // #B08A4F
  static const Color copper300 = Color(0xFFCDB085); // #CDB085
  static const Color copper400 = Color(0xFFC09D68); // #C09D68
  static const Color copper500 = Color(0xFFB08A4F); // #B08A4F
  static const Color copper600 = Color(0xFF8F6E3D); // #8F6E3D
  static const Color copper700 = Color(0xFF6E542F); // #6E542F

  // ── amber 琥珀强调族 ──
  static const Color amber = Color(0xFFD9A55C); // #D9A55C
  static const Color amber300 = Color(0xFFEAC791); // #EAC791
  static const Color amber400 = Color(0xFFE1B673); // #E1B673
  static const Color amber500 = Color(0xFFD9A55C); // #D9A55C
  static const Color amber600 = Color(0xFFBE8A42); // #BE8A42

  // ── taupe 灰褐中性族 ──
  static const Color taupe100 = Color(0xFFEDE6DC); // #EDE6DC
  static const Color taupe200 = Color(0xFFDCD2C4); // #DCD2C4
  static const Color taupe300 = Color(0xFFC4B7A6); // #C4B7A6
  static const Color taupe400 = Color(0xFFA89A88); // #A89A88
  static const Color taupe500 = Color(0xFF8C7E6D); // #8C7E6D
  static const Color taupe600 = Color(0xFF706355); // #706355
  static const Color taupe700 = Color(0xFF55493E); // #55493E

  // ── sage 鼠尾草成功族 ──
  static const Color sage300 = Color(0xFFA9B79A); // #A9B79A
  static const Color sage500 = Color(0xFF7A8C68); // #7A8C68
  static const Color sage700 = Color(0xFF55654A); // #55654A

  // ── ochre 赭黄警示族 ──
  static const Color ochre300 = Color(0xFFE6C27A); // #E6C27A
  static const Color ochre500 = Color(0xFFC99A3B); // #C99A3B
  static const Color ochre700 = Color(0xFF8F6B22); // #8F6B22

  // ── brick 砖红危险族 ──
  static const Color brick300 = Color(0xFFD49A88); // #D49A88
  static const Color brick500 = Color(0xFFB5604A); // #B5604A
  static const Color brick700 = Color(0xFF844332); // #844332
}

/// ABNK 版式度量——eyebrow 字距与页宽，数值与 `design-tokens.json` 一致。
abstract final class AbnkMetrics {
  /// eyebrow 字距 `0.22em`——Flutter 的 [TextStyle.letterSpacing] 单位为逻辑像素，
  /// 按 em 值以字号换算（如 12px 字号 → 12 × 0.22 = 2.64 逻辑像素）。
  static const double eyebrowEm = 0.22;

  /// 页面最大宽度 `1360px`（对齐官网 `maxWidth.page`）。
  static const double pageMaxWidth = 1360;

  /// 按字号换算 eyebrow 字距（逻辑像素）。
  static double eyebrow(double fontSize) => fontSize * eyebrowEm;
}

/// ABNK 字体栈——与官网 tailwind `fontFamily` 三栈同源。
abstract final class AbnkFonts {
  /// sans 栈：Oxanium Variable → Noto Sans SC Variable → 系统回退。
  static const List<String> sansFallback = [
    'Noto Sans SC Variable',
    'Noto Sans SC',
    'ui-sans-serif',
    'system-ui',
    'sans-serif',
  ];

  /// serif 栈：Noto Serif SC Variable → Georgia → serif（品牌衬线大标题）。
  static const List<String> serifFallback = [
    'Georgia',
    'serif',
  ];

  /// mono 栈：JetBrains Mono Variable → Noto Sans SC Variable → 等宽回退。
  static const List<String> monoFallback = [
    'Noto Sans SC Variable',
    'Noto Sans SC',
    'ui-monospace',
    'monospace',
  ];

  /// sans 样式（Latin 主字体 Oxanium，CJK 逐字符回退 Noto Sans SC）。
  static TextStyle sans({TextStyle? base}) => GoogleFonts.oxanium(
        textStyle: base,
        fontFamilyFallback: sansFallback,
      );

  /// serif 样式（品牌衬线大标题 Noto Serif SC）。
  static TextStyle serif({TextStyle? base}) => GoogleFonts.notoSerifSc(
        textStyle: base,
        fontFamilyFallback: serifFallback,
      );

  /// mono 样式（JetBrains Mono，CJK 回退 Noto Sans SC）。
  static TextStyle mono({TextStyle? base}) => GoogleFonts.jetBrainsMono(
        textStyle: base,
        fontFamilyFallback: monoFallback,
      );

  /// eyebrow 样式——小号大写字距标签（官网 eyebrow 范式）。
  static TextStyle eyebrow({TextStyle? base, double fontSize = 12}) =>
      (sans(base: base) ?? const TextStyle()).copyWith(
        letterSpacing: AbnkMetrics.eyebrow(fontSize),
      );
}

/// ABNK 亮色主题——`ColorScheme` + `TextTheme` 的 token 映射入口。
abstract final class AbnkTheme {
  /// 品牌色板语义映射（copper 主色 / amber 强调 / brick 危险 / sage 成功）。
  static ColorScheme get colorScheme => const ColorScheme(
        brightness: Brightness.light,
        primary: AbnkColors.copper, // #B08A4F
        onPrimary: AbnkColors.warmwhite, // #F5EFE6
        secondary: AbnkColors.amber, // #D9A55C
        onSecondary: AbnkColors.char, // #26201A
        error: AbnkColors.brick500, // #B5604A
        onError: AbnkColors.warmwhite, // #F5EFE6
        surface: AbnkColors.warmwhite, // #F5EFE6
        onSurface: AbnkColors.char, // #26201A
        surfaceContainerHighest: AbnkColors.taupe100, // #EDE6DC
        onSurfaceVariant: AbnkColors.espresso500, // #5A4C41
        outline: AbnkColors.taupe300, // #C4B7A6
        outlineVariant: AbnkColors.taupe200, // #DCD2C4
      );

  /// 品牌文本主题——body/title 用 sans 栈，display/headline 用 serif 栈。
  static TextTheme textTheme(TextTheme base) {
    final sansApplied = _mapAll(
      base,
      (style) => AbnkFonts.sans(base: style),
    );
    return sansApplied.copyWith(
      displayLarge: AbnkFonts.serif(base: sansApplied.displayLarge),
      displayMedium: AbnkFonts.serif(base: sansApplied.displayMedium),
      displaySmall: AbnkFonts.serif(base: sansApplied.displaySmall),
      headlineLarge: AbnkFonts.serif(base: sansApplied.headlineLarge),
      headlineMedium: AbnkFonts.serif(base: sansApplied.headlineMedium),
      headlineSmall: AbnkFonts.serif(base: sansApplied.headlineSmall),
    );
  }

  /// 亮色 [ThemeData]——App 入口 `MaterialApp(theme: AbnkTheme.light())`。
  static ThemeData light() {
    final scheme = colorScheme;
    final base = ThemeData(brightness: Brightness.light);
    final typography = base.textTheme.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );
    return base.copyWith(
      colorScheme: scheme,
      textTheme: textTheme(typography),
      scaffoldBackgroundColor: AbnkColors.ivory, // #FAF7F2
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: const AppBarTheme(
        backgroundColor: AbnkColors.warmwhite, // #F5EFE6
        foregroundColor: AbnkColors.char, // #26201A
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AbnkColors.char,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AbnkColors.taupe200, // #DCD2C4
        thickness: 1,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: AbnkColors.warmwhite, // #F5EFE6
        indicatorColor: AbnkColors.taupe100, // #EDE6DC
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AbnkColors.ivory50, // #FDFBF8
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AbnkColors.taupe200), // #DCD2C4
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AbnkColors.taupe200), // #DCD2C4
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AbnkColors.copper500, // #B08A4F
            width: 1.5,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AbnkColors.copper, // #B08A4F
          foregroundColor: AbnkColors.warmwhite, // #F5EFE6
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  /// 对 [TextTheme] 全部 15 档逐一应用样式变换。
  static TextTheme _mapAll(
    TextTheme theme,
    TextStyle? Function(TextStyle?) transform,
  ) =>
      theme.copyWith(
        displayLarge: transform(theme.displayLarge),
        displayMedium: transform(theme.displayMedium),
        displaySmall: transform(theme.displaySmall),
        headlineLarge: transform(theme.headlineLarge),
        headlineMedium: transform(theme.headlineMedium),
        headlineSmall: transform(theme.headlineSmall),
        titleLarge: transform(theme.titleLarge),
        titleMedium: transform(theme.titleMedium),
        titleSmall: transform(theme.titleSmall),
        bodyLarge: transform(theme.bodyLarge),
        bodyMedium: transform(theme.bodyMedium),
        bodySmall: transform(theme.bodySmall),
        labelLarge: transform(theme.labelLarge),
        labelMedium: transform(theme.labelMedium),
        labelSmall: transform(theme.labelSmall),
      );
}
