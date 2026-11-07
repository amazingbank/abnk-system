import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_scope.dart';
import '../../core/widgets/abnk_app_bar.dart';
import '../../core/errors/app_exception.dart';
import '../../core/format/money.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/account.dart';
import '../../data/models/loan.dart';

/// 定期开户页——定期产品展示（利率 / 期限 / 起存金额）+ 开户表单。
class FixedDepositPage extends StatefulWidget {
  const FixedDepositPage({super.key});

  @override
  State<FixedDepositPage> createState() => _FixedDepositPageState();
}

class _FixedDepositPageState extends State<FixedDepositPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  List<FixedDepositProduct>? _products;
  List<Account>? _savingsAccounts;
  FixedDepositProduct? _selectedProduct;
  int? _sourceAccountId;
  bool _submitting = false;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final scope = AppScope.of(context);
    final state = scope.state;
    state.loan.getFixedDepositProducts().then((products) {
      if (!mounted) return;
      setState(() {
        _products = products;
        _selectedProduct = products.isNotEmpty ? products.first : null;
      });
    });
    state.account
        .getAccounts(state.session!.username)
        .then((summary) {
      if (!mounted) return;
      setState(() {
        _savingsAccounts = summary.savingsAccounts;
        _sourceAccountId = summary.savingsAccounts.isNotEmpty
            ? summary.savingsAccounts.first.id
            : null;
      });
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final product = _selectedProduct;
    final sourceId = _sourceAccountId;
    if (product == null || sourceId == null) return;
    setState(() => _submitting = true);
    final scope = AppScope.of(context);
    try {
      final result = await scope.state.account.openFixedDeposit(
        FixedDepositRequest(
          productId: product.id,
          sourceAccountId: sourceId,
          amount: double.parse(_amountController.text.trim()),
        ),
      );
      if (!mounted) return;
      // 操作已完成：先停按钮 spinner，再弹结果对话框（对话框关闭时退页）。
      setState(() => _submitting = false);
      unawaited(showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('定期开户成功'),
          content: Text(
            '新定期账户：0000**0${result.accountId}\n'
            '到期日：${result.maturityDate}（对年对月对日）',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('知道了'),
            ),
          ],
        ),
      ).then((_) {
        if (mounted) Navigator.of(context).pop();
      }));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppExceptionPresenter.present(e))),
      );
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = _products;
    final savings = _savingsAccounts;
    return Scaffold(
      backgroundColor: AbnkColors.ivory,
      appBar: abnkAppBar('定期存款'),
      body: (products == null || savings == null)
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? const _EmptyCard(message: '暂无可选定期产品')
              : savings.isEmpty
                  ? const _EmptyCard(message: '暂无活期账户作为转出账户')
                  : Form(
                      key: _formKey,
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          ...products.map((p) => _ProductCard(
                                product: p,
                                selected: p.id == _selectedProduct?.id,
                                onTap: () =>
                                    setState(() => _selectedProduct = p),
                              )),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<int>(
                            key: const Key('fd-source'),
                            isExpanded: true,
                            initialValue: _sourceAccountId,
                            decoration:
                                const InputDecoration(labelText: '转出活期账户'),
                            items: [
                              for (final account in savings)
                                DropdownMenuItem(
                                  value: account.id,
                                  child: Text(
                                    '${account.productName}（${account.accountNo}）'
                                    ' · ${AbnkMoney.format(account.availableBalance)}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                            onChanged: (v) =>
                                setState(() => _sourceAccountId = v),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            key: const Key('fd-amount'),
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            decoration: const InputDecoration(
                              labelText: '存入金额（CNY）',
                              prefixText: '¥ ',
                            ),
                            validator: (v) {
                              final amount = double.tryParse(v?.trim() ?? '');
                              if (amount == null || amount <= 0) return '请输入有效金额';
                              final product = _selectedProduct;
                              if (product != null &&
                                  amount < product.minDepositAmount) {
                                return '低于起存金额 ${AbnkMoney.format(product.minDepositAmount)}';
                              }
                              final source =
                                  savings.firstWhere((a) => a.id == _sourceAccountId);
                              if (amount > source.availableBalance) return '超出可用余额';
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          FilledButton(
                            key: const Key('fd-submit'),
                            onPressed: _submitting ? null : _submit,
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: _submitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child:
                                        CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Text('开立定期账户'),
                          ),
                        ],
                      ),
                    ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.selected,
    required this.onTap,
  });

  final FixedDepositProduct product;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AbnkColors.warmwhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: selected ? AbnkColors.copper : AbnkColors.taupe200,
          width: selected ? 1.8 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      product.name,
                      style:
                          Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: AbnkColors.char,
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                  ),
                  Icon(
                    selected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: AbnkColors.copper,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                product.description,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: AbnkColors.taupe500,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _Metric(label: '年利率', value: '${product.interestRate}%'),
                  const SizedBox(width: 24),
                  _Metric(label: '期限', value: '${product.depositPeriod} 个月'),
                  const SizedBox(width: 24),
                  _Metric(
                    label: '起存',
                    value: AbnkMoney.format(product.minDepositAmount),
                  ),
                ],
              ),
            ],
          ),
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
            base: const TextStyle(
              color: AbnkColors.taupe500,
              fontSize: 10,
            ),
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

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AbnkColors.espresso,
              ),
        ),
      ),
    );
  }
}
