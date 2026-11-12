/// 储蓄交易明细模型（对齐 P0.2 实测字段口径：runningBalance 保留）。
///
/// 交易类型展示文案经顶层函数 [transactionTypeLabel] 提供（Part03 任务
/// 3.4：label 决策上移 UI 层并接收 l10n，models 保持零 BuildContext 依赖）。
///
/// Savings transaction model (aligned with the P0.2 field observations:
/// runningBalance kept). The display label for the transaction type is
/// provided by the top-level [transactionTypeLabel] (Part03 task 3.4: the
/// label decision moved up to the UI layer and takes the l10n, while models
/// stay free of any BuildContext dependency).
library;

import '../../l10n/app_localizations.dart';

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
}

/// 交易类型 → 展示文案（Part03 任务 3.4：接收 l10n，未知类型原样透传）。
///
/// Transaction type → display label (Part03 task 3.4: takes the l10n;
/// unknown types pass through verbatim).
String transactionTypeLabel(AppLocalizations l10n, String transactionType) =>
    switch (transactionType) {
      'Deposit' => l10n.txTypeDeposit,
      'Withdrawal' => l10n.txTypeWithdrawal,
      'InterestPosting' => l10n.txTypeInterestPosting,
      _ => transactionType,
    };
