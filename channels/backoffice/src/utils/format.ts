import { getCurrentLocale, type Locale } from '@/i18n';

// Intl 数字格式 locale 映射（决策 D8：代码层小写 zh-cn/en-us → BCP 47 大写）。
// Locale mapping for Intl number formatting (decision D8: the lowercase
// zh-cn/en-us codes at the code level map to BCP 47 casing).
const INTL_LOCALES: Record<Locale, string> = {
  'zh-cn': 'zh-CN',
  'en-us': 'en-US',
};

// 金额展示格式（CNY 前缀 + 千分位 + 两位小数）——数字分组格式随当前语言。
// 调用点零改动：locale 由 i18n 当前语言快照（getCurrentLocale）驱动。
// Money display format (CNY prefix + thousands separators + two decimals),
// with digit grouping following the current locale. Call sites stay
// untouched: the locale is driven by the i18n snapshot (getCurrentLocale).
export function formatMoney(amount: number, currency = 'CNY'): string {
  const symbol = currency === 'CNY' ? '¥' : `${currency} `;
  return `${symbol}${amount.toLocaleString(INTL_LOCALES[getCurrentLocale()], {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  })}`;
}
