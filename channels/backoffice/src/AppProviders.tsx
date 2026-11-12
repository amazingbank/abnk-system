import { useEffect, type ReactNode } from 'react';
import { App as AntApp, ConfigProvider } from 'antd';
import zhCN from 'antd/locale/zh_CN';
import enUS from 'antd/locale/en_US';
import dayjs from 'dayjs';
import 'dayjs/locale/zh-cn';
import 'dayjs/locale/en';
import { abnkTheme } from '@/theme/abnkTheme';
import { useLocale } from '@/i18n';
import { LocaleProvider } from '@/i18n/locale-provider';

// antd locale 映射（决策 D8：代码层小写 zh-cn/en-us → antd 的 zh_CN/en_US）。
// antd locale mapping (decision D8: the lowercase zh-cn/en-us codes at the
// code level map to antd's zh_CN/en_US packs).
const ANTD_LOCALES = { 'zh-cn': zhCN, 'en-us': enUS } as const;

// dayjs locale 映射（dayjs 用小写短名 zh-cn / en）。
// dayjs locale mapping (dayjs uses the lowercase short names zh-cn / en).
const DAYJS_LOCALES = { 'zh-cn': 'zh-cn', 'en-us': 'en' } as const;

// 内层：读当前 locale，联动 antd ConfigProvider locale 与 dayjs 全局 locale
// ——antd 内建文案（空态/分页/弹窗按钮等）与日期文案随语言即时切换。
// Inner layer: reads the current locale and drives both the antd
// ConfigProvider locale and the global dayjs locale, so antd built-in copy
// (empty states, pagination, modal buttons, etc.) and date texts switch with
// the language immediately.
function AntdLocaleGate({ children }: { children: ReactNode }) {
  const { locale } = useLocale();

  // dayjs 全局 locale 随语言同步（无显式 locale 传参的使用点自动跟随）。
  // Keeps the global dayjs locale in sync (usage sites without an explicit
  // locale argument follow automatically).
  useEffect(() => {
    dayjs.locale(DAYJS_LOCALES[locale]);
  }, [locale]);

  return (
    <ConfigProvider theme={abnkTheme} locale={ANTD_LOCALES[locale]}>
      <AntApp>{children}</AntApp>
    </ConfigProvider>
  );
}

// 应用级 Provider 组合（任务 1.5 从 main.tsx 抽出）：LocaleProvider（语言
// 事实来源，D6）在外，antd 主题与 locale 联动在内——antd locale 必须随语言
// 重渲染，故 ConfigProvider 位于 LocaleProvider 内层。
// App-level provider composition (extracted from main.tsx in task 1.5):
// LocaleProvider (the source of truth for locale, D6) wraps the antd
// theme/locale wiring — ConfigProvider sits inside LocaleProvider so the
// antd locale re-renders on language switches.
export default function AppProviders({ children }: { children: ReactNode }) {
  return (
    <LocaleProvider>
      <AntdLocaleGate>{children}</AntdLocaleGate>
    </LocaleProvider>
  );
}
