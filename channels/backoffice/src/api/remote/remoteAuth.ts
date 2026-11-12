/**
 * AuthRepository 的 remote 实现（任务 P3.2）——`POST /bo/login` 经网关
 * PBKDF2 校验签发 internal JWT，token 回写 [setJwt] 供后续请求 Bearer 注入；
 * 登出清除。错误凭据口径与 mock 实现对齐——同抛 auth.invalidCredentials
 * 错误码（任务 2.1），文案由 UI 层按语言翻译。
 * Remote AuthRepository implementation (task P3.2) — `POST /bo/login` issues
 * an internal JWT after gateway PBKDF2 verification; the token is stored via
 * [setJwt] for Bearer injection on later requests; logout clears it.
 * Bad-credential handling mirrors the mock implementation — both throw the
 * auth.invalidCredentials error code (task 2.1), translated per locale by
 * the UI layer.
 */

import { AxiosError } from 'axios';
import { ApiError, ERR } from '../errors';
import type { AuthRepository, AuthSession } from '../repositories/authRepository';
import { clearJwt, setJwt, toApiError, type GatewayClient } from './generatedClient';

export function createRemoteAuthRepository(client: GatewayClient): AuthRepository {
  return {
    async login(username: string, password: string): Promise<AuthSession> {
      try {
        const resp = await client.auth.boLogin({ username, password });
        const data = resp.data;
        setJwt(data.token);
        return {
          username: data.username,
          displayName: data.displayName,
          role: data.role,
        };
      } catch (err) {
        if (err instanceof AxiosError && err.response?.status === 401) {
          throw new ApiError(ERR.auth.invalidCredentials);
        }
        throw toApiError(err);
      }
    },

    async logout(): Promise<void> {
      clearJwt();
    },
  };
}
