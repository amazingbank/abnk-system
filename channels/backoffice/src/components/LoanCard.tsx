import { Card, Descriptions, Space, Tag } from 'antd';
import type { LoanSummary } from '@/api';
import { formatMoney } from '@/utils/format';

/** 贷款信息卡（客户详情页——含逾期分档展示） */
export default function LoanCard({ loan }: { loan: LoanSummary }) {
  return (
    <Card title="贷款信息" size="small">
      <Descriptions column={2} size="small">
        <Descriptions.Item label="贷款号">{loan.loanId}</Descriptions.Item>
        <Descriptions.Item label="外部编号">{loan.externalId}</Descriptions.Item>
        <Descriptions.Item label="产品">{loan.productName}</Descriptions.Item>
        <Descriptions.Item label="状态">
          <Space size={4} wrap>
            <Tag color={loan.inArrears ? 'warning' : 'success'}>{loan.status}</Tag>
            {loan.inArrears && (
              <Tag color="error">
                逾期 {loan.overdueDays} 天（{loan.delinquencyClassification ?? '—'}）
              </Tag>
            )}
          </Space>
        </Descriptions.Item>
        <Descriptions.Item label="本金">{formatMoney(loan.principal)}</Descriptions.Item>
        <Descriptions.Item label="利率">{loan.interestRate.toFixed(1)}%</Descriptions.Item>
        <Descriptions.Item label="逾期起算日">{loan.overdueSinceDate ?? '—'}</Descriptions.Item>
        <Descriptions.Item label="逾期总额">{formatMoney(loan.totalOverdue)}</Descriptions.Item>
      </Descriptions>
    </Card>
  );
}
