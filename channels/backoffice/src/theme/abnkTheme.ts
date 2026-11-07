/**
 * ABNK Backoffice 设计系统主题（Sprint v0.0.1 Part02 任务 P1.2）。
 *
 * 数值单一事实源：`channels/shared/design-tokens.json`
 * （提取自官网 `channels/website/tailwind.config.js`，经
 * `channels/shared/scripts/tokens_sync.py` 比对零差异——VP1.2.1）。
 *
 * 三层结构：
 *   1. `abnkPalette` / `abnkFonts` / `abnkMetrics` —— 与 tokens 逐值一致的常量层
 *   2. `abnkTheme` —— AntD v5 `ThemeConfig`（colorPrimary = copper #B08A4F）
 *   3. `abnkCssVariables` —— CSS 变量层（全局注入，数值沿用 design-tokens.json）
 *
 * 字体栈对齐官网自托管 @fontsource-variable 口径（no-CDN）：
 * Latin = Oxanium、CJK 回退 Noto Sans SC、衬线 = Noto Serif SC、等宽 = JetBrains Mono。
 */

import type { ThemeConfig } from 'antd';

/** ABNK 色板——十族品牌色，与 `design-tokens.json` 的 `colors` 逐值一致。 */
export const abnkPalette = {
  ivory: {
    DEFAULT: '#FAF7F2',
    50: '#FDFBF8',
    100: '#FAF7F2',
    200: '#F2ECE2',
    300: '#E8DFD1',
  },
  char: {
    DEFAULT: '#26201A',
    700: '#2F2820',
    800: '#26201A',
    900: '#1C1813',
    950: '#15110D',
  },
  espresso: {
    DEFAULT: '#3D322A',
    400: '#6B5D51',
    500: '#5A4C41',
    600: '#4A3E35',
    700: '#3D322A',
  },
  warmwhite: '#F5EFE6',
  copper: {
    DEFAULT: '#B08A4F',
    300: '#CDB085',
    400: '#C09D68',
    500: '#B08A4F',
    600: '#8F6E3D',
    700: '#6E542F',
  },
  amber: {
    DEFAULT: '#D9A55C',
    300: '#EAC791',
    400: '#E1B673',
    500: '#D9A55C',
    600: '#BE8A42',
  },
  taupe: {
    100: '#EDE6DC',
    200: '#DCD2C4',
    300: '#C4B7A6',
    400: '#A89A88',
    500: '#8C7E6D',
    600: '#706355',
    700: '#55493E',
  },
  sage: {
    300: '#A9B79A',
    500: '#7A8C68',
    700: '#55654A',
  },
  ochre: {
    300: '#E6C27A',
    500: '#C99A3B',
    700: '#8F6B22',
  },
  brick: {
    300: '#D49A88',
    500: '#B5604A',
    700: '#844332',
  },
} as const;

/** 字体栈——对齐官网 tailwind `fontFamily` 三栈（自托管 variable 字面量名）。 */
export const abnkFonts = {
  sans: "'Oxanium Variable', 'Noto Sans SC Variable', ui-sans-serif, system-ui, sans-serif",
  serif: "'Noto Serif SC Variable', Georgia, serif",
  mono: "'JetBrains Mono Variable', 'Noto Sans SC Variable', ui-monospace, monospace",
} as const;

/** 版式度量——eyebrow 字距与页宽，与 tokens 逐值一致。 */
export const abnkMetrics = {
  eyebrow: '0.22em',
  pageMaxWidth: '1360px',
} as const;

/** AntD v5 主题配置——colorPrimary = copper `#B08A4F`，暖色系语义映射。 */
export const abnkTheme: ThemeConfig = {
  token: {
    // 主色与链接
    colorPrimary: abnkPalette.copper.DEFAULT, // #B08A4F
    colorInfo: abnkPalette.copper.DEFAULT, // #B08A4F
    colorLink: abnkPalette.copper['600'], // #8F6E3D
    colorLinkHover: abnkPalette.copper['400'], // #C09D68
    colorLinkActive: abnkPalette.copper['700'], // #6E542F
    // 语义色（成功 sage / 警示 amber / 危险 brick——暖色系映射）
    colorSuccess: abnkPalette.sage['500'], // #7A8C68
    colorWarning: abnkPalette.amber.DEFAULT, // #D9A55C
    colorError: abnkPalette.brick['500'], // #B5604A
    // 文字与背景（char 文字基底 / ivory 页面基底 / warmwhite 容器）
    colorTextBase: abnkPalette.char.DEFAULT, // #26201A
    colorBgBase: abnkPalette.ivory.DEFAULT, // #FAF7F2
    colorBgContainer: abnkPalette.ivory['50'], // #FDFBF8
    colorBgLayout: abnkPalette.warmwhite, // #F5EFE6
    colorBgElevated: abnkPalette.warmwhite, // #F5EFE6
    // 边框（taupe 中性族）
    colorBorder: abnkPalette.taupe['200'], // #DCD2C4
    colorBorderSecondary: abnkPalette.taupe['100'], // #EDE6DC
    // 形态
    borderRadius: 6,
    fontFamily: abnkFonts.sans,
  },
  components: {
    Layout: {
      headerBg: abnkPalette.warmwhite, // #F5EFE6
      bodyBg: abnkPalette.ivory.DEFAULT, // #FAF7F2
      siderBg: abnkPalette.warmwhite, // #F5EFE6
    },
    Menu: {
      itemBg: 'transparent',
      itemSelectedBg: abnkPalette.taupe['100'], // #EDE6DC
      itemSelectedColor: abnkPalette.copper['700'], // #6E542F
    },
    Button: {
      primaryShadow: 'none',
      defaultBg: abnkPalette.warmwhite, // #F5EFE6
      defaultBorderColor: abnkPalette.taupe['200'], // #DCD2C4
    },
    Table: {
      headerBg: abnkPalette.taupe['100'], // #EDE6DC
      headerColor: abnkPalette.espresso['600'], // #4A3E35
      rowHoverBg: abnkPalette.ivory['50'], // #FDFBF8
      borderColor: abnkPalette.taupe['200'], // #DCD2C4
    },
    Card: {
      colorBgContainer: abnkPalette.warmwhite, // #F5EFE6
      colorBorderSecondary: abnkPalette.taupe['200'], // #DCD2C4
    },
    Tabs: {
      itemSelectedColor: abnkPalette.copper['700'], // #6E542F
      inkBarColor: abnkPalette.copper.DEFAULT, // #B08A4F
    },
    Modal: {
      contentBg: abnkPalette.warmwhite, // #F5EFE6
    },
  },
};

/** CSS 变量层——全局注入（如 index.html style 或 CSSStyleSheet），数值沿用 design-tokens.json。 */
export const abnkCssVariables: Record<string, string> = {
  // 主语义
  '--abnk-color-primary': abnkPalette.copper.DEFAULT, // #B08A4F
  '--abnk-color-primary-hover': abnkPalette.copper['400'],
  '--abnk-color-primary-active': abnkPalette.copper['700'],
  '--abnk-color-secondary': abnkPalette.amber.DEFAULT, // #D9A55C
  '--abnk-color-success': abnkPalette.sage['500'],
  '--abnk-color-warning': abnkPalette.amber.DEFAULT,
  '--abnk-color-error': abnkPalette.brick['500'],
  // 文字与背景
  '--abnk-color-text': abnkPalette.char.DEFAULT, // #26201A
  '--abnk-color-text-secondary': abnkPalette.espresso['500'],
  '--abnk-color-bg': abnkPalette.ivory.DEFAULT, // #FAF7F2
  '--abnk-color-bg-container': abnkPalette.warmwhite, // #F5EFE6
  // 边框
  '--abnk-color-border': abnkPalette.taupe['200'],
  '--abnk-color-border-secondary': abnkPalette.taupe['100'],
  // 字体栈
  '--abnk-font-sans': abnkFonts.sans,
  '--abnk-font-serif': abnkFonts.serif,
  '--abnk-font-mono': abnkFonts.mono,
  // 版式
  '--abnk-eyebrow-spacing': abnkMetrics.eyebrow, // 0.22em
  '--abnk-page-max-width': abnkMetrics.pageMaxWidth, // 1360px
};

/** 将 CSS 变量层注入目标元素的便捷函数（App 挂载时调用）。 */
export function applyAbnkCssVariables(target: HTMLElement | null = document.documentElement): void {
  for (const [name, value] of Object.entries(abnkCssVariables)) {
    target?.style.setProperty(name, value);
  }
}
