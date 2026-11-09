/**
 * Fineract 原始（raw）形态接口与归一化工具（任务 P3.2）。
 *
 * 架构口径（P2.5 定案、P2.6 白名单容差声明）：网关 `/bo/api/**` 为**全量转发面**
 * （不做聚合/改形），故 `GET /bo/api/v1/clients*` 等端点返回的是 Fineract 原始
 * JSON，而非冻结契约的 ClientListResult / ClientDetail 形态。本模块定义适配层
 * 消费的 raw 结构 + 日期归一化 + 推导算法，供 remote repository 组装出与 mock
 * 完全一致的 repository 接口形态（换实现不改页面）。
 *
 * 字段来源实测依据：P0.2 capability-probe.json、P2.5 taskP2.5-bo-evidence.txt、
 * P3.2 接线探查（2026-11-09，本地生产形态栈）。
 */

import type { GatewayClient } from './generatedClient';

/** Fineract 日期双形态：`YYYY-MM-DD` 字符串或 `[年, 月, 日]` 数组（端点间不一致） */
export type RawDate = string | number[];

/** `YYYY-MM-DD` 归一化（数组形态 → 字符串；空值 → null） */
export function normalizeDate(value: RawDate | null | undefined): string | null {
  if (value === null || value === undefined || value === '') {
    return null;
  }
  if (typeof value === 'string') {
    return value;
  }
  const [year, month, day] = value;
  if (typeof year !== 'number' || typeof month !== 'number' || typeof day !== 'number') {
    return null;
  }
  return `${String(year).padStart(4, '0')}-${String(month).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
}

/** 到期状态推导（与 mockStore.deriveStatus 同算法：ISO 日期字符串字典序即时间序） */
export function deriveStatus(expiryDate: string, businessDate: string): 'VALID' | 'EXPIRED' {
  return expiryDate < businessDate ? 'EXPIRED' : 'VALID';
}

/** 两日期间隔天数（to − from；解析失败返回 0——逾期天数兜底口径） */
export function daysBetween(from: string, to: string): number {
  const fromMs = Date.parse(`${from}T00:00:00Z`);
  const toMs = Date.parse(`${to}T00:00:00Z`);
  if (Number.isNaN(fromMs) || Number.isNaN(toMs)) {
    return 0;
  }
  return Math.round((toMs - fromMs) / 86_400_000);
}

// ── raw 形态（转发面端点实测结构，仅声明适配层消费的字段） ────────────────

/** `GET /clients`（Spring 分页包裹） */
export interface RawClientsPage {
  totalFilteredRecords: number;
  pageItems: RawClientRow[];
}

export interface RawClientRow {
  id: number;
  externalId?: string;
  displayName?: string;
  mobileNo?: string;
  officeName?: string;
  status?: { value?: string };
}

/** `GET /clients/{id}` */
export interface RawClientFull extends RawClientRow {
  firstname?: string;
  lastname?: string;
  emailAddress?: string;
}

/** `GET /clients/{id}/identifiers`（数组） */
export interface RawIdentifier {
  id: number;
  clientId?: number;
  documentType?: { id?: number; name?: string };
  documentKey?: string;
  /** Fineract 记录状态：`clientIdentifierStatusType.active` / `...inactive` */
  status?: string;
  description?: string;
  issuanceDate?: RawDate;
  expiryDate?: RawDate;
}

/** `GET /clients/{id}/accounts` */
export interface RawClientAccounts {
  savingsAccounts?: RawSavingsAccount[];
  loanAccounts?: Array<{ id: number; status?: { active?: boolean } }>;
}

export interface RawSavingsAccount {
  id: number;
  accountNo?: string;
  productName?: string;
  accountBalance?: number;
  currency?: { code?: string };
  status?: { value?: string };
  /** `depositAccountType.savingsDeposit`(100) / `depositAccountType.fixedDeposit`(200) */
  depositType?: { code?: string };
}

/** `GET /fixeddepositaccounts/{id}`——定期账户补齐字段（到期日不在 /accounts 投影中） */
export interface RawFixedDepositDetail {
  nominalAnnualInterestRate?: number;
  maturityDate?: RawDate;
}

/** `GET /businessdate`（数组） */
export interface RawBusinessDate {
  type?: string;
  date?: RawDate;
}

/** 贷款 raw 公共投影（`GET /loans` 列表项与 `GET /loans/{id}` 详情共有字段） */
export interface RawLoanLike {
  id: number;
  externalId?: string;
  loanProductName?: string;
  principal?: number;
  annualInterestRate?: number;
  termFrequency?: number;
  status?: { value?: string };
  inArrears?: boolean;
  summary?: { totalOverdue?: number; overdueSinceDate?: RawDate };
  /** 仅 `GET /loans/{id}` 详情携带（列表项缺此字段——适配层按需补拉） */
  delinquencyRange?: { classification?: string } | null;
}

/** `GET /loans` 列表项（raw 公共投影 + 客户列） */
export interface RawLoanListItem extends RawLoanLike {
  clientId?: number;
  clientName?: string;
}

// ── 业务日期（推导基准——缓存一次/会话） ──────────────────────────────

let businessDateCache: Promise<string> | null = null;

/**
 * 取 Fineract 业务日期（证照到期推导 / 逾期天数推导的基准——与网关
 * /me/identity 的服务端推导同一数据源）。endpoint 缺失时回退当天日期。
 */
export async function getBusinessDate(client: GatewayClient): Promise<string> {
  if (!businessDateCache) {
    businessDateCache = client
      .rawGet<RawBusinessDate[]>('/bo/api/v1/businessdate')
      .then((entries) => {
        const entry = entries.find((it) => it.type === 'BUSINESS_DATE') ?? entries[0];
        return normalizeDate(entry?.date) ?? new Date().toISOString().slice(0, 10);
      })
      .catch((err: unknown) => {
        businessDateCache = null; // 失败不缓存（如 token 过期）——下次调用重试
        throw err;
      });
  }
  return businessDateCache;
}
