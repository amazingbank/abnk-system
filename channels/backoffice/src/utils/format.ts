/** 金额展示格式（CNY 前缀 + 千分位 + 两位小数） */
export function formatMoney(amount: number, currency = 'CNY'): string {
  const symbol = currency === 'CNY' ? '¥' : `${currency} `;
  return `${symbol}${amount.toLocaleString('zh-CN', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  })}`;
}
