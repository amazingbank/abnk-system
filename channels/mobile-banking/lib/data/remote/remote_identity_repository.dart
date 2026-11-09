import 'package:dio/dio.dart';
import 'package:openapi/openapi.dart' as gen;

import '../models/identity.dart';
import '../repositories/identity_repository.dart';
import 'generated_client.dart';

/// [IdentityRepository] 的 remote 实现（P3.1）——`GET /me/identity`，
/// 身份由 JWT（token `sub` = clientId）决定，[username] 参数仅为
/// 接口兼容保留（页面层签名不变）。
class RemoteIdentityRepository implements IdentityRepository {
  RemoteIdentityRepository(this._client);

  final GeneratedClient _client;

  @override
  Future<IdentityInfo> getIdentity(String username) async {
    try {
      final response = await _client.me.getMyIdentity();
      final data = response.data!;
      return IdentityInfo(
        documentTypeId: data.documentTypeId,
        documentTypeName: data.documentTypeName,
        documentKey: data.documentKey,
        status: switch (data.status) {
          gen.IdentityInfoStatusEnum.VALID => IdentityStatus.valid,
          gen.IdentityInfoStatusEnum.EXPIRING_SOON => IdentityStatus.expiringSoon,
          _ => IdentityStatus.expired,
        },
        issuanceDate: data.issuanceDate.toString(),
        expiryDate: data.expiryDate.toString(),
      );
    } on DioException catch (error) {
      throw mapApiError(error);
    }
  }
}
