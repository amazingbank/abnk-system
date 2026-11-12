import { Tag } from 'antd';
import type { IdentifierStatus } from '@/api';
import { useClients } from '@/i18n';

/** 证照到期状态标签（EXPIRED=brick 红 / VALID=sage 绿 / 未登记=中性） */
export default function IdentifierStatusTag({ status }: { status: IdentifierStatus | null }) {
  const t = useClients();

  if (status === null) {
    return <Tag>{t.status.unregistered}</Tag>;
  }
  return status === 'EXPIRED' ? (
    <Tag color="error">{t.status.expired}</Tag>
  ) : (
    <Tag color="success">{t.status.valid}</Tag>
  );
}
