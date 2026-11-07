import '../models/user.dart';

/// 认证接口——简化登录（用户名 + 密码 → 会话）。
///
/// 方法签名即 P1.5 契约草签（`POST /login`）；实现可以是 mock（本任务）
/// 或网关 client（P3.1 替换），页面层不感知。
abstract interface class AuthRepository {
  /// 校验凭据并建立会话；失败抛 [Exception]（AuthException 语义）。
  Future<Session> login(String username, String password);

  /// 结束会话。
  Future<void> logout();
}
