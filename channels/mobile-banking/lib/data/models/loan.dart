/// 贷款产品 / 定期产品 / 贷款申请模型。
///
/// 还款方式展示文案经顶层函数 [repaymentMethodLabel] 提供（Part03 任务
/// 3.4：label 决策上移 UI 层并接收 l10n，models 保持零 BuildContext 依赖）。
///
/// Loan / term-deposit product and application models. The repayment-method
/// display label is provided by the top-level [repaymentMethodLabel]
/// (Part03 task 3.4: the label decision moved up to the UI layer and takes
/// the l10n, while models stay free of any BuildContext dependency).
library;

import '../../l10n/app_localizations.dart';

/// 消费贷产品（对客收敛字段——隐藏内部配置）。
class LoanProduct {
  const LoanProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.interestRate,
    required this.termFrequency,
    required this.termPeriodFrequencyType,
    required this.minPrincipalAmount,
    required this.maxPrincipalAmount,
    required this.repaymentMethod,
  });

  factory LoanProduct.fromJson(Map<String, dynamic> json) => LoanProduct(
        id: json['id'] as int,
        name: json['name'] as String,
        description: json['description'] as String,
        interestRate: (json['interestRate'] as num).toDouble(),
        termFrequency: json['termFrequency'] as int,
        termPeriodFrequencyType: json['termPeriodFrequencyType'] as String,
        minPrincipalAmount: (json['minPrincipalAmount'] as num).toDouble(),
        maxPrincipalAmount: (json['maxPrincipalAmount'] as num).toDouble(),
        repaymentMethod: json['repaymentMethod'] as String,
      );

  final int id;
  final String name;
  final String description;
  final double interestRate;
  final int termFrequency;
  final String termPeriodFrequencyType;
  final double minPrincipalAmount;
  final double maxPrincipalAmount;
  final String repaymentMethod;
}

/// 还款方式 → 展示文案（Part03 任务 3.4：接收 l10n，未知方式原样透传）。
///
/// Repayment method → display label (Part03 task 3.4: takes the l10n;
/// unknown methods pass through verbatim).
String repaymentMethodLabel(AppLocalizations l10n, String repaymentMethod) =>
    repaymentMethod == 'EQUAL_INSTALLMENTS'
        ? l10n.repaymentEqualInstallments
        : repaymentMethod;

/// 定期存款产品。
class FixedDepositProduct {
  const FixedDepositProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.interestRate,
    required this.depositPeriod,
    required this.minDepositAmount,
  });

  factory FixedDepositProduct.fromJson(Map<String, dynamic> json) =>
      FixedDepositProduct(
        id: json['id'] as int,
        name: json['name'] as String,
        description: json['description'] as String,
        interestRate: (json['interestRate'] as num).toDouble(),
        depositPeriod: json['depositPeriod'] as int,
        minDepositAmount: (json['minDepositAmount'] as num).toDouble(),
      );

  final int id;
  final String name;
  final String description;
  final double interestRate;
  final int depositPeriod;
  final double minDepositAmount;
}

/// 贷款申请请求。
class LoanApplicationRequest {
  const LoanApplicationRequest({
    required this.productId,
    required this.principal,
    required this.termMonths,
    this.purpose,
  });

  final int productId;
  final double principal;
  final int termMonths;
  final String? purpose;
}

/// 贷款申请结果。
class LoanApplicationResult {
  const LoanApplicationResult({required this.loanId, required this.status});

  final int loanId;
  final String status;
}
