/// 贷款产品 / 定期产品 / 贷款申请模型。
library;

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

  String get repaymentMethodLabel =>
      repaymentMethod == 'EQUAL_INSTALLMENTS' ? '等额本息' : repaymentMethod;
}

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
