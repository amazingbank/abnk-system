/**
 * 认证 repository 接口——契约草签（任务 P1.4）。
 *
 * P1 阶段 mock 实现（演示口令，原型专用明文）；P3.2 接线时替换为生成
 * client（网关内部通道 `POST /bo/login`，凭据走 PBKDF2——
 * `data/gateway_users.json` admin 用户口径，D2 简化登录决策）。
 */

export interface AuthSession {
  username: string;
  displayName: string;
  role: string;
}

export interface AuthRepository {
  /** 运营登录（错误凭据抛异常） */
  login(username: string, password: string): Promise<AuthSession>;
  /** 退出登录 */
  logout(): Promise<void>;
}
