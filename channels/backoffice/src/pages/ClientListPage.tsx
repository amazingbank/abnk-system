import { useCallback, useEffect, useState } from 'react';
import { Button, Input, Space, Table, Typography } from 'antd';
import { SearchOutlined } from '@ant-design/icons';
import { useNavigate } from 'react-router-dom';
import { clientRepository } from '@/api';
import type { ClientListResult, ClientSummary, IdentifierStatus } from '@/api';
import IdentifierStatusTag from '@/components/IdentifierStatusTag';
import { formatMoney } from '@/utils/format';
import { interpolate, useClients } from '@/i18n';

export default function ClientListPage() {
  const navigate = useNavigate();
  const t = useClients();
  const [data, setData] = useState<ClientListResult>({ total: 0, items: [] });
  const [loading, setLoading] = useState(true);

  const load = useCallback(async (keyword: string) => {
    setLoading(true);
    try {
      setData(await clientRepository.listClients({ search: keyword || undefined }));
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    void load('');
  }, [load]);

  return (
    <Space direction="vertical" size={16} style={{ width: '100%' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <Typography.Title level={4} style={{ margin: 0 }}>
          {t.list.title}
        </Typography.Title>
        <Input.Search
          allowClear
          placeholder={t.list.searchPlaceholder}
          style={{ width: 300 }}
          prefix={<SearchOutlined />}
          onSearch={(value) => void load(value)}
        />
      </div>
      <Table<ClientSummary>
        rowKey="clientId"
        loading={loading}
        dataSource={data.items}
        pagination={{
          total: data.total,
          pageSize: 10,
          showTotal: (total) => interpolate(t.list.paginationTotal, { total }),
        }}
        onRow={(record) => ({
          onClick: () => navigate(`/clients/${record.clientId}`),
          style: { cursor: 'pointer' },
        })}
        columns={[
          { title: t.list.columns.clientId, dataIndex: 'clientId', width: 90 },
          { title: t.list.columns.name, dataIndex: 'displayName' },
          { title: t.list.columns.externalId, dataIndex: 'externalId' },
          { title: t.list.columns.mobileNo, dataIndex: 'mobileNo', width: 130 },
          {
            title: t.list.columns.identifierStatus,
            dataIndex: 'identifierStatus',
            width: 110,
            render: (status: IdentifierStatus | null) => <IdentifierStatusTag status={status} />,
          },
          {
            title: t.list.columns.identifierExpiryDate,
            dataIndex: 'identifierExpiryDate',
            width: 120,
          },
          {
            title: t.list.columns.action,
            key: 'action',
            width: 80,
            render: (_, record) => (
              <Button
                type="link"
                size="small"
                onClick={(e) => {
                  e.stopPropagation();
                  navigate(`/clients/${record.clientId}`);
                }}
              >
                {t.list.detailAction}
              </Button>
            ),
          },
        ]}
      />
      <Typography.Text type="secondary" style={{ fontSize: 12 }}>
        {interpolate(t.list.dataNote, { money: formatMoney(10000) })}
      </Typography.Text>
    </Space>
  );
}
