import { useCallback, useEffect, useMemo, useState, type ReactNode } from 'react';

import { LOCALE_HTML_LANG, resolveBrowserLocale } from './locale';
import { LocaleContext } from './locale-context';
import { parseLocaleFromPathname, swapLocalePrefix } from './locale-url';
import { RESOURCES, type Locale } from './resources';

/** 用户显式切换语言时写入的记录键（只写不读，URL 前缀才是唯一事实来源——与 asdm-ai-2026 一致）。 */
const LOCALE_STORAGE_KEY = 'abnk-locale';

function initialLocale(): Locale {
  return parseLocaleFromPathname(window.location.pathname) ?? resolveBrowserLocale();
}

export function LocaleProvider({ children }: { children: ReactNode }) {
  const [locale, setLocaleState] = useState<Locale>(initialLocale);

  // <html lang>、<title>、meta description 随语言同步更新。
  useEffect(() => {
    const { common } = RESOURCES[locale];
    document.documentElement.lang = LOCALE_HTML_LANG[locale];
    document.title = common.meta.title;
    document.querySelector('meta[name="description"]')?.setAttribute('content', common.meta.description);
  }, [locale]);

  // 前进/后退导航时重新从 URL 同步语言，保证渲染语言与地址栏永不背离。
  useEffect(() => {
    const onPopState = () => {
      const next = parseLocaleFromPathname(window.location.pathname);
      if (next && next !== locale) setLocaleState(next);
    };
    window.addEventListener('popstate', onPopState);
    return () => window.removeEventListener('popstate', onPopState);
  }, [locale]);

  // 切换保持在客户端完成：pushState 交换 URL 前缀（保留 query 与锚点，
  // 不触发页面刷新、不丢失滚动位置），组件随新语言包就地重渲染。
  const toggleLocale = useCallback(() => {
    const target: Locale = locale === 'en-us' ? 'zh-cn' : 'en-us';
    const nextPathname = swapLocalePrefix(window.location.pathname, target);
    window.history.pushState(null, '', `${nextPathname}${window.location.search}${window.location.hash}`);
    try {
      window.localStorage.setItem(LOCALE_STORAGE_KEY, target);
    } catch {
      // 存储不可用：本次会话内生效即可。
    }
    setLocaleState(target);
  }, [locale]);

  const value = useMemo(() => ({ locale, ...RESOURCES[locale], toggleLocale }), [locale, toggleLocale]);

  return <LocaleContext.Provider value={value}>{children}</LocaleContext.Provider>;
}
