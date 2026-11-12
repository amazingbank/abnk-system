// i18n 统一出口（LocaleProvider 为组件，须从 '@/i18n/locale-provider' 单独导入，
// 以满足 react-refresh/only-export-components 约束）。
// Unified i18n entry point. LocaleProvider is a component and must be imported
// from '@/i18n/locale-provider' directly to satisfy the
// react-refresh/only-export-components rule.
export { apiErrorMessage } from './api-error';
export { interpolate } from './interpolate';
export { getCurrentLocale, resolveBrowserLocale } from './locale';
export { useClients, useCommon, useErrors, useLocale, useLoanOps, useLogin } from './use-locale';
export {
  DEFAULT_LOCALE,
  LOCALES,
  type Clients,
  type Common,
  type Errors,
  type Locale,
  type LoanOps,
  type Login,
  type Translations,
} from './resources';
