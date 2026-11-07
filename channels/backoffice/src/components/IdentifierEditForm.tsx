import { useEffect, useState } from 'react';
import { App as AntApp, Button, DatePicker, Form, Input, Space } from 'antd';
import dayjs from 'dayjs';
import { clientRepository } from '@/api';
import type { ClientDetail, IdentifierUpdatePayload } from '@/api';

interface IdentifierFormValues {
  expiryDate: dayjs.Dayjs;
  documentKey?: string;
  description?: string;
}

/**
 * 证照编辑表单（任务 P1.4）——expiry_date 录入 + mock 提交回显：
 * 提交走 clientRepository.updateClientIdentifier，成功后 onSaved 回调
 * 触发页面重读详情（回显新值）。
 */
export default function IdentifierEditForm({
  detail,
  onSaved,
}: {
  detail: ClientDetail;
  onSaved: () => Promise<void>;
}) {
  const { message } = AntApp.useApp();
  const [submitting, setSubmitting] = useState(false);
  const [form] = Form.useForm<IdentifierFormValues>();

  useEffect(() => {
    if (detail.identifier) {
      form.setFieldsValue({
        expiryDate: dayjs(detail.identifier.expiryDate),
        documentKey: detail.identifier.documentKey,
        description: detail.identifier.description,
      });
    }
  }, [detail, form]);

  const onFinish = async (values: IdentifierFormValues) => {
    if (!detail.identifier) return;
    const payload: IdentifierUpdatePayload = {
      expiryDate: values.expiryDate.format('YYYY-MM-DD'),
      documentKey: values.documentKey,
      description: values.description,
    };
    setSubmitting(true);
    try {
      const updated = await clientRepository.updateClientIdentifier(
        detail.clientId,
        detail.identifier.identifierId,
        payload,
      );
      message.success(`证照已更新（到期日 ${updated.expiryDate}）`);
      await onSaved();
    } catch (err) {
      message.error(err instanceof Error ? err.message : '证照更新失败');
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <Form form={form} layout="vertical" onFinish={(values) => void onFinish(values)}>
      <Space size={12} wrap align="start">
        <Form.Item
          name="expiryDate"
          label="到期日"
          rules={[{ required: true, message: '请选择到期日' }]}
          style={{ marginBottom: 0 }}
        >
          <DatePicker />
        </Form.Item>
        <Form.Item name="documentKey" label="证件号（可选）" style={{ marginBottom: 0 }}>
          <Input placeholder="变更时填写" style={{ width: 200 }} />
        </Form.Item>
        <Form.Item name="description" label="说明（可选）" style={{ marginBottom: 0 }}>
          <Input placeholder="说明" style={{ width: 220 }} />
        </Form.Item>
        <Form.Item style={{ marginBottom: 0 }}>
          <Button type="primary" htmlType="submit" loading={submitting}>
            保存证照变更
          </Button>
        </Form.Item>
      </Space>
    </Form>
  );
}
