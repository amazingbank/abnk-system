// i18n 统一出口（LocaleProvider 为组件，从 '@/i18n/locale-provider' 单独导入，
// 以满足 react-refresh/only-export-components 约束）。
export { interpolate } from './interpolate';
export { resolveBrowserLocale } from './locale';
export { parseLocaleFromPathname, swapLocalePrefix } from './locale-url';
export { useCommon, useHome, useLocale } from './use-locale';
export { DEFAULT_LOCALE, LOCALES, type Common, type Home, type Locale, type Translations } from './resources';
