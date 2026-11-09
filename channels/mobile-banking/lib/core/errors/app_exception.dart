/// ABNK 通用错误处理框架（Sprint v0.0.1 Part02 任务 P1.3）。
///
/// 语义分发框架预留 403 分支：证照过期拦截（POC 演示增量，不在基线范围）落地时，
/// 网关返回的 403 将映射为 [ForbiddenException]，由 [AppExceptionPresenter]
/// 统一转为用户可读提示；基线阶段该分支无业务调用方，框架就绪即可。
sealed class AppException implements Exception {
  const AppException(this.message);

  /// 面向用户的可读提示（中文）。
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// 网络层异常（连接失败 / 超时）。
final class NetworkException extends AppException {
  const NetworkException([super.message = '网络连接异常，请稍后重试']);
}

/// 凭据校验失败（登录）。
final class AuthException extends AppException {
  const AuthException([super.message = '用户名或密码错误']);
}

/// 输入校验失败（表单层先行校验后的补充口径）。
final class ValidationException extends AppException {
  const ValidationException(super.message);
}

/// 403 语义——预留分支（基线无业务调用方；POC 增量承接证照拦截）。
final class ForbiddenException extends AppException {
  const ForbiddenException([super.message = '无权限执行该操作']);
}

/// 服务端异常（5xx / 非预期状态码）——remote 数据层（P3.1）映射引入。
final class ServerException extends AppException {
  const ServerException([super.message = '服务异常，请稍后重试']);
}

/// 异常 → 用户提示的分发器（UI 层消费异常的唯一入口）。
///
/// 新增错误语义时在此登记分支，页面层不感知具体异常类型。
abstract final class AppExceptionPresenter {
  static String present(Object error) {
    return switch (error) {
      ForbiddenException() => '交易被拒绝：${error.message}',
      AppException e => e.message,
      _ => '操作失败，请稍后重试',
    };
  }
}
