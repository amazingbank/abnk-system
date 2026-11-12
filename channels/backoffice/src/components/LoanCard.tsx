import { Card, Descriptions, Space, Tag } from 'antd';
import type { LoanSummary } from '@/api';
import { formatMoney } from '@/utils/format';
import { interpolate, useLoanOps } from '@/i18n';

/** 贷款信息卡（客户详情页——含逾期分档展示） */
export default function LoanCard({ loan }: { loan: LoanSummary }) {
  const t = useLoanOps();

  return (
    <Card title={t.loanCardTitle} size="small">
      <Descriptions column={2} size="small">
        <Descriptions.Item label={t.loanCard.loanId}>{loan.loanId}</Descriptions.Item>
        <Descriptions.Item label={t.loanCard.externalId}>{loan.externalId}</Descriptions.Item>
        <Descriptions.Item label={t.loanCard.product}>{loan.productName}</Descriptions.Item>
        <Descriptions.Item label={t.loanCard.status}>
          <Space size={4} wrap>
            <Tag color={loan.inArrears ? 'warning' : 'success'}>{loan.status}</Tag>
            {loan.inArrears && (
              <Tag color="error">
                {interpolate(t.overdueTag, {
                  days: loan.overdueDays,
                  classification: loan.delinquencyClassification ?? '—',
                })}
              </Tag>
            )}
          </Space>
        </Descriptions.Item>
        <Descriptions.Item label={t.loanCard.principal}>
          {formatMoney(loan.principal)}
        </Descriptions.Item>
        <Descriptions.Item label={t.loanCard.interestRate}>
          {loan.interestRate.toFixed(1)}%
        </Descriptions.Item>
        <Descriptions.Item label={t.loanCard.overdueSince}>
          {loan.overdueSinceDate ?? '—'}
        </Descriptions.Item>
        <Descriptions.Item label={t.loanCard.totalOverdue}>
          {formatMoney(loan.totalOverdue)}
        </Descriptions.Item>
      </Descriptions>
    </Card>
  );
}
