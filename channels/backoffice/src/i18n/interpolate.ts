// 将模板字符串中的 `{param}` 占位符替换为给定参数（与 abnk-website 同构实现）。
// Replaces `{param}` placeholders in a template string with the given params
// (isomorphic implementation with abnk-website).
//
// 示例 / Example: interpolate('共 {total} 名客户', { total: 3 }) → '共 3 名客户'
// 未知占位符原样保留，多余参数被忽略。
// Unknown placeholders are kept as-is; extra params are ignored.
export function interpolate(
  template: string,
  params: Record<string, string | number>,
): string {
  return template.replace(/\{(\w+)\}/g, (match, key: string) =>
    Object.prototype.hasOwnProperty.call(params, key) ? String(params[key]) : match,
  );
}
