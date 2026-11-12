import { Empty, Table, Tag } from 'antd';
import type { SavingsAccountSummary } from '@/api';
import { formatMoney } from '@/utils/format';
import { useClients } from '@/i18n';

/** 活期账户表（客户详情页） */
export default function SavingsTable({ accounts }: { accounts: SavingsAccountSummary[] }) {
  const t = useClients();

  if (accounts.length === 0) {
    return <Empty image={Empty.PRESENTED_IMAGE_SIMPLE} description={t.account.noSavings} />;
  }
  return (
    <Table<SavingsAccountSummary>
      rowKey="id"
      size="small"
      pagination={false}
      dataSource={accounts}
      columns={[
        { title: t.account.columns.accountNo, dataIndex: 'accountNo' },
        { title: t.account.columns.product, dataIndex: 'productName' },
        {
          title: t.account.columns.balance,
          dataIndex: 'accountBalance',
          align: 'right',
          render: (v: number) => formatMoney(v),
        },
        {
          title: t.account.columns.status,
          dataIndex: 'status',
          width: 90,
          render: (s: string) => <Tag>{s}</Tag>,
        },
      ]}
    />
  );
}
