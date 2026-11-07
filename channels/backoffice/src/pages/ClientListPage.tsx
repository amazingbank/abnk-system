import { useCallback, useEffect, useState } from 'react';
import { Button, Input, Space, Table, Typography } from 'antd';
import { SearchOutlined } from '@ant-design/icons';
import { useNavigate } from 'react-router-dom';
import { clientRepository } from '@/api';
import type { ClientListResult, ClientSummary, IdentifierStatus } from '@/api';
import IdentifierStatusTag from '@/components/IdentifierStatusTag';
import { formatMoney } from '@/utils/format';

export default function ClientListPage() {
  const navigate = useNavigate();
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
          客户列表
        </Typography.Title>
        <Input.Search
          allowClear
          placeholder="搜索姓名 / 外部编号 / 手机号"
          style={{ width: 300 }}
          prefix={<SearchOutlined />}
          onSearch={(value) => void load(value)}
        />
      </div>
      <Table<ClientSummary>
        rowKey="clientId"
        loading={loading}
        dataSource={data.items}
        pagination={{ total: data.total, pageSize: 10, showTotal: (t) => `共 ${t} 名客户` }}
        onRow={(record) => ({
          onClick: () => navigate(`/clients/${record.clientId}`),
          style: { cursor: 'pointer' },
        })}
        columns={[
          { title: '客户号', dataIndex: 'clientId', width: 90 },
          { title: '姓名', dataIndex: 'displayName' },
          { title: '外部编号', dataIndex: 'externalId' },
          { title: '手机号', dataIndex: 'mobileNo', width: 130 },
          {
            title: '证照状态',
            dataIndex: 'identifierStatus',
            width: 110,
            render: (status: IdentifierStatus | null) => <IdentifierStatusTag status={status} />,
          },
          { title: '证照到期日', dataIndex: 'identifierExpiryDate', width: 120 },
          {
            title: '操作',
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
                详情
              </Button>
            ),
          },
        ]}
      />
      <Typography.Text type="secondary" style={{ fontSize: 12 }}>
        数据口径：P0.3 种子快照（王/李/赵 POC-A/B/C，业务日期 2027-03-29）；
        证照状态由到期日对业务日期推导（基线只读展示）——金额格式示例 {formatMoney(10000)}
      </Typography.Text>
    </Space>
  );
}
