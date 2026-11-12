import { Layout, Menu, Dropdown, Button } from 'antd';
import {
  TeamOutlined,
  AccountBookOutlined,
  UserOutlined,
  LogoutOutlined,
} from '@ant-design/icons';
import { Outlet, useLocation, useNavigate } from 'react-router-dom';
import { useAuth } from '@/auth/AuthContext';
import { dataEpoch } from '@/api/mock/mockStore';
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
          {/* 数据纪元 remount（D3 修订，Part03 Phase 7）：key = mockStore.dataEpoch
              ——用户切换语言（= reseedDataSet 切数据集）时页面子树重建、数据
              重新拉取（页面 useEffect 仅 mount 取数，不感知 locale）。本组件
              消费 useCommon 随 context 重渲染，live binding 读到的 epoch 即最新。
              EN: data-epoch remount (D3 revision, Part03 Phase 7): the key is
              mockStore.dataEpoch — a language switch (= a reseedDataSet data-set
              swap) remounts the page subtree so the data refetches (page effects
              fetch on mount only, unaware of the locale). This component consumes
              useCommon and re-renders with the context, so the live binding reads
              the latest epoch. */}
          <Outlet key={dataEpoch} />
        </Content>
      </Layout>
    </Layout>
  );
}
