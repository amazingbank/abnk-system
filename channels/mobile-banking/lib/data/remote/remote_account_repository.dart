import 'dart:math';

import 'package:dio/dio.dart';
import 'package:openapi/openapi.dart' as gen;

import '../models/account.dart';
import '../models/transaction.dart';
import '../repositories/account_repository.dart';
import 'generated_client.dart';

/// [AccountRepository] 的 remote 实现（P3.1）——账户总览 / 交易明细 /
/// 转账（幂等键客户端生成）/ 定期开户，全部经网关对客通道。
class RemoteAccountRepository implements AccountRepository {
  RemoteAccountRepository(this._client);

  final GeneratedClient _client;

  final Random _random = Random();

  /// 客户端幂等键（P2.4 语义：重放返回首次结果；每次转账唯一）。
  ///
  /// 标准库口径生成（时间戳 + 随机段），不引入 uuid 三方包。
  String _idempotencyKey() {
    final ts = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
    final rand = List.generate(
      8,
      (_) => _random.nextInt(36).toRadixString(36),
    ).join();
    return 'abnk-$ts-$rand';
  }

  @override
  Future<AccountSummary> getAccounts(String username) async {
    try {
      final response = await _client.accounts.getMyAccounts();
      final data = response.data!;
      return AccountSummary(
        savingsAccounts: data.savingsAccounts.map(_mapAccount).toList(),
        fixedDepositAccounts:
            data.fixedDepositAccounts.map(_mapAccount).toList(),
      );
    } on DioException catch (error) {
      throw mapApiError(error);
    }
  }

  @override
  Future<List<TransactionItem>> getTransactions(int accountId) async {
    try {
      final response = await _client.accounts.listAccountTransactions(
        id: accountId,
      );
      final data = response.data;
      if (data == null) {
        return const [];
      }
      return data.map(_mapTransaction).toList();
    } on DioException catch (error) {
      throw mapApiError(error);
    }
  }

  @override
  Future<TransferResult> transfer(TransferRequest request) async {
    try {
      final response = await _client.accounts.transfer(
        id: request.fromAccountId,
        transferRequest: gen.TransferRequest((b) => b
          ..toAccountId = request.toAccountId
          ..amount = request.amount
          ..externalId = _idempotencyKey()
          ..note = request.note),
      );
      final data = response.data!;
      return TransferResult(
        transactionId: data.transactionId,
        newSourceBalance: data.newSourceBalance.toDouble(),
      );
    } on DioException catch (error) {
      throw mapApiError(error);
    }
  }

  @override
  Future<FixedDepositResult> openFixedDeposit(
      FixedDepositRequest request) async {
    try {
      final response = await _client.accounts.openFixedDeposit(
        fixedDepositRequest: gen.FixedDepositRequest((b) => b
          ..productId = request.productId
          ..sourceAccountId = request.sourceAccountId
          ..amount = request.amount),
      );
      final data = response.data!;
      return FixedDepositResult(
        accountId: data.accountId,
        maturityDate: data.maturityDate.toString(),
      );
    } on DioException catch (error) {
      throw mapApiError(error);
    }
  }

  Account _mapAccount(gen.Account account) => Account(
        id: account.id,
        accountNo: account.accountNo,
        productName: account.productName,
        accountType:
            account.accountType == gen.AccountAccountTypeEnum.FIXED_DEPOSIT
                ? AccountType.fixedDeposit
                : AccountType.savings,
        currency: account.currency,
        accountBalance: account.accountBalance.toDouble(),
        availableBalance: account.availableBalance.toDouble(),
        status: account.status,
        interestRate: account.interestRate?.toDouble(),
        maturityDate: account.maturityDate?.toString(),
      );

  TransactionItem _mapTransaction(gen.TransactionItem item) => TransactionItem(
        id: item.id,
        date: item.date.toString(),
        transactionType: item.transactionType,
        amount: item.amount.toDouble(),
        runningBalance: item.runningBalance.toDouble(),
        note: item.note,
      );
}
