import { Button, Card, Form, Input, App as AntApp, Typography } from 'antd';
import { LockOutlined, UserOutlined } from '@ant-design/icons';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '@/auth/AuthContext';

interface LoginFormValues {
  username: string;
  password: string;
}

export default function LoginPage() {
  const navigate = useNavigate();
  const { login } = useAuth();
  const { message } = AntApp.useApp();

  const onFinish = async (values: LoginFormValues) => {
    try {
      const session = await login(values.username, values.password);
      message.success(`欢迎，${session.displayName}`);
      navigate('/clients', { replace: true });
    } catch (err) {
      message.error(err instanceof Error ? err.message : '登录失败');
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
            Backoffice 运营后台
          </Typography.Title>
        </div>
        <Form<LoginFormValues> layout="vertical" onFinish={(values) => void onFinish(values)}>
          <Form.Item
            name="username"
            label="用户名"
            rules={[{ required: true, message: '请输入用户名' }]}
          >
            <Input prefix={<UserOutlined />} placeholder="运营账号" autoComplete="username" />
          </Form.Item>
          <Form.Item
            name="password"
            label="口令"
            rules={[{ required: true, message: '请输入口令' }]}
          >
            <Input.Password
              prefix={<LockOutlined />}
              placeholder="口令"
              autoComplete="current-password"
            />
          </Form.Item>
          <Form.Item style={{ marginBottom: 8 }}>
            <Button type="primary" htmlType="submit" block>
              登录
            </Button>
          </Form.Item>
        </Form>
        <Typography.Text type="secondary" style={{ fontSize: 12 }}>
          mock 演示口令：admin / password（原型专用明文，生产走 PBKDF2 凭据）
        </Typography.Text>
      </Card>
    </div>
  );
}
