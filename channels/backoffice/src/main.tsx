import React from 'react';
import ReactDOM from 'react-dom/client';
import '@fontsource-variable/oxanium';
import '@fontsource-variable/noto-sans-sc';
import '@fontsource-variable/noto-serif-sc';
import '@fontsource-variable/jetbrains-mono';
import './styles.css';
import App from './App';
import { applyAbnkCssVariables } from './theme/abnkTheme';
// Provider 组合（antd 主题/locale 联动 + LocaleProvider）在 AppProviders 内，
// 此处不再直接 import antd locale（任务 1.5 抽出，消除写死 zh_CN）。
// The provider composition (antd theme/locale wiring + LocaleProvider) lives
// in AppProviders; no direct antd locale import here anymore (extracted in
// task 1.5, removing the hardcoded zh_CN).
import AppProviders from './AppProviders';

// 设计系统 tokens（P1.2 单一事实源）注入：AntD 主题 + CSS 变量层
applyAbnkCssVariables();

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <AppProviders>
      <App />
    </AppProviders>
  </React.StrictMode>,
);
