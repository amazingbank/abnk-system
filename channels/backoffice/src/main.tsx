import React from 'react';
import ReactDOM from 'react-dom/client';
import { ConfigProvider, App as AntApp } from 'antd';
import zhCN from 'antd/locale/zh_CN';
import '@fontsource-variable/oxanium';
import '@fontsource-variable/noto-sans-sc';
import '@fontsource-variable/noto-serif-sc';
import '@fontsource-variable/jetbrains-mono';
import './styles.css';
import App from './App';
import { abnkTheme, applyAbnkCssVariables } from './theme/abnkTheme';

// 设计系统 tokens（P1.2 单一事实源）注入：AntD 主题 + CSS 变量层
applyAbnkCssVariables();

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <ConfigProvider theme={abnkTheme} locale={zhCN}>
      <AntApp>
        <App />
      </AntApp>
    </ConfigProvider>
  </React.StrictMode>,
);
