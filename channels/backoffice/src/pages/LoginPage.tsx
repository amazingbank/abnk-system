import { Button, Card, Form, Input, App as AntApp, Typography } from 'antd';
import { LockOutlined, UserOutlined } from '@ant-design/icons';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '@/auth/AuthContext';
import { apiErrorMessage, interpolate, useLogin } from '@/i18n';

interface LoginFormValues {
  username: string;
  password: string;
}

export default function LoginPage() {
  const navigate = useNavigate();
  const { login } = useAuth();
  const { message } = AntApp.useApp();
  const t = useLogin();

  const onFinish = async (values: LoginFormValues) => {
    try {
      const session = await login(values.username, values.password);
      message.success(interpolate(t.welcome, { name: session.displayName }));
      navigate('/clients', { replace: true });
    } catch (err) {
      // 错误码翻译收口：ApiError 按语言查词条，普通 Error 透传 message
      // Error-code translation funnel: ApiError resolves per locale; plain
      // Error messages pass through.
      message.error(apiErrorMessage(err, 'loginFailed'));
    }
  };

  return (
    <div
      style={{
        minHeight: '100vh',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        background: 'var(--abnk-color-bg)',
      }}
    >
      <Card style={{ width: 400, boxShadow: '0 2px 16px rgba(38, 32, 26, 0.08)' }}>
        <div style={{ marginBottom: 28, textAlign: 'center' }}>
          <Typography.Paragraph
            style={{
              fontFamily: 'var(--abnk-font-mono)',
              letterSpacing: 'var(--abnk-eyebrow-spacing)',
              textTransform: 'uppercase',
              fontSize: 11,
              color: 'var(--abnk-color-primary)',
              margin: 0,
            }}
          >
            Amazing Bank
          </Typography.Paragraph>
          <Typography.Title
            level={3}
            style={{
              fontFamily: 'var(--abnk-font-serif)',
              margin: '8px 0 0',
            }}
          >
            {t.title}
          </Typography.Title>
        </div>
        <Form<LoginFormValues> layout="vertical" onFinish={(values) => void onFinish(values)}>
          <Form.Item
            name="username"
            label={t.username.label}
            rules={[{ required: true, message: t.username.required }]}
          >
            <Input
              prefix={<UserOutlined />}
              placeholder={t.username.placeholder}
              autoComplete="username"
            />
          </Form.Item>
          <Form.Item
            name="password"
            label={t.password.label}
            rules={[{ required: true, message: t.password.required }]}
          >
            <Input.Password
              prefix={<LockOutlined />}
              placeholder={t.password.placeholder}
              autoComplete="current-password"
            />
          </Form.Item>
          <Form.Item style={{ marginBottom: 8 }}>
            <Button type="primary" htmlType="submit" block>
              {t.submit}
            </Button>
          </Form.Item>
        </Form>
        <Typography.Text type="secondary" style={{ fontSize: 12 }}>
          {t.mockHint}
        </Typography.Text>
      </Card>
    </div>
  );
}
