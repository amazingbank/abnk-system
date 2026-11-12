// Locale 上下文（与 abnk-website/src/i18n/locale-context.ts 同构，命名空间按 backoffice 业务域扩展）。
// Locale context, isomorphic with abnk-website/src/i18n/locale-context.ts,
// extended with the backoffice business namespaces.
import { createContext } from 'react';
import type { Clients, Common, Errors, LoanOps, Locale, Login } from './resources';

type LocaleContextValue = {
  locale: Locale;
  // 布局级文案（菜单/头部/通用），随语言同步就绪。
  // Layout-level copy (menu/header/generic), ready along with the locale.
  common: Common;
  // 登录页文案。
  // Login page copy.
  login: Login;
  // 客户域文案（列表/详情/识别信息）。
  // Client-domain copy (list/detail/identifiers).
  clients: Clients;
  // 贷款运营域文案。
  // Loan-operations copy.
  loanOps: LoanOps;
  // 错误文案（骨架先建，词条随任务 1.6/Phase 2 任务 2.1 落地）。
  // Error copy (skeleton first; entries land with task 1.6 and Phase 2 task 2.1).
  errors: Errors;
  // 切换语言：持久化偏好并就地重渲染（实现见 locale-provider）。
  // Switches the locale: persists the preference and re-renders in place
  // (implemented in locale-provider).
  setLocale: (next: Locale) => void;
};

export const LocaleContext = createContext<LocaleContextValue | null>(null);
