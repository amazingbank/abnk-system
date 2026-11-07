import { useEffect, useState } from 'react';
import { Alert, Button, Space, Table, Tag, Tooltip, Typography } from 'antd';
import { loanRepository } from '@/api';
import type { LoanOpsItem } from '@/api';
import { formatMoney } from '@/utils/format';

/**
 * 贷款运营页（任务 P1.4）——（只读）审批/放款操作位：
 * POC 基线不提供写操作，按钮为禁用预埋位，P2.5 网关内部通道接入后启用。
 */
export default function LoanOpsPage() {
  const [loans, setLoans] = useState<LoanOpsItem[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loanRepository
      .listLoans()
      .then(setLoans)
      .finally(() => setLoading(false));
  }, []);

  return (
    <Space direction="vertical" size={16} style={{ width: '100%' }}>
      <Typography.Title level={4} style={{ margin: 0 }}>
        贷款运营
      </Typography.Title>
      <Alert
        type="info"
        showIcon
        message="POC 基线只读——审批/放款为预埋操作位，P2.5 网关内部通道（/bo/api/*）接入后启用"
      />
      <Table<LoanOpsItem>
        rowKey="loanId"
        loading={loading}
        dataSource={loans}
        pagination={false}
        columns={[
          { title: '贷款号', dataIndex: 'loanId', width: 90 },
          { title: '客户', dataIndex: 'clientName' },
          { title: '产品', dataIndex: 'productName' },
          {
            title: '本金',
            dataIndex: 'principal',
            align: 'right',
            render: (v: number) => formatMoney(v),
          },
          {
            title: '利率',
            dataIndex: 'interestRate',
            width: 80,
            render: (v: number) => `${v.toFixed(1)}%`,
          },
          { title: '期限(月)', dataIndex: 'termMonths', width: 90 },
          {
            title: '状态',
            key: 'status',
            width: 240,
            render: (_, record) => (
              <Space size={4} wrap>
                <Tag color={record.inArrears ? 'warning' : 'success'}>{record.status}</Tag>
                {record.inArrears && (
                  <Tooltip title={`逾期起算 ${record.overdueSinceDate} / 逾期总额 ${formatMoney(record.totalOverdue)}`}>
                    <Tag color="error">
                      逾期 {record.overdueDays} 天（{record.delinquencyClassification ?? '—'}）
                    </Tag>
                  </Tooltip>
                )}
              </Space>
            ),
          },
          {
            title: '操作',
            key: 'action',
            width: 200,
            render: () => (
              <Space size={8}>
                <Tooltip title="只读预埋位——P2.5 接入后启用">
                  <Button size="small" disabled>
                    审批
                  </Button>
                </Tooltip>
                <Tooltip title="只读预埋位——P2.5 接入后启用">
                  <Button size="small" disabled>
                    放款
                  </Button>
                </Tooltip>
              </Space>
            ),
          },
        ]}
      />
      <Typography.Text type="secondary" style={{ fontSize: 12 }}>
        数据口径：P0.3 种子快照（客户 C 贷款 6——业务日期 2027-03-29 下逾期 40 天，分档 ABNK_POC_OD）
      </Typography.Text>
    </Space>
  );
}
