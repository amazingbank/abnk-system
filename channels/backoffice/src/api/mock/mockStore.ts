/**
 * mock 数据存储（任务 P1.4）——P1.3 fixtures 同口径：JSON 资产 +
 * 运行时可变内存副本。mock 提交（证照编辑）只改内存态，刷新页面还原。
 * Mock data store (task P1.4) — same convention as P1.3 fixtures: JSON assets
 * plus a runtime mutable in-memory copy. Mock submissions (identifier edits)
 * mutate memory only; a page refresh restores the original data.
 *
 * Phase 7 D3 修订（2026-11-12 用户拍板）：数据集双语两套全量进包，
 * 运行时随 UI 语言切换（zh-cn / en-us）——初始数据语言 = 构建期变量
 * `VITE_ABNK_DATA_LOCALE`（部署侧 `ABNK_DATA_LOCALE` 经 Dockerfile ARG
 * 注入，未注入即 en-us「默认英文」口径）；用户手动切换 UI 语言时经
 * [reseedDataSet] 切换数据集并重置内存副本（编辑态丢弃）。原「构建期
 * 静态三元 + tree-shaking 单集进包」判据随 D3 修订废止（Phase 2 V2.2.3
 * 被本口径取代——双集进包成为运行时选择的必要条件）。
 * Phase 7 revision of decision D3 (user's call, 2026-11-12): both bilingual
 * data sets ship in the bundle and the active one follows the UI locale at
 * runtime (zh-cn / en-us) — the initial data locale comes from the
 * build-time variable `VITE_ABNK_DATA_LOCALE` (deployment-side
 * `ABNK_DATA_LOCALE` via a Dockerfile ARG; un-injected means en-us, the
 * "English by default" call); a manual UI-language switch swaps the data
 * set via [reseedDataSet] and drops the in-memory edits. The previous
 * build-time static-ternary + tree-shaking single-set criterion is
 * superseded by this revision (Phase 2 V2.2.3 replaced — both sets in the
 * bundle is now the prerequisite for runtime switching).
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

// 数据集码类型（zh-cn / en-us，与 i18n Locale 码同形）。
// Data-set locale code type (zh-cn / en-us, same shape as the i18n Locale codes).
export type DataLocale = 'zh-cn' | 'en-us';

// 初始数据集语言 = 构建期注入；显式 zh-cn 才取中文，其余（含未注入）
// 一律 en-us（D3 修订拍板：应用数据默认英文）。
// Initial data-set locale = build-time injection; only an explicit zh-cn
// picks the Chinese set, anything else (including un-injected) resolves to
// en-us (the D3-revision call: app data defaults to English).
const initialDataLocale: DataLocale =
  import.meta.env.VITE_ABNK_DATA_LOCALE === 'zh-cn' ? 'zh-cn' : 'en-us';

// 当前数据集语言（运行时可变——ESM live binding，消费方读到的永远是
// reseedDataSet 赋值后的最新值；诊断用途，对齐 dataSource.ts 的 dataMode
// 导出惯例）。
// The active data-set locale (mutable at runtime — the ESM live binding
// always exposes the value after the latest reseedDataSet assignment;
// diagnostics, mirroring the dataMode export convention of dataSource.ts).
export let dataLocale: DataLocale = initialDataLocale;

// 数据纪元（D3 修订）：每次 reseedDataSet 自增——BoLayout 以其为 <Outlet>
// 的 key，切换语言（= 数据集切换）时页面子树 remount、数据重新拉取（页面
// 的 useEffect 仅 mount 拉数据，不依赖 locale）。
// Data epoch (D3 revision): bumped by every reseedDataSet — BoLayout uses it
// as the <Outlet> key so a language switch (i.e. a data-set switch) remounts
// the page subtree and the data reloads (page useEffects fetch on mount only,
// not on locale).
export let dataEpoch = 0;

// 当前生效数据文件（live binding；切换时由 reseedDataSet 重新指向）。
// The active data files (live bindings; reseedDataSet re-points them on switch).
export let clientsFile: ClientsFile =
  initialDataLocale === 'en-us' ? enClientsFile : zhClientsFile;
export let operatorsFile: OperatorsFile =
  initialDataLocale === 'en-us' ? enOperatorsFile : zhOperatorsFile;

/** 业务日期（当前数据集的时点，用于到期状态推导；随数据集切换更新） */
/** Business date (the active data set's point-in-time, used to derive expiry status; follows the data set). */
export let businessDate = clientsFile.businessDate;

/**
 * 运行时可变副本（mock 编辑回显的载体）。**引用稳定**：reseed 用
 * splice 原地重填而非替换数组——mockClient 等消费方持有的引用持续
 * 有效。数据文件形态较契约 ClientDetail 少两个列表页推导字段（见
 * mockData/types.ts），此处断言收窄到 ClientDetail[]（两字段运行时由
 * mockClient.summaryOf 推导）。
 * Runtime mutable copy (the carrier for mock edit echo-backs). The array
 * **reference is stable**: reseeding refills in place via splice instead of
 * replacing the array, so references held by consumers such as mockClient
 * stay valid. The data-file shape lacks the two list-page derived fields
 * versus the contractual ClientDetail (see mockData/types.ts); this
 * assertion narrows to ClientDetail[] (both fields are derived at runtime
 * by mockClient.summaryOf).
 */
export const clientStore: ClientDetail[] = structuredClone(clientsFile.clients) as ClientDetail[];

/**
 * 切换数据集并重置内存副本（D3 修订核心入口——locale-provider 的用户
 * 手动切换经此调用）：更新数据文件指向 + 原地重填 clientStore = 既有
 * 编辑态（证照更新等 mock 提交）全部丢弃。同语言重复调用幂等无害。
 * Swaps the data set and resets the in-memory copy (the core entry of the
 * D3 revision — the locale-provider's manual switch path calls this):
 * re-points the data files and refills clientStore in place, discarding any
 * mock-submitted edits (identifier updates etc.). Re-calling with the same
 * locale is an idempotent no-op.
 */
export function reseedDataSet(next: DataLocale): void {
  const nextClients = next === 'en-us' ? enClientsFile : zhClientsFile;
  const nextOperators = next === 'en-us' ? enOperatorsFile : zhOperatorsFile;
  dataLocale = next;
  dataEpoch += 1;
  clientsFile = nextClients;
  operatorsFile = nextOperators;
  businessDate = nextClients.businessDate;
  clientStore.splice(0, clientStore.length, ...(structuredClone(nextClients.clients) as ClientDetail[]));
}

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
