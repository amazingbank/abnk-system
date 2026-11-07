/**
 * 贷款运营 repository 接口——契约草签（任务 P1.4）。
 *
 * P1 阶段 mock 实现；P3.2 接线时替换为生成 client（契约内部面：
 * GET /bo/loans + 贷款 command 族转发——审批 approve / 放款 disburse
 * 为 P2.5 网关内部通道接入后启用，基线只读）。
 */

import type { LoanSummary } from './clientRepository';

/** 贷款运营列表行（LoanSummary + 客户投影） */
export interface LoanOpsItem extends LoanSummary {
  clientId: number;
  clientName: string;
}

export interface LoanRepository {
  /** 贷款运营列表（只读——审批/放款操作位为 POC 预埋，不在本接口） */
  listLoans(): Promise<LoanOpsItem[]>;
}
