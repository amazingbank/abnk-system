/**
 * repository 装配点（任务 P1.4）——P1 阶段全 mock；P3.2 接线时
 * 仅替换本文件装配为 OpenAPI 生成 client 实现（换实现不改页面）。
 */

import type { AuthRepository } from './repositories/authRepository';
import type { ClientRepository } from './repositories/clientRepository';
import type { LoanRepository } from './repositories/loanRepository';
import { mockAuthRepository } from './mock/mockAuth';
import { mockClientRepository } from './mock/mockClient';
import { mockLoanRepository } from './mock/mockLoan';

export const authRepository: AuthRepository = mockAuthRepository;
export const clientRepository: ClientRepository = mockClientRepository;
export const loanRepository: LoanRepository = mockLoanRepository;

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
