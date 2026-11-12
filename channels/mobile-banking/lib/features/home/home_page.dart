import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../core/errors/app_exception.dart';
import '../../core/format/money.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/account.dart';
import '../../core/widgets/abnk_app_bar.dart';
import '../../l10n/app_localizations.dart';
import '../fixed_deposit/fixed_deposit_page.dart';
import '../transactions/transactions_page.dart';
import '../transfer/transfer_page.dart';

/// 首页——账户总览（活期余额合计 + 账户卡片 + 快捷操作 + 定期账户）。
///
/// 显式不做：证照过期横幅（POC 演示增量，基线不预设业务分支）。
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.onNavigateTab});

  /// 快捷操作切换主脚手架页签（明细 / 贷款）。
  final ValueChanged<int> onNavigateTab;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<AccountSummary> _future;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final scope = AppScope.of(context);
    _future = scope.state.account.getAccounts(scope.state.session!.username);
  }

  void _openTransactions(Account account) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => TransactionsPage(initialAccountId: account.id),
    ));
  }

  Future<void> _reload() async {
    final scope = AppScope.of(context);
    final future =
        scope.state.account.getAccounts(scope.state.session!.username);
    setState(() => _future = future);
    await future;
  }

  @override
  Widget build(BuildContext context) {
    final session = AppScope.of(context).state.session!;
    // 页面文案词条化（Part03 任务 3.4）。
    // Page copy resolves via l10n (Part03 task 3.4).
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AbnkColors.ivory,
      appBar: abnkAppBar(l10n.appName),
      body: RefreshIndicator(
        onRefresh: _reload,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              l10n.homeWelcome,
              style: AbnkFonts.eyebrow(
                base: const TextStyle(color: AbnkColors.taupe500),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.homeGreeting(session.displayName),
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: AbnkColors.char,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<AccountSummary>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const _BalanceCardPlaceholder();
                }
                if (snapshot.hasError) {
                  return _ErrorCard(
                    message: AppExceptionPresenter.present(
                        snapshot.error!, AppLocalizations.of(context)!));
                }
                final data = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _TotalBalanceCard(total: data.savingsTotal),
                    const SizedBox(height: 16),
                    _QuickActions(
                      onTransfer: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (_) => const TransferPage()),
                      ),
                      onFixedDeposit: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (_) => const FixedDepositPage()),
                      ),
                      onLoans: () => widget.onNavigateTab(2),
                      onTransactions: () => widget.onNavigateTab(1),
                    ),
                    const SizedBox(height: 24),
                    if (data.fixedDepositAccounts.isNotEmpty) ...[
                      _SectionTitle(l10n.homeFixedDepositsSection),
                      ...data.fixedDepositAccounts.map(_FixedDepositTile.new),
                      const SizedBox(height: 16),
                    ],
                    _SectionTitle(l10n.homeSavingsSection),
                    ...data.savingsAccounts.map((a) => _AccountTile(
                          account: a,
                          onTap: () => _openTransactions(a),
                        )),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalBalanceCard extends StatelessWidget {
  const _TotalBalanceCard({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AbnkColors.warmwhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AbnkColors.taupe200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.homeTotalSavingsBalance,
            style: AbnkFonts.eyebrow(
              base: const TextStyle(color: AbnkColors.espresso),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AbnkMoney.format(total),
            style: AbnkFonts.mono(
              base: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AbnkColors.char,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceCardPlaceholder extends StatelessWidget {
  const _BalanceCardPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AbnkColors.warmwhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AbnkColors.taupe200),
      ),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onTransfer,
    required this.onFixedDeposit,
    required this.onLoans,
    required this.onTransactions,
  });

  final VoidCallback onTransfer;
  final VoidCallback onFixedDeposit;
  final VoidCallback onLoans;
  final VoidCallback onTransactions;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: _QuickAction(
            icon: Icons.swap_horiz,
            label: l10n.homeActionTransfer,
            onTap: onTransfer,
          ),
        ),
        Expanded(
          child: _QuickAction(
            icon: Icons.savings_outlined,
            label: l10n.homeActionTermDeposit,
            onTap: onFixedDeposit,
          ),
        ),
        Expanded(
          child: _QuickAction(
            icon: Icons.account_balance_outlined,
            label: l10n.navLoans,
            onTap: onLoans,
          ),
        ),
        Expanded(
          child: _QuickAction(
            icon: Icons.receipt_long_outlined,
            label: l10n.navTransactions,
            onTap: onTransactions,
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AbnkColors.taupe100,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AbnkColors.copper700),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: AbnkColors.espresso,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: AbnkFonts.eyebrow(
          base: const TextStyle(color: AbnkColors.taupe600),
        ),
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  const _AccountTile({required this.account, required this.onTap});

  final Account account;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AbnkColors.warmwhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AbnkColors.taupe200),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          l10n.accountTitle(account.productName, account.accountNo),
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: AbnkColors.espresso,
              ),
        ),
        subtitle: Text(
          l10n.homeAvailableBalance(
              AbnkMoney.format(account.availableBalance)),
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: AbnkColors.taupe500,
              ),
        ),
        trailing: Text(
          AbnkMoney.format(account.accountBalance),
          style: AbnkFonts.mono(
            base: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AbnkColors.char,
            ),
          ),
        ),
      ),
    );
  }
}

class _FixedDepositTile extends StatelessWidget {
  const _FixedDepositTile(this.account);

  final Account account;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AbnkColors.warmwhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AbnkColors.taupe200),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          l10n.accountTitle(account.productName, account.accountNo),
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: AbnkColors.espresso,
              ),
        ),
        subtitle: Text(
          l10n.homeFdRateAndMaturity(
            account.interestRate?.toStringAsFixed(1) ?? '-',
            account.maturityDate ?? '-',
          ),
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: AbnkColors.taupe500,
              ),
        ),
        trailing: Text(
          AbnkMoney.format(account.accountBalance),
          style: AbnkFonts.mono(
            base: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AbnkColors.copper700,
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AbnkColors.warmwhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AbnkColors.brick300),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AbnkColors.brick500),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}
