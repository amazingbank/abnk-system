import 'package:dio/dio.dart';
import 'package:openapi/openapi.dart' as gen;

import '../models/loan.dart';
import '../repositories/loan_repository.dart';
import 'generated_client.dart';

/// [LoanRepository] 的 remote 实现（P3.1）——产品清单走对客收敛端点，
/// 贷款申请转发 Fineract `POST /loans`（受理后 Submitted and pending
/// approval，审批/发放为内部通道动作）。
class RemoteLoanRepository implements LoanRepository {
  RemoteLoanRepository(this._client);

  final GeneratedClient _client;

  @override
  Future<List<LoanProduct>> getLoanProducts() async {
    try {
      final response = await _client.loans.listLoanProducts();
      final data = response.data;
      if (data == null) {
        return const [];
      }
      return data
          .map((p) => LoanProduct(
                id: p.id,
                name: p.name,
                description: p.description,
                interestRate: p.interestRate.toDouble(),
                termFrequency: p.termFrequency,
                termPeriodFrequencyType: p.termPeriodFrequencyType.name,
                minPrincipalAmount: p.minPrincipalAmount.toDouble(),
                maxPrincipalAmount: p.maxPrincipalAmount.toDouble(),
                repaymentMethod: p.repaymentMethod.name,
              ))
          .toList();
    } on DioException catch (error) {
      throw mapApiError(error);
    }
  }

  @override
  Future<List<FixedDepositProduct>> getFixedDepositProducts() async {
    try {
      final response = await _client.loans.listFixedDepositProducts();
      final data = response.data;
      if (data == null) {
        return const [];
      }
      return data
          .map((p) => FixedDepositProduct(
                id: p.id,
                name: p.name,
                description: p.description,
                interestRate: p.interestRate.toDouble(),
                depositPeriod: p.depositPeriod,
                minDepositAmount: p.minDepositAmount.toDouble(),
              ))
          .toList();
    } on DioException catch (error) {
      throw mapApiError(error);
    }
  }

  @override
  Future<LoanApplicationResult> applyLoan(
      LoanApplicationRequest request) async {
    try {
      final response = await _client.loans.applyLoan(
        loanApplicationRequest: gen.LoanApplicationRequest((b) => b
          ..productId = request.productId
          ..principal = request.principal
          ..termMonths = request.termMonths
          ..purpose = request.purpose),
      );
      final data = response.data!;
      return LoanApplicationResult(
        loanId: data.loanId,
        status: data.status,
      );
    } on DioException catch (error) {
      throw mapApiError(error);
    }
  }
}
