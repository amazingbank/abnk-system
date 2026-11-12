import { Empty, Table } from 'antd';
import type { FixedDepositSummary } from '@/api';
import { formatMoney } from '@/utils/format';
import { useClients } from '@/i18n';

/** 定期账户表（客户详情页） */
export default function FixedDepositTable({ accounts }: { accounts: FixedDepositSummary[] }) {
  const t = useClients();

  if (accounts.length === 0) {
    return <Empty image={Empty.PRESENTED_IMAGE_SIMPLE} description={t.account.noFixed} />;
  }
  return (
    <Table<FixedDepositSummary>
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
          title: t.account.columns.interestRate,
          dataIndex: 'interestRate',
          width: 90,
          render: (v: number) => `${v.toFixed(1)}%`,
        },
        {
          title: t.account.columns.maturityDate,
          dataIndex: 'maturityDate',
          width: 110,
        },
      ]}
    />
  );
}
