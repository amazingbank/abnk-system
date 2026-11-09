/**
 * 生成 client 适配层（任务 P3.2）——P2.6 `src/api/generated` 的唯一消费入口。
 *
 * 职责（对应 mobile P3.1 的 generated_client.dart 口径）：
 * - 持有 `Configuration` 并分发各 API 组（auth / clients / loans）——登录态
 *   token 经 `accessToken` 回调注入 Bearer 头（security scheme `bearerAuth`）；
 * - 基址规范化：remote 模式的基址口径为同源相对路径（dev 走 vite proxy、
 *   生产走同域反代），生成 client 的请求路径已含 `/bo/...` 全部前缀，
 *   basePath 仅承担绝对基址场景（如 http://localhost:8080）的前缀拼接；
 * - JWT 持久化：sessionStorage（与 AuthProvider 的 session 持久化口径一致，
 *   刷新页面不掉线；登出清除）；
 * - `rawGet`：转发面 raw 端点访问（businessdate / clients/{id}/accounts /
 *   fixeddepositaccounts/{id}——不在生成 client 的契约面内，与生成 client
 *   共用同一基址与 token 注入）；
 * - AxiosError → Error 的语义映射（页面层不感知 axios）。
 */

import axios, { AxiosError, type AxiosInstance } from 'axios';
import { AuthApi, ClientsApi, Configuration, LoansApi } from '../generated';

const JWT_KEY = 'abnk-bo-jwt';

function readJwt(): string | null {
  try {
    return sessionStorage.getItem(JWT_KEY);
  } catch {
    return null;
  }
}

/** 登录成功后持久化 JWT（后续请求自动携带 Bearer 头） */
export function setJwt(token: string): void {
  try {
    sessionStorage.setItem(JWT_KEY, token);
  } catch {
    // 持久化失败不阻断登录（降级为内存外的会话态）
  }
}

/** 登出清除 JWT */
export function clearJwt(): void {
  try {
    sessionStorage.removeItem(JWT_KEY);
  } catch {
    // 同上——无操作
  }
}

/** 网关错误体（{"error":..., "message":...}）提取用户可读信息 */
function extractServerMessage(data: unknown): string | null {
  if (data && typeof data === 'object' && 'message' in data) {
    const message = (data as { message?: unknown }).message;
    if (typeof message === 'string' && message !== '') {
      return message;
    }
  }
  return null;
}

/** Axios 异常 → Error 语义分发（remote repository 共用；页面层只看 message） */
export function toApiError(error: unknown): Error {
  if (error instanceof AxiosError) {
    const status = error.response?.status;
    const serverMessage = extractServerMessage(error.response?.data);
    if (!error.response) {
      return new Error('网络连接失败，请稍后重试');
    }
    if (status === 401) {
      return new Error(serverMessage ?? '登录已失效，请重新登录');
    }
    if (status === 403) {
      return new Error(serverMessage ?? '无权限执行该操作');
    }
    if (status === 404) {
      return new Error(serverMessage ?? '请求的资源不存在');
    }
    return new Error(serverMessage ?? `服务异常（${status}），请稍后重试`);
  }
  return error instanceof Error ? error : new Error('未知错误');
}

/** 网关 client 捆绑包（生成 client 三 API 组 + raw 转发访问） */
export interface GatewayClient {
  auth: AuthApi;
  clients: ClientsApi;
  loans: LoansApi;
  rawGet<T>(path: string): Promise<T>;
}

/**
 * 构造网关 client。`apiBase` 已由 dataSource 规范化：
 * `''` = 同源相对路径（dev proxy / 同域反代），绝对 URL = 跨 origin 直连。
 */
export function createGatewayClient(apiBase: string): GatewayClient {
  const configuration = new Configuration({
    basePath: apiBase,
    accessToken: () => readJwt() ?? '',
  });
  const http: AxiosInstance = axios.create({ baseURL: apiBase });

  async function rawGet<T>(path: string): Promise<T> {
    const token = readJwt();
    try {
      const resp = await http.get<T>(path, {
        headers: token ? { Authorization: `Bearer ${token}` } : undefined,
      });
      return resp.data;
    } catch (err) {
      throw toApiError(err);
    }
  }

  return {
    auth: new AuthApi(configuration, apiBase),
    clients: new ClientsApi(configuration, apiBase),
    loans: new LoansApi(configuration, apiBase),
    rawGet,
  };
}
