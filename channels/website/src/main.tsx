import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import App from './App.tsx';
import { LocaleProvider } from '@/i18n/locale-provider';
import { resolveBrowserLocale } from '@/i18n/locale';
import { parseLocaleFromPathname } from '@/i18n/locale-url';

// 自托管可变字体（与 asdm-ai-2026 同一字体方案，@fontsource-variable 打包进产物，无外部 CDN）。
import '@fontsource-variable/oxanium';
import '@fontsource-variable/jetbrains-mono';
import '@fontsource-variable/noto-sans-sc';
import '@fontsource-variable/noto-serif-sc';
import './index.css';

const locale = parseLocaleFromPathname(window.location.pathname);

if (locale === null) {
  // 无语言前缀的 URL（遗留路径、非法前缀）重置为浏览器检测语言的首页：
  // 全页 replace、reset 语义（有意丢弃 path/query/hash），与 asdm-ai-2026 一致。
  window.location.replace(`/${resolveBrowserLocale()}/`);
} else {
  // 规范化语言根路径的尾斜杠（"/en-us" → "/en-us/"），保持单一规范形态。
  if (window.location.pathname === `/${locale}`) {
    window.history.replaceState(null, '', `/${locale}/${window.location.search}${window.location.hash}`);
  }

  createRoot(document.getElementById('root')!).render(
    <StrictMode>
      <LocaleProvider>
        <App />
      </LocaleProvider>
    </StrictMode>
  );
}
