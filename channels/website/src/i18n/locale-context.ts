import { createContext } from 'react';
import type { Common, Home, Locale } from './resources';

type LocaleContextValue = {
  locale: Locale;
  /** 布局级文案（导航/页脚/SEO meta），随语言同步就绪。 */
  common: Common;
  /** 页面级文案（全部 section），随语言同步就绪。 */
  home: Home;
  toggleLocale: () => void;
};

export const LocaleContext = createContext<LocaleContextValue | null>(null);
