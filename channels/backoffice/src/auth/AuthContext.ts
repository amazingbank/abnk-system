/**
 * 认证上下文（任务 P1.4）——context 与 hook 定义（组件在 AuthProvider.tsx，
 * 拆文件以遵守 react-refresh/only-export-components 约束）。
 */

import { createContext, useContext } from 'react';
import type { AuthSession } from '@/api';

export interface AuthState {
  session: AuthSession | null;
  login: (username: string, password: string) => Promise<AuthSession>;
  logout: () => Promise<void>;
}

export const AuthContext = createContext<AuthState | null>(null);

export function useAuth(): AuthState {
  const ctx = useContext(AuthContext);
  if (!ctx) {
    throw new Error('useAuth 必须在 AuthProvider 内使用');
  }
  return ctx;
}
