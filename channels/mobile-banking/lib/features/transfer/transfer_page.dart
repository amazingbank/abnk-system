import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_scope.dart';
import '../../core/widgets/abnk_app_bar.dart';
import '../../core/errors/app_exception.dart';
import '../../core/format/money.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/account.dart';

/// 转账页——本人账户间转账（金额 + 附言，提交后回显新余额）。
///
/// 基线无证照拦截分支；403 语义经通用错误框架分发（AppExceptionPresenter）。
class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  List<Account>? _accounts;
  int? _fromId;
  int? _toId;
  bool _submitting = false;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final scope = AppScope.of(context);
    scope.state.account
        .getAccounts(scope.state.session!.username)
        .then((summary) {
      if (!mounted) return;
      setState(() {
        _accounts = summary.savingsAccounts;
        _fromId = summary.savingsAccounts.isNotEmpty
            ? summary.savingsAccounts.first.id
            : null;
        _toId = summary.savingsAccounts.length > 1
            ? summary.savingsAccounts[1].id
            : null;
      });
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final fromId = _fromId;
    final toId = _toId;
    if (fromId == null || toId == null) return;
    setState(() => _submitting = true);
    final scope = AppScope.of(context);
    try {
      final result = await scope.state.account.transfer(TransferRequest(
        fromAccountId: fromId,
        toAccountId: toId,
        amount: double.parse(_amountController.text.trim()),
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
      ));
      if (!mounted) return;
      // 操作已完成：先停按钮 spinner，再弹结果对话框（对话框关闭时退页）。
      setState(() => _submitting = false);
      unawaited(showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('转账成功'),
          content: Text(
            '流水号 ${result.transactionId}\n'
            '转出账户新余额：${AbnkMoney.format(result.newSourceBalance)}',
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
    final accounts = _accounts;
    return Scaffold(
      backgroundColor: AbnkColors.ivory,
      appBar: abnkAppBar('本人转账'),
      body: accounts == null
          ? const Center(child: CircularProgressIndicator())
          : accounts.length < 2
              ? const _NoAccountsCard()
              : Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _AccountDropdown(
                        label: '转出账户',
                        value: _fromId,
                        accounts: accounts,
                        onChanged: (v) => setState(() => _fromId = v),
                      ),
                      const SizedBox(height: 16),
                      _AccountDropdown(
                        label: '转入账户',
                        value: _toId,
                        accounts: accounts,
                        onChanged: (v) => setState(() => _toId = v),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        key: const Key('transfer-amount'),
                        controller: _amountController,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        decoration: const InputDecoration(
                          labelText: '转账金额（CNY）',
                          prefixText: '¥ ',
                        ),
                        validator: (v) {
                          final amount = double.tryParse(v?.trim() ?? '');
                          if (amount == null || amount <= 0) return '请输入有效金额';
                          final from = accounts.firstWhere((a) => a.id == _fromId);
                          if (amount > from.availableBalance) return '超出可用余额';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        key: const Key('transfer-note'),
                        controller: _noteController,
                        maxLength: 40,
                        decoration: const InputDecoration(
                          labelText: '附言（选填）',
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        key: const Key('transfer-submit'),
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
                            : const Text('提交转账'),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class _NoAccountsCard extends StatelessWidget {
  const _NoAccountsCard();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.info_outline, color: AbnkColors.taupe400, size: 40),
            const SizedBox(height: 12),
            Text(
              '本人活期账户不足两个，暂无法转账',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AbnkColors.espresso,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountDropdown extends StatelessWidget {
  const _AccountDropdown({
    required this.label,
    required this.value,
    required this.accounts,
    required this.onChanged,
  });

  final String label;
  final int? value;
  final List<Account> accounts;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      isExpanded: true,
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: [
        for (final account in accounts)
          DropdownMenuItem(
            value: account.id,
            child: Text(
              '${account.productName}（${account.accountNo}）'
              ' · ${AbnkMoney.format(account.availableBalance)}',
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      onChanged: onChanged,
    );
  }
}
