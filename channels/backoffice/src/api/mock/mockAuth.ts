/**
 * AuthRepository 的 mock 实现（任务 P1.4）——演示凭据来自
 * `mockData/operators.json`（admin/password，原型专用明文）。
 */

import type { AuthRepository, AuthSession } from '../repositories/authRepository';
import rawOperators from './mockData/operators.json';
import { delay } from './mockStore';

interface OperatorsFile {
  _source: string;
  operators: Array<{ username: string; password: string; displayName: string; role: string }>;
}

const operatorsFile = rawOperators as unknown as OperatorsFile;

export const mockAuthRepository: AuthRepository = {
  async login(username: string, password: string): Promise<AuthSession> {
    await delay(300);
    const operator = operatorsFile.operators.find(
      (o) => o.username === username && o.password === password,
    );
    if (!operator) {
      throw new Error('用户名或口令错误');
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
