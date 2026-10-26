/**
 * 将模板字符串中的 `{param}` 占位符替换为给定参数。
 *
 * 示例：interpolate('阶段 {no}', { no: '01' }) → '阶段 01'
 * 未知占位符原样保留，多余参数被忽略。（与 asdm-ai-2026 一致）
 */
export function interpolate(
  template: string,
  params: Record<string, string | number>,
): string {
  return template.replace(/\{(\w+)\}/g, (match, key: string) =>
    Object.prototype.hasOwnProperty.call(params, key) ? String(params[key]) : match,
  );
}
