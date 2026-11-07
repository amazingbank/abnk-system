/**
 * 客户资源 repository 接口——方法签名即契约草签（Sprint v0.0.1 Part02 任务 P1.4）。
 *
 * P1 阶段由 mock 实现（`src/api/mock/mockClient.ts`，数据对齐 P0.3 种子快照）；
 * P3.2 接线时替换为 OpenAPI 生成 client 实现（契约冻结于 P1.5
 * `channels/shared/api-contract/openapi.yaml` 内部面：GET /bo/clients、
 * GET /bo/clients/{id}、PUT /bo/clients/{id}/identifiers/{identifierId}）。
 */

/** 证照到期状态（由到期日对业务日期推导；基线只读展示，不做拦截——POC 演示增量） */
export type IdentifierStatus = 'VALID' | 'EXPIRED';

/** 客户证照（对齐 Fineract client identifiers 结构 + P0.3 种子快照字段） */
export interface ClientIdentifier {
  identifierId: number;
  documentTypeId: number;
  documentTypeName: string;
  /** 证件号 */
  documentKey: string;
  /** Fineract 记录状态（ACTIVE/INACTIVE） */
  status: 'ACTIVE' | 'INACTIVE';
  /** 到期状态推导值（expiryDate 对业务日期比较） */
  derivedStatus: IdentifierStatus;
  issuanceDate: string;
  /** 到期日（YYYY-MM-DD） */
  expiryDate: string;
  description?: string;
}

/** 活期账户概要 */
export interface SavingsAccountSummary {
  id: number;
  accountNo: string;
  productName: string;
  accountBalance: number;
  currency: string;
  status: string;
}

/** 定期账户概要 */
export interface FixedDepositSummary {
  id: number;
  accountNo: string;
  productName: string;
  accountBalance: number;
  interestRate: number;
  maturityDate: string;
  status: string;
}

/** 贷款概要（含逾期分档——P0.3 客户 C 口径） */
export interface LoanSummary {
  loanId: number;
  externalId: string;
  productName: string;
  principal: number;
  interestRate: number;
  termMonths: number;
  status: string;
  inArrears: boolean;
  overdueDays: number;
  overdueSinceDate: string | null;
  totalOverdue: number;
  delinquencyClassification: string | null;
}

/** 客户列表行（列表页消费的最小投影） */
export interface ClientSummary {
  clientId: number;
  externalId: string;
  displayName: string;
  mobileNo: string;
  officeName: string;
  status: string;
  identifierStatus: IdentifierStatus | null;
  identifierExpiryDate: string | null;
}

/** 客户详情（详情页消费的全量形态） */
export interface ClientDetail extends ClientSummary {
  firstname: string;
  lastname: string;
  emailAddress: string;
  identifier: ClientIdentifier | null;
  savingsAccounts: SavingsAccountSummary[];
  fixedDepositAccounts: FixedDepositSummary[];
  loan: LoanSummary | null;
}

/** 列表查询参数（search 命中姓名/外部编号/手机号） */
export interface ClientListQuery {
  search?: string;
}

export interface ClientListResult {
  total: number;
  items: ClientSummary[];
}

/** 证照更新载荷（P0.2 实测 Fineract identifiers PUT 口径：expiryDate 为核心可变更字段） */
export interface IdentifierUpdatePayload {
  /** 到期日（YYYY-MM-DD，必填） */
  expiryDate: string;
  /** 证件号（可选——变更时提供） */
  documentKey?: string;
  description?: string;
}

export interface ClientRepository {
  /** 客户列表（含证照状态列数据） */
  listClients(query?: ClientListQuery): Promise<ClientListResult>;
  /** 客户详情（基本信息 + 证照 + 账户 + 贷款） */
  getClientDetail(clientId: number): Promise<ClientDetail>;
  /** 证照更新（详情页编辑表单提交） */
  updateClientIdentifier(
    clientId: number,
    identifierId: number,
    payload: IdentifierUpdatePayload,
  ): Promise<ClientIdentifier>;
}
