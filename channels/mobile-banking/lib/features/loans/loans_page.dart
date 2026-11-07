import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_scope.dart';
import '../../core/widgets/abnk_app_bar.dart';
import '../../core/errors/app_exception.dart';
import '../../core/format/money.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/loan.dart';

/// 贷款页——消费贷产品展示（利率 / 期限 / 额度）+ 申请表单。
class LoansPage extends StatefulWidget {
  const LoansPage({super.key});

  @override
  State<LoansPage> createState() => _LoansPageState();
}

class _LoansPageState extends State<LoansPage> {
  late final Future<List<LoanProduct>> _future;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _future = AppScope.of(context).state.loan.getLoanProducts();
  }

  void _openApplyForm(LoanProduct product) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 8,
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 16,
        ),
        child: _LoanApplySheet(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AbnkColors.ivory,
      appBar: abnkAppBar('消费贷款'),
      body: FutureBuilder<List<LoanProduct>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _ErrorCard(message: AppExceptionPresenter.present(snapshot.error!));
          }
          final products = snapshot.data!;
          if (products.isEmpty) {
            return const Center(child: Text('暂无可选贷款产品'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (final product in products)
                _ProductCard(
                  product: product,
                  onApply: () => _openApplyForm(product),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.onApply});

  final LoanProduct product;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AbnkColors.warmwhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AbnkColors.taupe200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: AbnkColors.char,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              product.description,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: AbnkColors.taupe500,
                  ),
            ),
            const Divider(height: 24, color: AbnkColors.taupe200),
            Row(
              children: [
                _Metric(label: '年利率', value: '${product.interestRate}%'),
                const SizedBox(width: 24),
                _Metric(label: '期限', value: '最长 ${product.termFrequency} 个月'),
                const SizedBox(width: 24),
                _Metric(label: '还款方式', value: product.repaymentMethodLabel),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '额度 ${AbnkMoney.format(product.minPrincipalAmount)} ~ '
              '${AbnkMoney.format(product.maxPrincipalAmount)}',
              style: AbnkFonts.mono(
                base: const TextStyle(
                  color: AbnkColors.espresso,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                key: Key('loan-apply-${product.id}'),
                onPressed: onApply,
                child: const Text('申请贷款'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AbnkFonts.eyebrow(
            base: const TextStyle(color: AbnkColors.taupe500, fontSize: 10),
          ),
        ),
        Text(
          value,
          style: AbnkFonts.mono(
            base: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AbnkColors.copper700,
            ),
          ),
        ),
      ],
    );
  }
}

class _LoanApplySheet extends StatefulWidget {
  const _LoanApplySheet({required this.product});

  final LoanProduct product;

  @override
  State<_LoanApplySheet> createState() => _LoanApplySheetState();
}

class _LoanApplySheetState extends State<_LoanApplySheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _purposeController = TextEditingController();
  late int _termMonths;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _termMonths = widget.product.termFrequency;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      final scope = AppScope.of(context);
      final result = await scope.state.loan.applyLoan(LoanApplicationRequest(
        productId: widget.product.id,
        principal: double.parse(_amountController.text.trim()),
        termMonths: _termMonths,
        purpose: _purposeController.text.trim().isEmpty
            ? null
            : _purposeController.text.trim(),
      ));
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('申请已提交（贷款编号 ${result.loanId}），等待审批')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppExceptionPresenter.present(e))),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '申请 ${product.name}',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: AbnkColors.char,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: const Key('loan-amount'),
            controller: _amountController,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            decoration: const InputDecoration(
              labelText: '申请金额（CNY）',
              prefixText: '¥ ',
            ),
            validator: (v) {
              final amount = double.tryParse(v?.trim() ?? '');
              if (amount == null || amount <= 0) return '请输入有效金额';
              if (amount < product.minPrincipalAmount) return '低于最低额度';
              if (amount > product.maxPrincipalAmount) return '超出最高额度';
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            key: const Key('loan-term'),
            initialValue: _termMonths,
            decoration: const InputDecoration(labelText: '期限（月）'),
            items: [
              for (final m in [6, 12, 18, 24, 36])
                if (m <= product.termFrequency)
                  DropdownMenuItem(value: m, child: Text('$m 个月')),
            ],
            onChanged: (v) => setState(() => _termMonths = v ?? _termMonths),
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: const Key('loan-purpose'),
            controller: _purposeController,
            maxLength: 40,
            decoration: const InputDecoration(labelText: '用途（选填）'),
          ),
          const SizedBox(height: 16),
          FilledButton(
            key: const Key('loan-submit'),
            onPressed: _submitting ? null : _submit,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: _submitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('提交申请'),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(message),
      ),
    );
  }
}
