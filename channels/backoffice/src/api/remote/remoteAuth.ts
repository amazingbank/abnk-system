/**
 * AuthRepository 的 remote 实现（任务 P3.2）——`POST /bo/login` 经网关
 * PBKDF2 校验签发 internal JWT，token 回写 [setJwt] 供后续请求 Bearer 注入；
 * 登出清除。错误凭据的 message 口径与 mock 实现（'用户名或口令错误'）对齐。
 */

import { AxiosError } from 'axios';
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
          throw new Error('用户名或口令错误');
        }
        throw toApiError(err);
      }
    },

    async logout(): Promise<void> {
      clearJwt();
    },
  };
}
