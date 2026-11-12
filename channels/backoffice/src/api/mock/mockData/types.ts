/**
 * mock 数据文件结构类型（任务 2.2）——以 zh-cn 数据集为结构事实源
 * （决策 D2/D3 同口径）：`ClientsFile`/`OperatorsFile` 由 zh-cn JSON 经
 * Widen 拓宽推导（实现与 abnk-website i18n resources.ts 同构，决策 D5），
 * en-us 数据集经 `satisfies` 受其结构约束——缺字段/结构漂移在
 * `npm run typecheck` 拦截，替换原 `as unknown as` 宽转换（零校验）。
 * Structural types for mock data files (task 2.2) — the zh-cn data set is
 * the source of structural truth (same convention as decisions D2/D3):
 * `ClientsFile` / `OperatorsFile` are derived from the zh-cn JSON through
 * the Widen helper (isomorphic with abnk-website's i18n resources.ts,
 * decision D5), and the en-us data sets are bound to that structure via
 * `satisfies` — missing fields or structural drift fail at
 * `npm run typecheck`, replacing the previous unchecked `as unknown as`
 * widening casts.
 */

import zhClientsRaw from './zh-cn/clients.json';
import zhOperatorsRaw from './zh-cn/operators.json';

/**
 * 拓宽 JSON import 的字面量类型（TS 对 JSON 字符串推断为宽化 string、
 * 空数组推断为 never[]——与 abnk-website i18n resources.ts 同款实现）。
 * Widens literal types from JSON imports (TS infers JSON strings as the
 * widened `string` and empty arrays as `never[]` — the same implementation
 * as abnk-website's i18n resources.ts).
 */
type Widen<T> = T extends string
  ? string
  : T extends number | boolean | null
    ? T
    : T extends readonly (infer U)[]
      ? Widen<U>[]
      : T extends object
        ? { [K in keyof T]: Widen<T[K]> }
        : T;

/** 客户数据文件结构（_source 双语文档化出处；zh-cn 为结构事实源） */
/** Clients data-file shape (with `_source` documenting provenance bilingually;
 * zh-cn is the source of structural truth). */
export type ClientsFile = Widen<typeof zhClientsRaw>;

/** 运营员数据文件结构（登录口径：username/password 原型明文） */
/** Operators data-file shape (login convention: prototype plaintext credentials). */
export type OperatorsFile = Widen<typeof zhOperatorsRaw>;
