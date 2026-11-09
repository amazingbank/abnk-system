/**
 * repository 装配点（任务 P1.4 建，P3.2 接线切换）——
 * P3.2 起实例装配移交 `dataSource`（按 `VITE_ABNK_API_BASE` 切换
 * mock / remote 实现）；本文件保留页面层一致的 import 路径与类型出口
 * （换实现不改页面——分层纪律兑现）。
 */

export { authRepository, clientRepository, loanRepository } from './dataSource';
export type {
  AuthRepository,
  AuthSession,
} from './repositories/authRepository';
export type {
  ClientRepository,
  ClientListQuery,
  ClientListResult,
  ClientSummary,
  ClientDetail,
  ClientIdentifier,
  IdentifierUpdatePayload,
  IdentifierStatus,
  SavingsAccountSummary,
  FixedDepositSummary,
  LoanSummary,
} from './repositories/clientRepository';
export type { LoanRepository, LoanOpsItem } from './repositories/loanRepository';
