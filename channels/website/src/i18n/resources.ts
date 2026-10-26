// 语言资源注册表（参照 asdm-ai-2026 的 src/i18n/resources.ts）。
//
// 与 asdm 的差异：本站是单页锚点站，语言包直接静态 import 打进主包
//（两语言合计 gzip 后约 6KB），省去按命名空间懒加载、localStorage 缓存、
// 启动屏与进度条——asdm 缓存版本号引发的两次白屏事故（见其 cache.ts
// 注释）在这里从机制上不存在。
import zhCommon from './locales/zh-cn/common.json';
import zhHome from './locales/zh-cn/home.json';
import enCommon from './locales/en-us/common.json';
import enHome from './locales/en-us/home.json';

export type Locale = 'en-us' | 'zh-cn';

/** 无前缀 URL 重定向时的兜底语言（浏览器检测结果优先）。 */
export const DEFAULT_LOCALE: Locale = 'en-us';

export const LOCALES: { code: Locale; label: string }[] = [
  { code: 'en-us', label: 'English' },
  { code: 'zh-cn', label: '中文' },
];

/** Widens literal types from JSON imports so translated resources stay assignable. */
type Widen<T> = T extends string
  ? string
  : T extends number | boolean | null
    ? T
    : T extends readonly (infer U)[]
      ? Widen<U>[]
      : T extends object
        ? { [K in keyof T]: Widen<T[K]> }
        : T;

/** 语言包结构，以中文包（文案原始来源）推导；英文包受同一结构约束。 */
export type Common = Widen<typeof zhCommon>;
export type Home = Widen<typeof zhHome>;

export type Translations = { common: Common; home: Home };

// 编译期结构校验：英文包键结构必须与中文包完全一致。
const english = { common: enCommon, home: enHome } satisfies Translations;

export const RESOURCES: Record<Locale, Translations> = {
  'zh-cn': { common: zhCommon, home: zhHome },
  'en-us': english,
};
