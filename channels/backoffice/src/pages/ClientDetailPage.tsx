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
import { interpolate, useClients, useErrors, useLoanOps } from '@/i18n';

export default function ClientDetailPage() {
  const { clientId } = useParams<{ clientId: string }>();
  const navigate = useNavigate();
  const { message } = AntApp.useApp();
  const t = useClients();
  const loanOps = useLoanOps();
  const errors = useErrors();
  const [detail, setDetail] = useState<ClientDetail | null>(null);
  const [loading, setLoading] = useState(true);

  const load = useCallback(
    async (id: number) => {
      setLoading(true);
      try {
        setDetail(await clientRepository.getClientDetail(id));
      } catch (err) {
        message.error(err instanceof Error ? err.message : errors.clientDetailLoadFailed);
      } finally {
        setLoading(false);
      }
    },
    [message, errors.clientDetailLoadFailed],
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
      <Empty
        description={interpolate(t.detail.notFound, { clientId: clientId ?? '' })}
        style={{ padding: 64 }}
      >
        <Button onClick={() => navigate('/clients')}>{t.detail.backToList}</Button>
      </Empty>
    );
  }

  return (
    <Space direction="vertical" size={16} style={{ width: '100%' }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
        <Button icon={<ArrowLeftOutlined />} onClick={() => navigate('/clients')}>
          {t.detail.back}
        </Button>
        <Typography.Title level={4} style={{ margin: 0 }}>
          {interpolate(t.detail.title, { name: detail.displayName })}
        </Typography.Title>
      </div>

      <Card title={t.detail.infoCard} size="small">
        <Descriptions column={2} size="small">
          <Descriptions.Item label={t.detail.labels.clientId}>
            {detail.clientId}
          </Descriptions.Item>
          <Descriptions.Item label={t.detail.labels.externalId}>
            {detail.externalId}
          </Descriptions.Item>
          <Descriptions.Item label={t.detail.labels.name}>
            {detail.lastname} {detail.firstname}
          </Descriptions.Item>
          <Descriptions.Item label={t.detail.labels.mobileNo}>
            {detail.mobileNo}
          </Descriptions.Item>
          <Descriptions.Item label={t.detail.labels.email}>
            {detail.emailAddress}
          </Descriptions.Item>
          <Descriptions.Item label={t.detail.labels.office}>
            {detail.officeName}
          </Descriptions.Item>
          <Descriptions.Item label={t.detail.labels.status}>
            <Tag>{detail.status}</Tag>
          </Descriptions.Item>
        </Descriptions>
      </Card>

      <IdentifierCard detail={detail} onSaved={() => load(detail.clientId)} />

      <Card title={t.detail.accountsCard} size="small">
        <Space direction="vertical" size={12} style={{ width: '100%' }}>
          <Typography.Text strong>{t.detail.savingsSection}</Typography.Text>
          <SavingsTable accounts={detail.savingsAccounts} />
          <Typography.Text strong>{t.detail.fixedSection}</Typography.Text>
          <FixedDepositTable accounts={detail.fixedDepositAccounts} />
        </Space>
      </Card>

      {detail.loan ? (
        <LoanCard loan={detail.loan} />
      ) : (
        <Card title={loanOps.loanCardTitle} size="small">
          <Empty image={Empty.PRESENTED_IMAGE_SIMPLE} description={t.detail.noLoanRecord} />
        </Card>
      )}
    </Space>
  );
}
