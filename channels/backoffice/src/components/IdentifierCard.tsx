import { Card, Descriptions, Divider, Empty, Tag, Typography } from 'antd';
import type { ClientDetail } from '@/api';
import IdentifierEditForm from '@/components/IdentifierEditForm';
import IdentifierStatusTag from '@/components/IdentifierStatusTag';

/** 证照信息卡（详情页）——只读展示 + 编辑表单（expiry_date 录入，mock 提交回显） */
export default function IdentifierCard({
  detail,
  onSaved,
}: {
  detail: ClientDetail;
  onSaved: () => Promise<void>;
}) {
  return (
    <Card title="证照信息（可编辑）" size="small">
      {detail.identifier ? (
        <>
          <Descriptions column={2} size="small">
            <Descriptions.Item label="证照类型">
              {detail.identifier.documentTypeName}
            </Descriptions.Item>
            <Descriptions.Item label="证件号">
              {detail.identifier.documentKey}
            </Descriptions.Item>
            <Descriptions.Item label="签发日">
              {detail.identifier.issuanceDate}
            </Descriptions.Item>
            <Descriptions.Item label="到期日">
              {detail.identifier.expiryDate}
            </Descriptions.Item>
            <Descriptions.Item label="记录状态">
              <Tag>{detail.identifier.status}</Tag>
            </Descriptions.Item>
            <Descriptions.Item label="到期状态（推导）">
              <IdentifierStatusTag status={detail.identifier.derivedStatus} />
            </Descriptions.Item>
          </Descriptions>
          <Divider style={{ margin: '12px 0' }} />
          <Typography.Paragraph type="secondary" style={{ fontSize: 12 }}>
            证照编辑（mock 提交回显）——到期状态由到期日对业务日期（2027-03-29）推导
          </Typography.Paragraph>
          <IdentifierEditForm detail={detail} onSaved={onSaved} />
        </>
      ) : (
        <Empty image={Empty.PRESENTED_IMAGE_SIMPLE} description="该客户未登记证照" />
      )}
    </Card>
  );
}
