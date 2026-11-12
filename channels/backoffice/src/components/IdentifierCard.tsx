import { Card, Descriptions, Divider, Empty, Tag, Typography } from 'antd';
import type { ClientDetail } from '@/api';
import IdentifierEditForm from '@/components/IdentifierEditForm';
import IdentifierStatusTag from '@/components/IdentifierStatusTag';
import { useClients } from '@/i18n';

/** 证照信息卡（详情页）——只读展示 + 编辑表单（expiry_date 录入，mock 提交回显） */
export default function IdentifierCard({
  detail,
  onSaved,
}: {
  detail: ClientDetail;
  onSaved: () => Promise<void>;
}) {
  const t = useClients();

  return (
    <Card title={t.identifier.cardTitle} size="small">
      {detail.identifier ? (
        <>
          <Descriptions column={2} size="small">
            <Descriptions.Item label={t.identifier.labels.documentType}>
              {detail.identifier.documentTypeName}
            </Descriptions.Item>
            <Descriptions.Item label={t.identifier.labels.documentKey}>
              {detail.identifier.documentKey}
            </Descriptions.Item>
            <Descriptions.Item label={t.identifier.labels.issuanceDate}>
              {detail.identifier.issuanceDate}
            </Descriptions.Item>
            <Descriptions.Item label={t.identifier.labels.expiryDate}>
              {detail.identifier.expiryDate}
            </Descriptions.Item>
            <Descriptions.Item label={t.identifier.labels.recordStatus}>
              <Tag>{detail.identifier.status}</Tag>
            </Descriptions.Item>
            <Descriptions.Item label={t.identifier.labels.derivedStatus}>
              <IdentifierStatusTag status={detail.identifier.derivedStatus} />
            </Descriptions.Item>
          </Descriptions>
          <Divider style={{ margin: '12px 0' }} />
          <Typography.Paragraph type="secondary" style={{ fontSize: 12 }}>
            {t.identifier.editHint}
          </Typography.Paragraph>
          <IdentifierEditForm detail={detail} onSaved={onSaved} />
        </>
      ) : (
        <Empty image={Empty.PRESENTED_IMAGE_SIMPLE} description={t.identifier.noIdentifier} />
      )}
    </Card>
  );
}
