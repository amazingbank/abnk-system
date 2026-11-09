/// 生成 client 适配层（P3.1）——P2.6 `openapi-generated` 的唯一消费入口。
///
/// 职责：
/// - 持有 `Openapi` 实例并按需分发各 API 组（auth/me/accounts/loans）；
/// - 注入基址规范化：`--dart-define=ABNK_API_BASE` 的计划口径值带
///   `/abnk/api/v1` 尾缀，而生成 client 的请求路径已含全部前缀
///   （dio 为 baseUrl+path 字符串拼接），故仅保留 origin 避免重复前缀；
/// - 登录态 token 注入：登录成功后写入 Bearer 拦截器（scheme 名
///   `bearerAuth`），登出清除；
/// - DioException → AppException 的语义映射（页面层不感知 Dio）。
library;

import 'package:dio/dio.dart';
import 'package:openapi/openapi.dart' as gen;

import '../../core/errors/app_exception.dart';

class GeneratedClient {
  GeneratedClient({required String baseUrl})
      : _openapi = gen.Openapi(basePathOverride: _normalizeBaseUrl(baseUrl));

  final gen.Openapi _openapi;

  /// 规范化注入基址为 origin（scheme://host:port）。
  ///
  /// 生成 client 的路径模板（如 `/abnk/api/v1/me`、`/login`）已携带
  /// 全部路由前缀，dio 的 url 组合是 `baseUrl + path` 字符串拼接，
  /// 因此注入值携带的尾缀路径必须剥除，否则拼出重复前缀。
  static String _normalizeBaseUrl(String base) {
    final uri = Uri.parse(base);
    if (!uri.hasScheme || uri.host.isEmpty) {
      throw ArgumentError('ABNK_API_BASE 必须是绝对 URL，实际值：$base');
    }
    // 用 origin 构造（勿用 replace(path: '')——空 query/fragment 会序列化
    // 出 `?#` 尾巴，与请求 path 拼接后路由前缀会被吞进 fragment）。
    return Uri(scheme: uri.scheme, host: uri.host, port: uri.port).toString();
  }

  gen.AuthApi get auth => _openapi.getAuthApi();
  gen.MeApi get me => _openapi.getMeApi();
  gen.AccountsApi get accounts => _openapi.getAccountsApi();
  gen.LoansApi get loans => _openapi.getLoansApi();

  /// 登录成功后注入 JWT（Bearer 拦截器按 scheme 名 `bearerAuth` 匹配）。
  void setToken(String token) => _openapi.setBearerAuth('bearerAuth', token);

  /// 登出清除 JWT（后续请求不再携带 Authorization 头）。
  void clearToken() => _openapi.removeBearerAuth('bearerAuth');
}

/// Dio 异常 → [AppException] 的语义分发（remote repository 共用）。
///
/// 页面层只消费 [AppException] 体系（AppExceptionPresenter），与 mock
/// 实现抛出的异常类型完全一致——接线后页面零改动的保障之一。
AppException mapApiError(Object error) {
  if (error is! DioException) {
    return const NetworkException();
  }
  final response = error.response;
  if (response == null) {
    // 无响应体：连接失败 / 超时 / 请求被取消。
    return const NetworkException();
  }
  final serverMessage = _serverMessage(response.data);
  return switch (response.statusCode) {
    401 => AuthException(serverMessage ?? '登录已失效，请重新登录'),
    403 => ForbiddenException(serverMessage ?? '无权限执行该操作'),
    400 || 422 => ValidationException(serverMessage ?? '请求参数不正确'),
    _ => ServerException(
        serverMessage ?? '服务异常（${response.statusCode}），请稍后重试'),
  };
}

/// 尝试从网关 ErrorResponse（status/error/message）提取用户可读信息。
String? _serverMessage(Object? data) {
  if (data is Map<String, dynamic>) {
    final message = data['message'];
    if (message is String && message.isNotEmpty) {
      return message;
    }
  }
  return null;
}
