/**
 * LoanRepository 的 mock 实现（任务 P1.4）——从客户 store 派生
 * 贷款运营列表（基线只读：审批/放款操作位不提供写方法）。
 */

import type { LoanRepository, LoanOpsItem } from '../repositories/loanRepository';
import { clientStore, delay } from './mockStore';

export const mockLoanRepository: LoanRepository = {
  async listLoans(): Promise<LoanOpsItem[]> {
    await delay(300);
    return clientStore.flatMap((c) => {
      if (c.loan === null) {
        return [];
      }
      return [
        {
          ...structuredClone(c.loan),
          clientId: c.clientId,
          clientName: c.displayName,
        },
      ];
    });
  },
};
