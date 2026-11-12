import { Layout, Menu, Dropdown, Button } from 'antd';
import {
  TeamOutlined,
  AccountBookOutlined,
  UserOutlined,
  LogoutOutlined,
} from '@ant-design/icons';
import { Outlet, useLocation, useNavigate } from 'react-router-dom';
import { useAuth } from '@/auth/AuthContext';
import { useCommon } from '@/i18n';
import LanguageToggle from '@/components/LanguageToggle';

const { Header, Sider, Content } = Layout;

// 侧栏菜单项（key 即路由，label 读 common 词条随语言切换）。
// Sidebar menu items (the key is the route; labels come from the common
// dictionary and follow the locale).
function useMenuItems() {
  const common = useCommon();
  return [
    { key: '/clients', icon: <TeamOutlined />, label: common.nav.menu.clients },
    { key: '/loan-ops', icon: <AccountBookOutlined />, label: common.nav.menu.loanOps },
  ];
}

export default function BoLayout() {
  const navigate = useNavigate();
  const location = useLocation();
  const { session, logout } = useAuth();
  const common = useCommon();
  const menuItems = useMenuItems();

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
            {common.header.title}
          </span>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
          <LanguageToggle />
          <Dropdown
            menu={{
              items: [
                {
                  key: 'logout',
                  icon: <LogoutOutlined />,
                  label: common.user.logout,
                  onClick: () => void logout(),
                },
              ],
            }}
          >
            <Button icon={<UserOutlined />}>
              <span style={{ marginLeft: 4 }}>{session?.displayName ?? common.user.anonymous}</span>
            </Button>
          </Dropdown>
        </div>
      </Header>
      <Layout>
        <Sider width={200}>
          <Menu
            mode="inline"
            selectedKeys={[selectedKey]}
            items={menuItems}
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
