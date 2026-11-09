/**
 * 数据源切换（任务 P3.2）——mock / remote 的唯一切换点（页面层与
 * repository 接口零感知，分层纪律兑现）。
 *
 * 切换判据：构建期 env `VITE_ABNK_API_BASE` 非空 → remote（P2.6 生成
 * client 经网关连真实 Fineract 数据）；空 / 未设置 → mock（P0.3 种子
 * 快照，P1 原型口径）。
 *
 * 基址取值口径：
 * - `'/'` = 同源相对路径——dev 形态走 vite dev server proxy（`/bo` →
 *   网关 :8080，见 vite.config.ts）；生产形态（P3.4 容器）走同域 nginx
 *   反代（CORS 天然规避）；
 * - 绝对基址（如 http://localhost:8080）——跨 origin 直连（网关 CORS
 *   已在 P3.1 放行，CorsConfig + OPTIONS 直通口径）。
 */

import type { AuthRepository } from './repositories/authRepository';
import type { ClientRepository } from './repositories/clientRepository';
import type { LoanRepository } from './repositories/loanRepository';
import { mockAuthRepository } from './mock/mockAuth';
import { mockClientRepository } from './mock/mockClient';
import { mockLoanRepository } from './mock/mockLoan';
import { createGatewayClient } from './remote/generatedClient';
import { createRemoteAuthRepository } from './remote/remoteAuth';
import { createRemoteClientRepository } from './remote/remoteClient';
import { createRemoteLoanRepository } from './remote/remoteLoan';

export type DataMode = 'mock' | 'remote';

const envBase = import.meta.env.VITE_ABNK_API_BASE?.trim() ?? '';

/** 当前数据模式（mock / remote）——dev 调试面板或诊断用途 */
export const dataMode: DataMode = envBase === '' ? 'mock' : 'remote';

/** 基址规范化：'/'（同源相对口径）→ ''；绝对基址剥尾部斜杠 */
function normalizeBase(base: string): string {
  const trimmed = base.replace(/\/+$/, '');
  return trimmed;
}

function assemble(): {
  auth: AuthRepository;
  clients: ClientRepository;
  loans: LoanRepository;
} {
  if (dataMode === 'mock') {
    return {
      auth: mockAuthRepository,
      clients: mockClientRepository,
      loans: mockLoanRepository,
    };
  }
  const gateway = createGatewayClient(normalizeBase(envBase));
  return {
    auth: createRemoteAuthRepository(gateway),
    clients: createRemoteClientRepository(gateway),
    loans: createRemoteLoanRepository(gateway),
  };
}

const assembled = assemble();

export const authRepository: AuthRepository = assembled.auth;
export const clientRepository: ClientRepository = assembled.clients;
export const loanRepository: LoanRepository = assembled.loans;
