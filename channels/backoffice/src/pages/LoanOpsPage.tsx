import { useEffect, useState } from 'react';
import { Alert, Button, Space, Table, Tag, Tooltip, Typography } from 'antd';
import { loanRepository } from '@/api';
import type { LoanOpsItem } from '@/api';
import { ERR } from '@/api/errors';
import { apiErrorMessage } from '@/i18n/api-error';
import { formatMoney } from '@/utils/format';
import { interpolate, useLoanOps } from '@/i18n';

/**
 * 贷款运营页（任务 P1.4）——（只读）审批/放款操作位：
 * POC 基线不提供写操作，按钮为禁用预埋位，P2.5 网关内部通道接入后启用。
 */
export default function LoanOpsPage() {
  const t = useLoanOps();
  const [loans, setLoans] = useState<LoanOpsItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    loanRepository
      .listLoans()
      .then((items) => {
        setLoans(items);
        setError(null);
      })
      .catch((err) => {
        // 失败必须可见：静默吞错会渲染成空表（"No data"），与"无数据"不可区分
        setError(apiErrorMessage(err, ERR.unknown));
      })
      .finally(() => setLoading(false));
  }, []);

  return (
    <Space direction="vertical" size={16} style={{ width: '100%' }}>
      <Typography.Title level={4} style={{ margin: 0 }}>
        {t.title}
      </Typography.Title>
      <Alert type="info" showIcon message={t.readonlyAlert} />
      {error && <Alert type="error" showIcon message={error} />}
      <Table<LoanOpsItem>
        rowKey="loanId"
        loading={loading}
        dataSource={loans}
        pagination={false}
        columns={[
          { title: t.columns.loanId, dataIndex: 'loanId', width: 90 },
          { title: t.columns.client, dataIndex: 'clientName' },
          { title: t.columns.product, dataIndex: 'productName' },
          {
            title: t.columns.principal,
            dataIndex: 'principal',
            align: 'right',
            render: (v: number) => formatMoney(v),
          },
          {
            title: t.columns.interestRate,
            dataIndex: 'interestRate',
            width: 80,
            render: (v: number) => `${v.toFixed(1)}%`,
          },
          { title: t.columns.termMonths, dataIndex: 'termMonths', width: 90 },
          {
            title: t.columns.status,
            key: 'status',
            width: 240,
            render: (_, record) => (
              <Space size={4} wrap>
                <Tag color={record.inArrears ? 'warning' : 'success'}>{record.status}</Tag>
                {record.inArrears && (
                  <Tooltip
                    title={interpolate(t.overdueTooltip, {
                      date: record.overdueSinceDate ?? '—',
                      amount: formatMoney(record.totalOverdue),
                    })}
                  >
                    <Tag color="error">
                      {interpolate(t.overdueTag, {
                        days: record.overdueDays,
                        classification: record.delinquencyClassification ?? '—',
                      })}
                    </Tag>
                  </Tooltip>
                )}
              </Space>
            ),
          },
          {
            title: t.columns.action,
            key: 'action',
            width: 200,
            render: () => (
              <Space size={8}>
                <Tooltip title={t.actions.readonlyTooltip}>
                  <Button size="small" disabled>
                    {t.actions.approve}
                  </Button>
                </Tooltip>
                <Tooltip title={t.actions.readonlyTooltip}>
                  <Button size="small" disabled>
                    {t.actions.disburse}
                  </Button>
                </Tooltip>
              </Space>
            ),
          },
        ]}
      />
      <Typography.Text type="secondary" style={{ fontSize: 12 }}>
        {t.dataNote}
      </Typography.Text>
    </Space>
  );
}
