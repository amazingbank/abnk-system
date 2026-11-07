import '../models/loan.dart';
import '../repositories/loan_repository.dart';
import 'fixture_bundle.dart';

/// [LoanRepository] 的 mock 实现——产品来自 `fixtures/loan_products.json`
/// （P0.3 种子：消费贷 productId=11 / 定期产品=20）。
class MockLoanRepository implements LoanRepository {
  MockLoanRepository({this.latency = const Duration(milliseconds: 300)});

  final Duration latency;

  int _nextLoanId = 900;

  @override
  Future<List<LoanProduct>> getLoanProducts() async {
    await Future<void>.delayed(latency);
    final data = await FixtureBundle.load('loan_products.json');
    return (data['loanProducts'] as List)
        .whereType<Map<String, dynamic>>()
        .map(LoanProduct.fromJson)
        .toList();
  }

  @override
  Future<List<FixedDepositProduct>> getFixedDepositProducts() async {
    await Future<void>.delayed(latency);
    final data = await FixtureBundle.load('loan_products.json');
    return (data['fixedDepositProducts'] as List)
        .whereType<Map<String, dynamic>>()
        .map(FixedDepositProduct.fromJson)
        .toList();
  }

  @override
  Future<LoanApplicationResult> applyLoan(
      LoanApplicationRequest request) async {
    await Future<void>.delayed(latency);
    return LoanApplicationResult(
      loanId: _nextLoanId++,
      status: 'submittedAndPendingApproval',
    );
  }
}
