import 'package:dio/dio.dart';
import 'package:openapi/openapi.dart' as gen;

import '../models/user.dart';
import '../repositories/auth_repository.dart';
import 'generated_client.dart';

/// [AuthRepository] 的 remote 实现（P3.1）——`POST /login` 经网关
/// PBKDF2 校验签发 JWT，token 回写 [GeneratedClient] 供后续请求注入。
class RemoteAuthRepository implements AuthRepository {
  RemoteAuthRepository(this._client);

  final GeneratedClient _client;

  @override
  Future<Session> login(String username, String password) async {
    try {
      final response = await _client.auth.login(
        loginRequest: gen.LoginRequest((b) => b
          ..username = username
          ..password = password),
      );
      final data = response.data!;
      _client.setToken(data.token);
      return Session(
        username: data.username,
        displayName: data.displayName,
        clientId: data.clientId,
      );
    } on DioException catch (error) {
      throw mapApiError(error);
    }
  }

  @override
  Future<void> logout() async {
    _client.clearToken();
  }
}
