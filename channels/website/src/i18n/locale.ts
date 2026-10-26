// 语言检测辅助（与 asdm-ai-2026 的 locale-provider 内同名逻辑一致）。
import { DEFAULT_LOCALE, type Locale } from './resources';

/** 浏览器语言列表中任一 zh 开头的 tag 映射到 zh-cn，其余映射到 en-us。 */
const CHINESE_LANGUAGE = /^zh\b/i;

/** 依据浏览器语言偏好检测语言；仅用于无前缀 URL 重定向时决定目标语言，渲染语言始终以 URL 为准。 */
export function resolveBrowserLocale(): Locale {
  if (typeof window === 'undefined') return DEFAULT_LOCALE;

  const candidates = navigator.languages?.length ? navigator.languages : [navigator.language];
  const isChinese = candidates.some((tag) => typeof tag === 'string' && CHINESE_LANGUAGE.test(tag.trim()));

  return isChinese ? 'zh-cn' : DEFAULT_LOCALE;
}

/** 各语言对应的 <html lang> 值（BCP 47 惯用大小写）。 */
export const LOCALE_HTML_LANG: Record<Locale, string> = {
  'en-us': 'en-US',
  'zh-cn': 'zh-CN',
};
