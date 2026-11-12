// 语言探测辅助（与 abnk-website/src/i18n/locale.ts 同构迁移）。
// Locale detection helpers, migrated isomorphically from
// abnk-website/src/i18n/locale.ts.
import { DEFAULT_LOCALE, type Locale } from './resources';

// 浏览器语言列表中任一 zh 开头的 tag 映射到 zh-cn，其余映射到 en-us（决策 D1）。
// Any browser language tag starting with "zh" maps to zh-cn; everything else
// maps to en-us (decision D1).
const CHINESE_LANGUAGE = /^zh\b/i;

// 依据浏览器语言偏好探测语言；仅用于无持久化偏好时决定初始语言。
// Detects the locale from browser language preferences; used only to decide
// the initial locale when no persisted preference exists.
export function resolveBrowserLocale(): Locale {
  if (typeof window === 'undefined') return DEFAULT_LOCALE;

  const candidates = navigator.languages?.length ? navigator.languages : [navigator.language];
  const isChinese = candidates.some((tag) => typeof tag === 'string' && CHINESE_LANGUAGE.test(tag.trim()));

  return isChinese ? 'zh-cn' : DEFAULT_LOCALE;
}

// 各语言对应的 <html lang> 值（BCP 47 惯用大小写，决策 D8）。
// The <html lang> value per locale (conventional BCP 47 casing, decision D8).
export const LOCALE_HTML_LANG: Record<Locale, string> = {
  'en-us': 'en-US',
  'zh-cn': 'zh-CN',
};

// 当前语言快照（模块级可变状态）：LocaleProvider 每次渲染时同步写入，
// 供纯函数模块（如 utils/format 的 formatMoney）在无 hook 的前提下读取当前语言。
// Snapshot of the current locale (module-level mutable state): kept in sync
// by LocaleProvider on every render so pure-function modules (e.g.
// formatMoney in utils/format) can read the current locale without hooks.
let currentLocale: Locale = DEFAULT_LOCALE;

// 写入当前语言快照（仅 LocaleProvider 渲染期调用）。
// Writes the locale snapshot (called only during LocaleProvider renders).
export function setCurrentLocale(locale: Locale): void {
  currentLocale = locale;
}

// 读取当前语言快照（供纯函数模块使用；React 组件请改用 useLocale）。
// Reads the locale snapshot (for pure-function modules; React components
// should use useLocale instead).
export function getCurrentLocale(): Locale {
  return currentLocale;
}
