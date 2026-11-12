import { useCallback, useEffect, useMemo, useState, type ReactNode } from 'react';

import { LOCALE_HTML_LANG, resolveBrowserLocale, setCurrentLocale } from './locale';
import { LocaleContext } from './locale-context';
import { DEFAULT_LOCALE, LOCALES, RESOURCES, type Locale } from './resources';

// 与 abnk-website locale-provider 的有意差异（决策 D6）：
// website 是单页锚点站，URL 前缀是语言唯一事实来源（SEO/分享诉求驱动）；
// backoffice 是工具型运营后台，无 SEO/分享诉求，故语言事实来源为
// localStorage——URL 无语言前缀、路由层零侵入，切换经 setState 就地重渲染。
//
// Deliberate divergence from the abnk-website provider (decision D6): the
// website treats the URL prefix as the single source of truth for locale
// (driven by SEO/sharing needs), whereas this operations console has no such
// needs and therefore keeps the locale in localStorage — no URL prefix, zero
// coupling with the routing layer, and switching re-renders in place via
// setState.

// 用户语言偏好的持久化键（语言事实来源，见上方 D6 差异声明）。
// localStorage key persisting the user's locale preference (the source of
// truth for locale; see the D6 divergence note above).
const LOCALE_STORAGE_KEY = 'abnk-locale';

// 合法语言码集合（由 LOCALES 派生，与切换器候选保持单一事实来源）。
// The set of valid locale codes (derived from LOCALES so the switcher
// candidates stay the single source of truth).
const VALID_LOCALES = new Set<string>(LOCALES.map((item) => item.code));

// 初始语言决策（2026-11-12 用户拍板口径）：
// 1. 存储值合法（zh-cn/en-us）→ 用之；
// 2. 存储值存在但非法（如 'fr'，非中文非英文）→ 一律回退英文兜底
//    （非法值不进入系统探测——不因系统语言而摇摆）；
// 3. 无存储值（含存储不可用）→ 跟随系统语言（决策 D1：任一系统语言
//    tag 以 zh 开头 → zh-cn，否则 en-us）。
//
// Initial-locale decision (per the user's call on 2026-11-12):
// 1. a valid stored value (zh-cn/en-us) wins;
// 2. a stored value that is neither Chinese nor English (e.g. 'fr') falls
//    back to English unconditionally (invalid values never reach system
//    detection, so the outcome never swings with the system language);
// 3. no stored value at all (including unavailable storage) follows the
//    system language (decision D1: any system language tag starting with
//    "zh" maps to zh-cn, otherwise en-us).
function initialLocale(): Locale {
  try {
    const stored = window.localStorage.getItem(LOCALE_STORAGE_KEY);
    if (stored !== null) {
      // 非中文非英文的存储值一律回退英文（DEFAULT_LOCALE）。
      // Any stored value that is neither Chinese nor English falls back
      // to English (DEFAULT_LOCALE).
      return VALID_LOCALES.has(stored) ? (stored as Locale) : DEFAULT_LOCALE;
    }
  } catch {
    // 存储不可用（隐私模式等）：视同无偏好，走系统探测，不报错不阻塞。
    // Storage unavailable (private mode, etc.): treat as no preference and
    // fall through to system detection; neither throw nor block.
  }
  return resolveBrowserLocale();
}

export function LocaleProvider({ children }: { children: ReactNode }) {
  const [locale, setLocaleState] = useState<Locale>(initialLocale);

  // 同步模块级语言快照：纯函数（如 formatMoney）在子组件渲染期即可读到最新语言。
  // Syncs the module-level locale snapshot so pure functions (e.g.
  // formatMoney) see the latest locale while children render.
  setCurrentLocale(locale);

  // <html lang>（BCP 47 大写）与页面标题随语言同步更新。
  // Keeps <html lang> (BCP 47 casing) and the document title in sync with
  // the locale.
  useEffect(() => {
    document.documentElement.lang = LOCALE_HTML_LANG[locale];
    document.title = RESOURCES[locale].common.meta.title;
  }, [locale]);

  // 切换语言：写存储（try/catch 降级为本次会话内生效）+ setState 就地重渲染，
  // 无页面刷新、无路由跳变。
  // Switches the locale: persists the choice (degrading gracefully to a
  // session-only effect when storage is unavailable) and re-renders in place
  // via setState — no page refresh, no route change.
  const setLocale = useCallback((next: Locale) => {
    try {
      window.localStorage.setItem(LOCALE_STORAGE_KEY, next);
    } catch {
      // 存储不可用：本次会话内生效即可。
      // Storage unavailable: effective within this session is enough.
    }
    setLocaleState(next);
  }, []);

  const value = useMemo(() => ({ locale, ...RESOURCES[locale], setLocale }), [locale, setLocale]);

  return <LocaleContext.Provider value={value}>{children}</LocaleContext.Provider>;
}
