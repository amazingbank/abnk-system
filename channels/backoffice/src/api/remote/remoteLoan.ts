/**
 * LoanRepository 的 remote 实现（任务 P3.2）——`GET /bo/api/v1/loans`（raw
 * Fineract 分页）映射为 LoanOpsItem[]；逾期分档不在列表投影中，对 inArrears
 * 贷款并发补拉 `GET /loans/{id}` 详情（delinquencyRange.classification——
 * P0.3 客户 C 分档口径）。基线只读（审批/放款操作位不提供写方法）。
 */

import type { LoanOpsItem, LoanRepository } from '../repositories/loanRepository';
import { toApiError, type GatewayClient } from './generatedClient';
import { daysBetween, getBusinessDate, normalizeDate, type RawLoanLike, type RawLoanListItem } from './fineractRaw';

/** raw 贷款列表项/详情 → 契约 LoanSummary 投影（与 remoteClient.mapLoan 同算法） */
function mapLoanSummary(raw: RawLoanLike, businessDate: string): LoanOpsItem {
  const overdueSinceDate = normalizeDate(raw.summary?.overdueSinceDate);
  return {
    loanId: raw.id,
    externalId: raw.externalId ?? '',
    productName: raw.loanProductName ?? '',
    principal: raw.principal ?? 0,
    interestRate: raw.annualInterestRate ?? 0,
    termMonths: raw.termFrequency ?? 0,
    status: raw.status?.value ?? '',
    inArrears: raw.inArrears ?? false,
    overdueDays: overdueSinceDate ? daysBetween(overdueSinceDate, businessDate) : 0,
    overdueSinceDate,
    totalOverdue: raw.summary?.totalOverdue ?? 0,
    delinquencyClassification: raw.delinquencyRange?.classification ?? null,
    clientId: (raw as RawLoanListItem).clientId ?? 0,
    clientName: (raw as RawLoanListItem).clientName ?? '',
  };
}

export function createRemoteLoanRepository(client: GatewayClient): LoanRepository {
  return {
    async listLoans(): Promise<LoanOpsItem[]> {
      try {
        const page = (
          await client.loans.listLoans()
        ).data as unknown as { totalFilteredRecords: number; pageItems: RawLoanListItem[] };
        const items = page.pageItems ?? [];
        const businessDate = await getBusinessDate(client);
        // 分档不在列表投影中——仅逾期贷款补拉详情（POC 数据量口径）
        const details = await Promise.all(
          items.map((item) =>
            item.inArrears
              ? client.loans
                  .getLoan(item.id)
                  .then((resp) => resp.data as unknown as RawLoanLike)
                  .catch(() => null)
              : Promise.resolve(null),
          ),
        );
        return items.map((item, i) =>
          mapLoanSummary(
            { ...item, delinquencyRange: details[i]?.delinquencyRange ?? item.delinquencyRange },
            businessDate,
          ),
        );
      } catch (err) {
        throw toApiError(err);
      }
    },
  };
}
