import { Empty, Table, Tag } from 'antd';
import type { SavingsAccountSummary } from '@/api';
import { formatMoney } from '@/utils/format';

/** 活期账户表（客户详情页） */
export default function SavingsTable({ accounts }: { accounts: SavingsAccountSummary[] }) {
  if (accounts.length === 0) {
    return <Empty image={Empty.PRESENTED_IMAGE_SIMPLE} description="无活期账户" />;
  }
  return (
    <Table<SavingsAccountSummary>
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
        { title: '状态', dataIndex: 'status', width: 90, render: (s: string) => <Tag>{s}</Tag> },
      ]}
    />
  );
}
