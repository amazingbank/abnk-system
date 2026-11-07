import '../models/account.dart';
import '../models/transaction.dart';

/// 账户与资金操作接口。
///
/// 方法签名即 P1.5 契约草签（`GET /me/accounts`、
/// `GET /accounts/{id}/transactions`、`POST /accounts/{id}/transfer`、
/// `POST /savings`）。
abstract interface class AccountRepository {
  /// 账户总览（活期 + 定期，仅本人账户）。
  Future<AccountSummary> getAccounts(String username);

  /// 单账户交易明细（含 runningBalance）。
  Future<List<TransactionItem>> getTransactions(int accountId);

  /// 本人账户间转账（网关聚合幂等语义，P2.4 承接）。
  Future<TransferResult> transfer(TransferRequest request);

  /// 定期开户（从活期账户扣款转入新定期账户）。
  Future<FixedDepositResult> openFixedDeposit(FixedDepositRequest request);
}
