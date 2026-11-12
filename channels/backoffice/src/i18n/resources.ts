// 语言资源注册表（与 abnk-website/src/i18n/resources.ts 同构复刻，见 Part03 决策 D5）。
// Language resource registry, replicated isomorphically from
// abnk-website/src/i18n/resources.ts (see Part03 decision D5).
//
// 词条为 JSON 静态 import 打进主包（词条量级数百条，无需懒加载）。
// Translation packs are statically imported and bundled into the main chunk
// (only a few hundred entries, so lazy loading is unnecessary).
//
// 命名空间按业务域拆分：common（布局/菜单/通用）/ login / clients / loanOps / errors。
// Namespaces are split by business domain: common (layout/menu/generic), login,
// clients, loanOps, errors.
import zhCommon from './locales/zh-cn/common.json';
import zhLogin from './locales/zh-cn/login.json';
import zhClients from './locales/zh-cn/clients.json';
import zhLoanOps from './locales/zh-cn/loanOps.json';
import zhErrors from './locales/zh-cn/errors.json';
import enCommon from './locales/en-us/common.json';
import enLogin from './locales/en-us/login.json';
import enClients from './locales/en-us/clients.json';
import enLoanOps from './locales/en-us/loanOps.json';
import enErrors from './locales/en-us/errors.json';

// 代码层 locale 统一小写（决策 D8）；BCP 47 大写仅用于 <html lang>。
// Locale codes are lowercase at the code level (decision D8); BCP 47 casing is
// reserved for the <html lang> attribute.
export type Locale = 'zh-cn' | 'en-us';

// 非中文系统语言与无浏览器环境（SSR/测试）时的兜底语言。
// Fallback locale for non-Chinese system languages and non-browser
// environments (SSR/tests).
export const DEFAULT_LOCALE: Locale = 'en-us';

// 语言切换器候选项及其自称 label。
// Candidate locales for the language switcher, each labeled in its own language.
export const LOCALES: { code: Locale; label: string }[] = [
  { code: 'zh-cn', label: '中文' },
  { code: 'en-us', label: 'English' },
];

// 拓宽 JSON import 的字面量类型，使译文包仍可赋值（与 abnk-website 同款实现）。
// Widens literal types from JSON imports so translated resources stay
// assignable (same implementation as abnk-website).
type Widen<T> = T extends string
  ? string
  : T extends number | boolean | null
    ? T
    : T extends readonly (infer U)[]
      ? Widen<U>[]
      : T extends object
        ? { [K in keyof T]: Widen<T[K]> }
        : T;

// 语言包结构以中文包（文案原始来源，决策 D2）推导；英文包受同一结构约束。
// Package shapes are derived from the Chinese packs (the source of all copy,
// decision D2); English packs are bound to the same structure.
export type Common = Widen<typeof zhCommon>;
export type Login = Widen<typeof zhLogin>;
export type Clients = Widen<typeof zhClients>;
export type LoanOps = Widen<typeof zhLoanOps>;
export type Errors = Widen<typeof zhErrors>;

export type Translations = {
  common: Common;
  login: Login;
  clients: Clients;
  loanOps: LoanOps;
  errors: Errors;
};

// 编译期结构校验：英文包键结构必须与中文包完全一致（缺 key/结构漂移在 typecheck 拦截）。
// Compile-time structure check: English packs must match the Chinese packs
// exactly (missing keys or structural drift fail at `npm run typecheck`).
const english = {
  common: enCommon,
  login: enLogin,
  clients: enClients,
  loanOps: enLoanOps,
  errors: enErrors,
} satisfies Translations;

export const RESOURCES: Record<Locale, Translations> = {
  'zh-cn': { common: zhCommon, login: zhLogin, clients: zhClients, loanOps: zhLoanOps, errors: zhErrors },
  'en-us': english,
};
