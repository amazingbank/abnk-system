/**
 * AuthRepository 的 mock 实现（任务 P1.4）——演示凭据来自
 * `mockData/{zh-cn,en-us}/operators.json`（admin/password，原型专用明文）。
 * 任务 2.2 起经 mockStore 的 `operatorsFile` 消费（数据集选择收口单一
 * 事实源：构建期变量 VITE_ABNK_DATA_LOCALE 决定双语数据集归属）。
 * Mock AuthRepository implementation (task P1.4) — demo credentials come
 * from `mockData/{zh-cn,en-us}/operators.json` (admin/password,
 * prototype-only plaintext). Since task 2.2 it consumes mockStore's
 * `operatorsFile` (data-set selection funnels into a single source of truth:
 * the build-time variable VITE_ABNK_DATA_LOCALE decides which bilingual
 * data set is in play).
 */

import { ApiError, ERR } from '../errors';
import type { AuthRepository, AuthSession } from '../repositories/authRepository';
import { delay, operatorsFile } from './mockStore';

export const mockAuthRepository: AuthRepository = {
  async login(username: string, password: string): Promise<AuthSession> {
    await delay(300);
    const operator = operatorsFile.operators.find(
      (o) => o.username === username && o.password === password,
    );
    if (!operator) {
      // 错误码化：文案由 UI 层按当前语言查 errors 词条（任务 2.1）。
      // Error-coded: user-facing text is resolved per locale by the UI layer (task 2.1).
      throw new ApiError(ERR.auth.invalidCredentials);
    }
    return {
      username: operator.username,
      displayName: operator.displayName,
      role: operator.role,
    };
  },

  async logout(): Promise<void> {
    await delay(100);
  },
};
