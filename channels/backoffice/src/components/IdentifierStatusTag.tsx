import { Tag } from 'antd';
import type { IdentifierStatus } from '@/api';

/** 证照到期状态标签（EXPIRED=brick 红 / VALID=sage 绿 / 未登记=中性） */
export default function IdentifierStatusTag({ status }: { status: IdentifierStatus | null }) {
  if (status === null) {
    return <Tag>未登记</Tag>;
  }
  return status === 'EXPIRED' ? <Tag color="error">已过期</Tag> : <Tag color="success">有效</Tag>;
}
