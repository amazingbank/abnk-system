import '../models/loan.dart';

/// 贷款域接口——产品查询与申请。
///
/// 方法签名即 P1.5 契约草签（`GET /loan-products`、`POST /loans`）。
abstract interface class LoanRepository {
  /// 消费贷产品清单（对客收敛字段）。
  Future<List<LoanProduct>> getLoanProducts();

  /// 定期存款产品清单。
  Future<List<FixedDepositProduct>> getFixedDepositProducts();

  /// 提交贷款申请，返回申请编号与初始状态。
  Future<LoanApplicationResult> applyLoan(LoanApplicationRequest request);
}
