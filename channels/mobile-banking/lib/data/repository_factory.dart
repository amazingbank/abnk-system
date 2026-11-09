/// repository 装配工厂（P3.1）——mock / remote 的唯一切换点。
///
/// 切换判据：`--dart-define=ABNK_API_BASE` 非空 → remote（经网关连
/// 真实 Fineract 数据）；空 → mock（fixtures 种子快照，P1 原型口径）。
/// 页面层与 repository 接口对此零感知（分层纪律兑现）。
library;

import '../app_scope.dart';
import 'mock/mock_account_repository.dart';
import 'mock/mock_auth_repository.dart';
import 'mock/mock_identity_repository.dart';
import 'mock/mock_loan_repository.dart';
import 'remote/generated_client.dart';
import 'remote/remote_account_repository.dart';
import 'remote/remote_auth_repository.dart';
import 'remote/remote_identity_repository.dart';
import 'remote/remote_loan_repository.dart';

/// 注入的 API 基址（`--dart-define=ABNK_API_BASE`；空 = mock 模式）。
const String abnkApiBase = String.fromEnvironment('ABNK_API_BASE');

/// 构造应用状态：按 [abnkApiBase] 装配 mock 或 remote repository 集合。
AppState buildAppState() {
  if (abnkApiBase.isEmpty) {
    return AppState(
      auth: MockAuthRepository(),
      identity: MockIdentityRepository(),
      account: MockAccountRepository(),
      loan: MockLoanRepository(),
    );
  }
  final client = GeneratedClient(baseUrl: abnkApiBase);
  return AppState(
    auth: RemoteAuthRepository(client),
    identity: RemoteIdentityRepository(client),
    account: RemoteAccountRepository(client),
    loan: RemoteLoanRepository(client),
  );
}
