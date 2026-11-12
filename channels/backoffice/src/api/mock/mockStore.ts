/**
 * mock 数据存储（任务 P1.4）——P1.3 fixtures 同口径：JSON 资产 +
 * 运行时可变内存副本。mock 提交（证照编辑）只改内存态，刷新页面还原。
 * Mock data store (task P1.4) — same convention as P1.3 fixtures: JSON assets
 * plus a runtime mutable in-memory copy. Mock submissions (identifier edits)
 * mutate memory only; a page refresh restores the original data.
 *
 * 任务 2.2：数据集双语化——zh-cn / en-us 两套 JSON 资产由构建期变量
 * `VITE_ABNK_DATA_LOCALE`（部署侧 `ABNK_DATA_LOCALE`，经 Dockerfile ARG
 * 注入，决策 D3）静态三元选择；选择表达式经 Vite 构建期常量折叠 +
 * tree-shaking，bundle 只含所选数据集。数据集选择是部署期决策：
 * 运行时 UI 语言切换不切数据集（UI 词条与数据集互不耦合）。
 * Task 2.2: bilingual data sets — the zh-cn / en-us JSON assets are selected
 * by a static ternary on the build-time variable `VITE_ABNK_DATA_LOCALE`
 * (deployment-side `ABNK_DATA_LOCALE`, injected through a Dockerfile ARG,
 * decision D3); constant folding plus tree-shaking keep only the chosen data
 * set in the bundle. Data-set selection is a deploy-time decision: runtime
 * UI language switching never switches the data set (UI strings and data sets
 * stay decoupled).
 *
 * ⚠️ Vite env 前缀铁律：进入 `import.meta.env` 的变量必须 `VITE_` 前缀
 * ——部署侧变量名 `ABNK_DATA_LOCALE` 与代码侧消费名
 * `VITE_ABNK_DATA_LOCALE` 两名字并存是设计（命名域分离），勿混写。
 * ⚠️ Vite env prefix rule: variables entering `import.meta.env` must carry
 * the `VITE_` prefix — the deployment-side name `ABNK_DATA_LOCALE` and the
 * code-side name `VITE_ABNK_DATA_LOCALE` coexist by design (separate naming
 * domains); do not conflate them.
 */

import type { ClientDetail } from '../repositories/clientRepository';
import zhClientsRaw from './mockData/zh-cn/clients.json';
import enClientsRaw from './mockData/en-us/clients.json';
import zhOperatorsRaw from './mockData/zh-cn/operators.json';
import enOperatorsRaw from './mockData/en-us/operators.json';
import type { ClientsFile, OperatorsFile } from './mockData/types';

// 双语数据文件过 satisfies 编译期结构校验（mockData/types.ts 为结构口径，
// 结构漂移在 typecheck 拦截——替换原 `as unknown as` 宽转换，任务 2.2）。
// Both data files pass a compile-time `satisfies` structure check
// (mockData/types.ts owns the shape; structural drift fails at typecheck —
// replacing the previous `as unknown as` widening casts, task 2.2).
const zhClientsFile = zhClientsRaw satisfies ClientsFile;
const enClientsFile = enClientsRaw satisfies ClientsFile;
const zhOperatorsFile = zhOperatorsRaw satisfies OperatorsFile;
const enOperatorsFile = enOperatorsRaw satisfies OperatorsFile;

// 构建期数据集选择（静态三元——Vite 字面量替换后死分支被 tree-shaking
// 消除，勿改写为运行时函数/间接引用，否则两套数据都进 bundle）。
// Build-time data-set selection (a static ternary — after Vite's literal
// replacement the dead branch is tree-shaken away; never rewrite this as a
// runtime function/indirect reference, or both data sets land in the bundle).
const useEnDataSet = import.meta.env.VITE_ABNK_DATA_LOCALE === 'en-us';

/** 当前数据集语言（诊断用途，对齐 dataSource.ts 的 dataMode 导出惯例） */
/** The active data-set locale (diagnostics; mirrors the dataMode export convention of dataSource.ts). */
export const dataLocale: 'zh-cn' | 'en-us' = useEnDataSet ? 'en-us' : 'zh-cn';

/** mock 数据快照（只读源） */
/** Read-only mock data snapshot. */
export const clientsFile: ClientsFile = useEnDataSet ? enClientsFile : zhClientsFile;

/** 运营员数据（登录口径——mockAuth 消费，数据集选择收口单一事实源） */
/** Operator data (login convention — consumed by mockAuth; data-set selection funnels into this single source of truth). */
export const operatorsFile: OperatorsFile = useEnDataSet ? enOperatorsFile : zhOperatorsFile;

/** 业务日期（P0.3 种子推进后的时点，用于到期状态推导） */
/** Business date (the point-in-time after the P0.3 seed advance, used to derive expiry status). */
export const businessDate = clientsFile.businessDate;

/**
 * 运行时可变副本（mock 编辑回显的载体）。数据文件形态较契约
 * ClientDetail 少两个列表页推导字段（见 mockData/types.ts），此处断言
 * 收窄到 ClientDetail[]（两字段运行时由 mockClient.summaryOf 推导）。
 * Runtime mutable copy (the carrier for mock edit echo-backs). The data-file
 * shape lacks the two list-page derived fields versus the contractual
 * ClientDetail (see mockData/types.ts); this assertion narrows to
 * ClientDetail[] (both fields are derived at runtime by mockClient.summaryOf).
 */
export const clientStore: ClientDetail[] = structuredClone(clientsFile.clients) as ClientDetail[];

/** mock 模拟网络延迟 */
/** Simulated network latency for mock mode. */
export function delay(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

/** 到期状态推导：expiryDate 对业务日期比较（ISO 日期字符串字典序即时间序） */
/** Expiry-status derivation: compares expiryDate against the business date
 * (ISO date strings sort chronologically as plain strings). */
export function deriveStatus(
  expiryDate: string,
  reference: string = businessDate,
): 'VALID' | 'EXPIRED' {
  return expiryDate < reference ? 'EXPIRED' : 'VALID';
}
