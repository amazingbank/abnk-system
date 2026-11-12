import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../core/errors/app_exception.dart';
import '../../core/format/money.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/account.dart';
import '../../data/models/transaction.dart';
import '../../core/widgets/abnk_app_bar.dart';
import '../../l10n/app_localizations.dart';

/// 交易明细页——账户选择 + 流水列表（含 runningBalance 列）。
///
/// [initialAccountId] 存在时为「从账户卡片进入」的定向视图；否则为页签
/// 默认视图（取首个活期账户）。
class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key, this.initialAccountId});

  final int? initialAccountId;

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  List<Account>? _savingsAccounts;
  int? _selectedAccountId;
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
        _savingsAccounts = summary.savingsAccounts;
        final initial = widget.initialAccountId;
        final matched = summary.savingsAccounts
            .where((a) => a.id == initial)
            .firstOrNull;
        _selectedAccountId =
            matched?.id ??
                (summary.savingsAccounts.isNotEmpty
                    ? summary.savingsAccounts.first.id
                    : null);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final accounts = _savingsAccounts;
    final selectedId = _selectedAccountId;
    // 页面文案词条化（Part03 任务 3.4）。
    // Page copy resolves via l10n (Part03 task 3.4).
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AbnkColors.ivory,
      appBar: abnkAppBar(l10n.txTitle),
      body: (accounts == null)
          ? const Center(child: CircularProgressIndicator())
          : accounts.isEmpty
              ? Center(child: Text(l10n.txNoAccounts))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: DropdownButtonFormField<int>(
                        key: const Key('tx-account'),
                        isExpanded: true,
                        initialValue: selectedId,
                        decoration:
                            InputDecoration(labelText: l10n.txSelectAccount),
                        items: [
                          for (final account in accounts)
                            DropdownMenuItem(
                              value: account.id,
                              child: Text(
                                l10n.accountTitle(
                                    account.productName, account.accountNo),
                              ),
                            ),
                        ],
                        onChanged: (v) =>
                            setState(() => _selectedAccountId = v),
                      ),
                    ),
                    Expanded(
                      child: selectedId == null
                          ? const SizedBox.shrink()
                          : _TransactionList(accountId: selectedId),
                    ),
                  ],
                ),
    );
  }
}

class _TransactionList extends StatefulWidget {
  const _TransactionList({required this.accountId});

  final int accountId;

  @override
  State<_TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<_TransactionList> {
  late Future<List<TransactionItem>> _future;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _future = _load();
  }

  Future<List<TransactionItem>> _load() =>
      AppScope.of(context).state.account.getTransactions(widget.accountId);

  @override
  void didUpdateWidget(covariant _TransactionList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.accountId != widget.accountId) {
      _future = _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<List<TransactionItem>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(AppExceptionPresenter.present(
                  snapshot.error!, AppLocalizations.of(context)!)),
            ),
          );
        }
        final items = snapshot.data!;
        if (items.isEmpty) {
          return Center(
            child: Text(
              l10n.txEmpty,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AbnkColors.taupe500,
                  ),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            final future = _load();
            setState(() => _future = future);
            await future;
          },
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: items.length,
            separatorBuilder: (_, _) =>
                const Divider(height: 1, color: AbnkColors.taupe200),
            itemBuilder: (context, index) {
              final item = items[index];
              return _TransactionTile(item: item);
            },
          ),
        );
      },
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.item});

  final TransactionItem item;

  @override
  Widget build(BuildContext context) {
    // 交易类型 label 决策上移（Part03 任务 3.4）：接收 l10n 的顶层映射。
    // The transaction-type label decision moved up (Part03 task 3.4): a
    // top-level mapping that takes the l10n.
    final l10n = AppLocalizations.of(context)!;
    final typeLabel = transactionTypeLabel(l10n, item.transactionType);
    final amountColor = item.isDebit ? AbnkColors.brick500 : AbnkColors.sage700;
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      leading: CircleAvatar(
        backgroundColor: AbnkColors.taupe100,
        child: Icon(
          item.isDebit ? Icons.south_west : Icons.north_east,
          color: amountColor,
          size: 18,
        ),
      ),
      title: Text(
        item.note ?? typeLabel,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: AbnkColors.char,
            ),
      ),
      subtitle: Text(
        '${item.date} · $typeLabel',
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: AbnkColors.taupe500,
            ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${item.isDebit ? '-' : '+'}${AbnkMoney.format(item.amount)}',
            style: AbnkFonts.mono(
              base: TextStyle(
                fontWeight: FontWeight.w600,
                color: amountColor,
              ),
            ),
          ),
          Text(
            l10n.txBalanceLabel(AbnkMoney.format(item.runningBalance)),
            style: AbnkFonts.mono(
              base: const TextStyle(
                fontSize: 11,
                color: AbnkColors.taupe500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
