/**
 * api 错误翻译 helper（Part03 Phase 2 任务 2.1）——把 api 层抛出的错误
 * 渲染为当前语言的用户可读文案：
 * - ApiError → 按当前语言查 errors 命名空间词条，经 interpolate(params)
 *   插值（如 client.notFound 的 {clientId}）；
 * - 普通 Error → err.message 原样透传（网关 serverMessage 是服务端数据，
 *   属 D3 数据边界，不翻译）；
 * - 非 Error 抛出物 → fallbackCode 对应词条兜底。
 * Translation helper for api errors (Part03 Phase 2 task 2.1) — renders
 * errors thrown by the api layer as user-readable text in the current locale:
 * - ApiError → looked up in the "errors" namespace for the current language,
 *   then interpolate(params) (e.g. {clientId} of client.notFound);
 * - plain Error → err.message passed through verbatim (the gateway
 *   serverMessage is server-side data, a D3 data boundary, never translated);
 * - non-Error throwables → the fallbackCode entry as a last resort.
 */
import { ApiError } from '../api/errors';
import { interpolate } from './interpolate';
import { getCurrentLocale } from './locale';
import { RESOURCES } from './resources';

export function apiErrorMessage(err: unknown, fallbackCode: string): string {
  const errors = RESOURCES[getCurrentLocale()].errors as Record<string, string>;
  if (err instanceof ApiError) {
    const template = errors[err.code];
    return template ? interpolate(template, err.params ?? {}) : err.code;
  }
  if (err instanceof Error) {
    return err.message;
  }
  return errors[fallbackCode] ?? fallbackCode;
}
