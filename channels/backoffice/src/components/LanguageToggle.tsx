import { Button, Tooltip } from 'antd';
import { TranslationOutlined } from '@ant-design/icons';
import { useCommon, useLocale } from '@/i18n';
import type { Locale } from '@/i18n';

// 头部语言切换按钮（形态对齐 abnk-website 的 LanguageToggle：方形图标按钮，
// aria-label/title 写目标语言名，如「切换到中文」/ "Switch to English"）。
// 切换在客户端完成：写 localStorage + setState 就地重渲染，不刷新页面、不跳路由。
// Header language toggle (shaped after the abnk-website LanguageToggle: a
// square icon button whose aria-label/title names the target language, e.g.
// 「切换到中文」 / "Switch to English"). Switching happens client-side:
// persist to localStorage + re-render in place via setState — no page refresh,
// no route change.
export default function LanguageToggle() {
  const { locale, setLocale } = useLocale();
  const common = useCommon();

  const target: Locale = locale === 'en-us' ? 'zh-cn' : 'en-us';
  const label = common.language.switchTo[target];

  return (
    <Tooltip title={label}>
      <Button
        type="text"
        icon={<TranslationOutlined />}
        aria-label={label}
        onClick={() => setLocale(target)}
      />
    </Tooltip>
  );
}
