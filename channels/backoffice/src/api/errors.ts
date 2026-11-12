/**
 * api 层错误码体系（Part03 Phase 2 任务 2.1）。
 * api 层只抛稳定错误码（ApiError：code + 插值参数），不携带任何语言文案、
 * 与 i18n 零依赖；用户可读文案由 UI 层翻译 helper（i18n/api-error.ts）按
 * 当前语言查 errors 命名空间词条生成。mock/remote 双实现共用同一码表，
 * 行为口径一致且可单测。
 * Error-code system for the api layer (Part03 Phase 2 task 2.1).
 * The api layer throws stable error codes only (ApiError: code plus
 * interpolation params), carries no language-specific copy and keeps zero
 * i18n dependencies; user-readable text is produced by the UI-layer
 * translation helper (i18n/api-error.ts) via the "errors" namespace in the
 * current locale. Mock and remote implementations share one code table, so
 * both behave identically and stay unit-testable.
 */

/**
 * 错误码常量表——键与 errors.json 命名空间词条一一对应（分层纪律：
 * 本表只管码，不管文案）。
 * Error-code constants — each key maps 1:1 to an "errors" namespace entry
 * (layering discipline: this table owns codes only, never copy).
 */
export const ERR = {
  auth: {
    invalidCredentials: 'auth.invalidCredentials',
    sessionExpired: 'auth.sessionExpired',
    forbidden: 'auth.forbidden',
  },
  client: {
    notFound: 'client.notFound',
    identifierNotFound: 'client.identifierNotFound',
  },
  network: {
    offline: 'network.offline',
  },
  resource: {
    notFound: 'resource.notFound',
  },
  server: {
    error: 'server.error',
  },
  unknown: 'unknown',
} as const;

/**
 * 业务异常（错误码 + 插值参数）。message 填 code 仅供调试与日志辨识，
 * 不得直接展示给用户（展示一律走 i18n 翻译 helper）。
 * Business exception carrying an error code plus interpolation params. The
 * message holds the code for debugging and log readability only and must
 * never be shown to users directly (display always goes through the i18n
 * translation helper).
 */
export class ApiError extends Error {
  readonly code: string;
  readonly params?: Record<string, string | number>;

  constructor(code: string, params?: Record<string, string | number>) {
    super(code);
    this.name = 'ApiError';
    this.code = code;
    this.params = params;
  }
}
