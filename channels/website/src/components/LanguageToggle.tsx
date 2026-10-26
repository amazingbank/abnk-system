import { Languages } from 'lucide-react';
import { useCommon, useLocale } from '@/i18n';
import type { Locale } from '@/i18n/resources';

/**
 * 方形语言切换按钮（样式与头部图标按钮一致，参照 asdm-ai-2026 的 LanguageToggle）。
 * 切换在客户端完成：交换 URL 语言前缀并就地重渲染，不刷新页面、不丢失滚动位置。
 */
export function LanguageToggle({ className = '' }: { className?: string }) {
  const { locale, toggleLocale } = useLocale();
  const common = useCommon();

  const target: Locale = locale === 'en-us' ? 'zh-cn' : 'en-us';
  const label = common.language.switchTo[target];

  return (
    <button
      type="button"
      onClick={toggleLocale}
      className={`flex h-10 w-10 items-center justify-center border border-copper/40 text-warmwhite transition-colors duration-300 hover:border-amber hover:text-amber ${className}`}
      aria-label={label}
      title={label}
    >
      <Languages className="h-4 w-4" strokeWidth={1.25} />
    </button>
  );
}
