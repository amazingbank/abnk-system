import { useCallback, useEffect, useState } from 'react';
import {
  App as AntApp,
  Button,
  Card,
  Descriptions,
  Empty,
  Space,
  Spin,
  Tag,
  Typography,
} from 'antd';
import { ArrowLeftOutlined } from '@ant-design/icons';
import { useNavigate, useParams } from 'react-router-dom';
import { clientRepository } from '@/api';
import type { ClientDetail } from '@/api';
import FixedDepositTable from '@/components/FixedDepositTable';
import IdentifierCard from '@/components/IdentifierCard';
import LoanCard from '@/components/LoanCard';
import SavingsTable from '@/components/SavingsTable';

export default function ClientDetailPage() {
  const { clientId } = useParams<{ clientId: string }>();
  const navigate = useNavigate();
  const { message } = AntApp.useApp();
  const [detail, setDetail] = useState<ClientDetail | null>(null);
  const [loading, setLoading] = useState(true);

  const load = useCallback(
    async (id: number) => {
      setLoading(true);
      try {
        setDetail(await clientRepository.getClientDetail(id));
      } catch (err) {
        message.error(err instanceof Error ? err.message : '加载客户详情失败');
      } finally {
        setLoading(false);
      }
    },
    [message],
  );

  useEffect(() => {
    const id = Number(clientId);
    if (Number.isFinite(id)) {
      void load(id);
    }
  }, [clientId, load]);

  if (loading && !detail) {
    return (
      <div style={{ textAlign: 'center', padding: 64 }}>
        <Spin />
      </div>
    );
  }

  if (!detail) {
    return (
      <Empty description={`客户不存在：clientId=${clientId}`} style={{ padding: 64 }}>
        <Button onClick={() => navigate('/clients')}>返回客户列表</Button>
      </Empty>
    );
  }

  return (
    <Space direction="vertical" size={16} style={{ width: '100%' }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
        <Button icon={<ArrowLeftOutlined />} onClick={() => navigate('/clients')}>
          返回
        </Button>
        <Typography.Title level={4} style={{ margin: 0 }}>
          客户详情 · {detail.displayName}
        </Typography.Title>
      </div>

      <Card title="客户信息" size="small">
        <Descriptions column={2} size="small">
          <Descriptions.Item label="客户号">{detail.clientId}</Descriptions.Item>
          <Descriptions.Item label="外部编号">{detail.externalId}</Descriptions.Item>
          <Descriptions.Item label="姓名">
            {detail.lastname} {detail.firstname}
          </Descriptions.Item>
          <Descriptions.Item label="手机号">{detail.mobileNo}</Descriptions.Item>
          <Descriptions.Item label="邮箱">{detail.emailAddress}</Descriptions.Item>
          <Descriptions.Item label="所属机构">{detail.officeName}</Descriptions.Item>
          <Descriptions.Item label="状态">
            <Tag>{detail.status}</Tag>
          </Descriptions.Item>
        </Descriptions>
      </Card>

      <IdentifierCard detail={detail} onSaved={() => load(detail.clientId)} />

      <Card title="账户信息" size="small">
        <Space direction="vertical" size={12} style={{ width: '100%' }}>
          <Typography.Text strong>活期</Typography.Text>
          <SavingsTable accounts={detail.savingsAccounts} />
          <Typography.Text strong>定期</Typography.Text>
          <FixedDepositTable accounts={detail.fixedDepositAccounts} />
        </Space>
      </Card>

      {detail.loan ? (
        <LoanCard loan={detail.loan} />
      ) : (
        <Card title="贷款信息" size="small">
          <Empty image={Empty.PRESENTED_IMAGE_SIMPLE} description="无贷款记录" />
        </Card>
      )}
    </Space>
  );
}
