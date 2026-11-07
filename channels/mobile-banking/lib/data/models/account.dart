/// 账户与资金操作模型（转账 / 定期开户）。
library;

enum AccountType { savings, fixedDeposit }

/// 账户（活期 / 定期）。
class Account {
  const Account({
    required this.id,
    required this.accountNo,
    required this.productName,
    required this.accountType,
    required this.currency,
    required this.accountBalance,
    required this.availableBalance,
    required this.status,
    this.interestRate,
    this.maturityDate,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        id: json['id'] as int,
        accountNo: json['accountNo'] as String,
        productName: json['productName'] as String,
        accountType: json['accountType'] == 'FIXED_DEPOSIT'
            ? AccountType.fixedDeposit
            : AccountType.savings,
        currency: json['currency'] as String,
        accountBalance: (json['accountBalance'] as num).toDouble(),
        // 定期账户快照可无 availableBalance（支取受限）——回退为账面余额。
        availableBalance: (json['availableBalance'] as num?)?.toDouble() ??
            (json['accountBalance'] as num).toDouble(),
        status: json['status'] as String? ?? 'ACTIVE',
        interestRate: (json['interestRate'] as num?)?.toDouble(),
        maturityDate: json['maturityDate'] as String?,
      );

  final int id;
  final String accountNo;
  final String productName;
  final AccountType accountType;
  final String currency;
  final double accountBalance;
  final double availableBalance;
  final String status;
  final double? interestRate;
  final String? maturityDate;

  Account copyWith({
    double? accountBalance,
    double? availableBalance,
    String? maturityDate,
  }) =>
      Account(
        id: id,
        accountNo: accountNo,
        productName: productName,
        accountType: accountType,
        currency: currency,
        accountBalance: accountBalance ?? this.accountBalance,
        availableBalance: availableBalance ?? this.availableBalance,
        status: status,
        interestRate: interestRate,
        maturityDate: maturityDate ?? this.maturityDate,
      );
}

/// 账户总览（活期 + 定期两组）。
class AccountSummary {
  const AccountSummary({required this.savingsAccounts, required this.fixedDepositAccounts});

  final List<Account> savingsAccounts;
  final List<Account> fixedDepositAccounts;

  double get savingsTotal =>
      savingsAccounts.fold(0, (sum, a) => sum + a.accountBalance);
}

/// 本人账户间转账请求。
class TransferRequest {
  const TransferRequest({
    required this.fromAccountId,
    required this.toAccountId,
    required this.amount,
    this.note,
  });

  final int fromAccountId;
  final int toAccountId;
  final double amount;
  final String? note;
}

/// 转账结果（源账户新余额 + 流水号）。
class TransferResult {
  const TransferResult({required this.transactionId, required this.newSourceBalance});

  final int transactionId;
  final double newSourceBalance;
}

/// 定期开户请求。
class FixedDepositRequest {
  const FixedDepositRequest({
    required this.productId,
    required this.sourceAccountId,
    required this.amount,
  });

  final int productId;
  final int sourceAccountId;
  final double amount;
}

/// 定期开户结果（新账户号 + 到期日）。
class FixedDepositResult {
  const FixedDepositResult({required this.accountId, required this.maturityDate});

  final int accountId;
  final String maturityDate;
}
