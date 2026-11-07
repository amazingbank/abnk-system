import '../models/identity.dart';

/// 证照（身份标识）查询接口——只读。
///
/// 方法签名即 P1.5 契约草签（`GET /me/identity`）。
abstract interface class IdentityRepository {
  /// 查询当前客户的证照信息（状态 + 有效期，只读口径）。
  Future<IdentityInfo> getIdentity(String username);
}
