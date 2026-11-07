import { Layout, Menu, Dropdown, Button } from 'antd';
import {
  TeamOutlined,
  AccountBookOutlined,
  UserOutlined,
  LogoutOutlined,
} from '@ant-design/icons';
import { Outlet, useLocation, useNavigate } from 'react-router-dom';
import { useAuth } from '@/auth/AuthContext';

const { Header, Sider, Content } = Layout;

const MENU_ITEMS = [
  { key: '/clients', icon: <TeamOutlined />, label: '客户列表' },
  { key: '/loan-ops', icon: <AccountBookOutlined />, label: '贷款运营' },
];

export default function BoLayout() {
  const navigate = useNavigate();
  const location = useLocation();
  const { session, logout } = useAuth();

  const selectedKey = location.pathname.startsWith('/loan-ops') ? '/loan-ops' : '/clients';

  return (
    <Layout style={{ minHeight: '100vh' }}>
      <Header
        style={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          borderBottom: '1px solid var(--abnk-color-border)',
          paddingInline: 24,
        }}
      >
        <div style={{ display: 'flex', alignItems: 'baseline', gap: 12 }}>
          <span
            style={{
              fontFamily: 'var(--abnk-font-mono)',
              letterSpacing: 'var(--abnk-eyebrow-spacing)',
              textTransform: 'uppercase',
              fontSize: 11,
              color: 'var(--abnk-color-primary)',
            }}
          >
            Amazing Bank
          </span>
          <span
            style={{
              fontFamily: 'var(--abnk-font-serif)',
              fontWeight: 600,
              fontSize: 17,
              color: 'var(--abnk-color-text)',
            }}
          >
            Backoffice 运营后台
          </span>
        </div>
        <Dropdown
          menu={{
            items: [
              {
                key: 'logout',
                icon: <LogoutOutlined />,
                label: '退出登录',
                onClick: () => void logout(),
              },
            ],
          }}
        >
          <Button icon={<UserOutlined />}>
            <span style={{ marginLeft: 4 }}>{session?.displayName ?? '未登录'}</span>
          </Button>
        </Dropdown>
      </Header>
      <Layout>
        <Sider width={200}>
          <Menu
            mode="inline"
            selectedKeys={[selectedKey]}
            items={MENU_ITEMS}
            onClick={({ key }) => navigate(key)}
            style={{ height: '100%', borderRight: 0, paddingTop: 8 }}
          />
        </Sider>
        <Content style={{ padding: 24, maxWidth: 1180 }}>
          <Outlet />
        </Content>
      </Layout>
    </Layout>
  );
}
