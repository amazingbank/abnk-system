// Locale hooks（与 abnk-website/src/i18n/use-locale.ts 同构，命名空间按 backoffice 业务域扩展）。
// Locale hooks, isomorphic with abnk-website/src/i18n/use-locale.ts, extended
// with the backoffice business namespaces.
import { useContext } from 'react';

import { LocaleContext } from './locale-context';
import type { Clients, Common, Errors, LoanOps, Login } from './resources';

export function useLocale() {
  const context = useContext(LocaleContext);
  if (!context) throw new Error('useLocale must be used within LocaleProvider');
  return context;
}

// 布局级文案（菜单/头部/通用）。
// Layout-level copy (menu/header/generic).
export function useCommon(): Common {
  return useLocale().common;
}

// 登录页文案。
// Login page copy.
export function useLogin(): Login {
  return useLocale().login;
}

// 客户域文案（列表/详情/识别信息）。
// Client-domain copy (list/detail/identifiers).
export function useClients(): Clients {
  return useLocale().clients;
}

// 贷款运营域文案。
// Loan-operations copy.
export function useLoanOps(): LoanOps {
  return useLocale().loanOps;
}

// 错误文案。
// Error copy.
export function useErrors(): Errors {
  return useLocale().errors;
}
