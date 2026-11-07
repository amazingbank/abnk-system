/**
 * 认证 Provider（任务 P1.4）——session 持久化到 sessionStorage（刷新不掉线），
 * login/logout 委托 authRepository（P1 = mock）。
 */

import { useCallback, useMemo, useState, type ReactNode } from 'react';
import { authRepository } from '@/api';
import type { AuthSession } from '@/api';
import { AuthContext, type AuthState } from './AuthContext';

const SESSION_KEY = 'abnk-bo-session';

function readSession(): AuthSession | null {
  try {
    const raw = sessionStorage.getItem(SESSION_KEY);
    return raw ? (JSON.parse(raw) as AuthSession) : null;
  } catch {
    return null;
  }
}

export function AuthProvider({ children }: { children: ReactNode }) {
  const [session, setSession] = useState<AuthSession | null>(readSession);

  const login = useCallback(async (username: string, password: string) => {
    const next = await authRepository.login(username, password);
    sessionStorage.setItem(SESSION_KEY, JSON.stringify(next));
    setSession(next);
    return next;
  }, []);

  const logout = useCallback(async () => {
    await authRepository.logout();
    sessionStorage.removeItem(SESSION_KEY);
    setSession(null);
  }, []);

  const value = useMemo<AuthState>(() => ({ session, login, logout }), [session, login, logout]);

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}
