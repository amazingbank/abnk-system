/// 储蓄交易明细模型（对齐 P0.2 实测字段口径：runningBalance 保留）。
library;

/// 单笔交易明细。
class TransactionItem {
  const TransactionItem({
    required this.id,
    required this.date,
    required this.transactionType,
    required this.amount,
    required this.runningBalance,
    this.note,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) => TransactionItem(
        id: json['id'] as int,
        date: json['date'] as String,
        transactionType: json['transactionType'] as String,
        amount: (json['amount'] as num).toDouble(),
        runningBalance: (json['runningBalance'] as num).toDouble(),
        note: json['note'] as String?,
      );

  final int id;
  final String date;
  final String transactionType;
  final double amount;
  final double runningBalance;
  final String? note;

  bool get isDebit => transactionType != 'Deposit';

  String get typeLabel => switch (transactionType) {
        'Deposit' => '存入',
        'Withdrawal' => '支取',
        'InterestPosting' => '利息入账',
        _ => transactionType,
      };
}
