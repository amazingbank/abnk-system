import { Empty, Table } from 'antd';
import type { FixedDepositSummary } from '@/api';
import { formatMoney } from '@/utils/format';

/** 定期账户表（客户详情页） */
export default function FixedDepositTable({ accounts }: { accounts: FixedDepositSummary[] }) {
  if (accounts.length === 0) {
    return <Empty image={Empty.PRESENTED_IMAGE_SIMPLE} description="无定期账户" />;
  }
  return (
    <Table<FixedDepositSummary>
      rowKey="id"
      size="small"
      pagination={false}
      dataSource={accounts}
      columns={[
        { title: '账号', dataIndex: 'accountNo' },
        { title: '产品', dataIndex: 'productName' },
        {
          title: '余额',
          dataIndex: 'accountBalance',
          align: 'right',
          render: (v: number) => formatMoney(v),
        },
        {
          title: '利率',
          dataIndex: 'interestRate',
          width: 90,
          render: (v: number) => `${v.toFixed(1)}%`,
        },
        { title: '到期日', dataIndex: 'maturityDate', width: 110 },
      ]}
    />
  );
}
