/// ABNK 通用错误处理框架（Sprint v0.0.1 Part02 任务 P1.3；Part03 任务 3.4 码化）。
///
/// 异常只携带稳定语义码（[ErrCodes]）+ 可选网关 message 透传 + 词条插值参数，
/// 不再内嵌中文文案——UI 层经 [AppExceptionPresenter.present] 按当前语言查
/// `err.*` 词条（与 backoffice Phase 2 的 ApiError 错误码体系同构）。
/// 语义分发框架预留 403 分支：证照过期拦截（POC 演示增量）落地时，网关返回
/// 的 403 将映射为 [ForbiddenException]，由 [AppExceptionPresenter] 统一转
/// 为用户可读提示；基线阶段该分支无业务调用方，框架就绪即可。
///
/// ABNK common error framework (Sprint v0.0.1 Part02 task P1.3; coded in
/// Part03 task 3.4). Exceptions carry only a stable semantic code
/// ([ErrCodes]), an optional gateway message passthrough, and interpolation
/// params — no embedded user-facing text. The UI layer resolves text via
/// [AppExceptionPresenter.present] against the `err.*` entries in the
/// current language (mirroring the backoffice Phase 2 ApiError code system).
/// A 403 branch stays reserved for the identity gate (a POC increment):
/// gateway 403s map to [ForbiddenException] and are presented uniformly;
/// the branch has no business caller in the baseline.
library;

import '../../l10n/app_localizations.dart';

/// 语义码表——异常与词条（`err.*`）之间的稳定契约。
///
/// Stable semantic error codes — the contract between exceptions and the
/// `err.*` ARB entries.
abstract final class ErrCodes {
  static const network = 'err.network';
  static const auth = 'err.auth';
  static const sessionExpired = 'err.sessionExpired';
  static const forbidden = 'err.forbidden';
  static const server = 'err.server';
  static const unknown = 'err.unknown';
  static const validationAccountsMissing = 'err.validation.accountsMissing';
  static const validationAccountNotFound = 'err.validation.accountNotFound';
  static const validationIdentityMissing = 'err.validation.identityMissing';
  static const validationSameAccounts = 'err.validation.sameAccounts';
  static const validationTransferAmountPositive =
      'err.validation.transferAmountPositive';
  static const validationDepositAmountPositive =
      'err.validation.depositAmountPositive';
  static const validationInsufficientBalance =
      'err.validation.insufficientBalance';
  static const validationProductNotFound = 'err.validation.productNotFound';
  static const validationBelowMinDeposit = 'err.validation.belowMinDeposit';
  static const validationBadRequest = 'err.validation.badRequest';
}

sealed class AppException implements Exception {
  const AppException({
    required this.code,
    this.serverMessage,
    this.params = const {},
  });

  /// 稳定语义码（[ErrCodes]）——UI 层按码查词条的唯一依据。
  ///
  /// Stable semantic code ([ErrCodes]) — the sole key the UI layer uses to
  /// look up the localized message.
  final String code;

  /// 网关 ErrorResponse.message 透传（数据边界，D3：服务端数据原样展示不
  /// 翻译）；非空时优先于词条。
  ///
  /// Passthrough of the gateway ErrorResponse.message (data boundary, D3:
  /// server data is shown verbatim, never translated); when non-null it
  /// wins over the localized entry.
  final String? serverMessage;

  /// 词条插值参数（如 `{id}` / `{status}`）。
  ///
  /// Interpolation params for the localized entry (e.g. `{id}`, `{status}`).
  final Map<String, String> params;

  @override
  String toString() =>
      '$runtimeType($code)${serverMessage == null ? '' : ': $serverMessage'}';
}

/// 网络层异常（连接失败 / 超时）。
///
/// Network layer failure (connection error / timeout).
final class NetworkException extends AppException {
  const NetworkException({super.serverMessage})
      : super(code: ErrCodes.network);
}

/// 凭据校验失败（登录）/ 会话失效（remote 401 映射）。
///
/// Credential validation failure (login) / expired session (remote 401).
final class AuthException extends AppException {
  const AuthException({super.code = ErrCodes.auth, super.serverMessage});
}

/// 输入校验失败（表单层先行校验后的补充口径）。
///
/// Input validation failure (a supplement to the form-level checks).
final class ValidationException extends AppException {
  const ValidationException({
    required super.code,
    super.serverMessage,
    super.params,
  });
}

/// 403 语义——预留分支（基线无业务调用方；POC 增量承接证照拦截）。
///
/// 403 semantics — a reserved branch (no business caller in the baseline;
/// the identity-check POC increment will consume it).
final class ForbiddenException extends AppException {
  const ForbiddenException({super.serverMessage})
      : super(code: ErrCodes.forbidden);
}

/// 服务端异常（5xx / 非预期状态码）——remote 数据层映射引入。
///
/// Server-side failure (5xx / unexpected status code) — introduced by the
/// remote data layer mapping.
final class ServerException extends AppException {
  const ServerException({super.serverMessage, super.params = const {}})
      : super(code: ErrCodes.server);
}

/// 异常 → 用户提示的分发器（UI 层消费异常的唯一入口）。
///
/// 新增错误语义时：[ErrCodes] 登记码 + ARB 双语补词条 + [_lookup] 加分支，
/// 页面层不感知具体异常类型。
///
/// Dispatcher from exceptions to user-facing text (the only entry the UI
/// layer consumes). To add an error semantic: register a code in
/// [ErrCodes], add the bilingual ARB entries, and extend the [_lookup]
/// switch — pages stay unaware of concrete exception types.
abstract final class AppExceptionPresenter {
  static String present(Object error, AppLocalizations l10n) {
    return switch (error) {
      // 网关 message 透传优先（数据边界，D3）。
      // The gateway message passthrough wins first (data boundary, D3).
      AppException e when e.serverMessage != null => e.serverMessage!,
      AppException e => _lookup(l10n, e),
      _ => l10n.errUnknown,
    };
  }

  static String _lookup(AppLocalizations l10n, AppException e) {
    final status = e.params['status'];
    return switch (e.code) {
      ErrCodes.network => l10n.errNetwork,
      ErrCodes.auth => l10n.errAuth,
      ErrCodes.sessionExpired => l10n.errSessionExpired,
      ErrCodes.forbidden => l10n.errForbidden,
      ErrCodes.server =>
        status == null ? l10n.errServer : l10n.errServerStatus(status),
      ErrCodes.validationAccountsMissing => l10n.errValidationAccountsMissing,
      ErrCodes.validationAccountNotFound =>
        l10n.errValidationAccountNotFound(e.params['id'] ?? ''),
      ErrCodes.validationIdentityMissing => l10n.errValidationIdentityMissing,
      ErrCodes.validationSameAccounts => l10n.errValidationSameAccounts,
      ErrCodes.validationTransferAmountPositive =>
        l10n.errValidationTransferAmountPositive,
      ErrCodes.validationDepositAmountPositive =>
        l10n.errValidationDepositAmountPositive,
      ErrCodes.validationInsufficientBalance =>
        l10n.errValidationInsufficientBalance,
      ErrCodes.validationProductNotFound =>
        l10n.errValidationProductNotFound(e.params['id'] ?? ''),
      ErrCodes.validationBelowMinDeposit => l10n.errValidationBelowMinDeposit,
      ErrCodes.validationBadRequest => l10n.errValidationBadRequest,
      _ => l10n.errUnknown,
    };
  }
}
