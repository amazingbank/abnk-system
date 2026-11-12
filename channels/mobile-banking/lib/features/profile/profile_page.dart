import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../core/errors/app_exception.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/identity.dart';
import '../../core/widgets/abnk_app_bar.dart';
import '../../l10n/app_localizations.dart';

/// 我的页——客户资料（脱敏）+ 证照有效期（只读）+ 登出。
///
/// 显式不做：证照过期标红横幅（POC 演示增量）；本页状态 chip 为中性只读展示。
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final Future<IdentityInfo> _identityFuture;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final scope = AppScope.of(context);
    _identityFuture =
        scope.state.identity.getIdentity(scope.state.session!.username);
  }

  Future<void> _logout() async {
    final scope = AppScope.of(context);
    await scope.state.logout();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context).state;
    final session = state.session!;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AbnkColors.ivory,
      appBar: abnkAppBar(l10n.navProfile),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ProfileCard(displayName: session.displayName),
          const SizedBox(height: 16),
          _SectionTitle(l10n.profileCustomerInfo),
          _InfoCard(entries: [
            (l10n.fieldUsername, session.username),
            (l10n.profileCustomerId, '${session.clientId}'),
          ]),
          const SizedBox(height: 16),
          _SectionTitle(l10n.profileIdentitySection),
          FutureBuilder<IdentityInfo>(
            future: _identityFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(AppExceptionPresenter.present(
                        snapshot.error!, l10n)),
                  ),
                );
              }
              final identity = snapshot.data!;
              return _InfoCard(entries: [
                (l10n.profileDocType, identity.documentTypeName),
                (l10n.profileDocNumber, identity.documentKey),
                (l10n.profileIssueDate, identity.issuanceDate),
                (l10n.profileExpiry, identity.expiryDate),
              ], trailing: _IdentityStatusChip(status: identity.status));
            },
          ),
          const SizedBox(height: 16),
          // 语言切换区块（Part03 P3.3）：形态对齐既有 _SectionTitle + 列表
          // 卡片风格；选中态反映 state.locale，点击经 AppState.setLocale 整树
          // 切换并持久化。页面其余中文文案属任务 3.4 范围，本任务不动。
          // Language switcher section (Part03 P3.3): mirrors the existing
          // _SectionTitle + list-card style; the selection reflects
          // state.locale, and a tap switches the whole tree via
          // AppState.setLocale with persistence. The remaining Chinese texts
          // on this page belong to task 3.4 and are untouched here.
          _SectionTitle(l10n.profileLanguageTitle),
          _LanguageCard(
            current: state.locale.languageCode,
            onSelect: (locale) => state.setLocale(locale),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            key: const Key('profile-logout'),
            onPressed: _logout,
            style: OutlinedButton.styleFrom(
              foregroundColor: AbnkColors.brick700,
              side: const BorderSide(color: AbnkColors.brick300),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            icon: const Icon(Icons.logout),
            label: Text(l10n.profileLogout),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.profilePrototypeNote,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: AbnkColors.taupe400,
                ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.displayName});

  final String displayName;

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
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AbnkColors.taupe100,
            child: Text(
              displayName.isEmpty ? '·' : displayName[0].toUpperCase(),
              style: const TextStyle(
                color: AbnkColors.copper700,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: AbnkColors.char,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.profileBadge,
                  style: AbnkFonts.eyebrow(
                    base: const TextStyle(
                      color: AbnkColors.taupe500,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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

/// 语言切换卡片（Part03 P3.3）——中文 / English 两选项，选中项带勾选尾标。
///
/// Language switcher card (Part03 P3.3): two options (中文 / English),
/// the selected one carries a trailing check mark.
class _LanguageCard extends StatelessWidget {
  const _LanguageCard({required this.current, required this.onSelect});

  /// 当前语言（zh/en 小写简码，D8）。
  /// The current language (zh/en lowercase codes, D8).
  final String current;

  /// 选中回调——消费方传 AppState.setLocale（整树重建 + 持久化）。
  /// Selection callback — the caller wires it to AppState.setLocale
  /// (full-tree rebuild + persistence).
  final ValueChanged<Locale> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      color: AbnkColors.warmwhite,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AbnkColors.taupe200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            _LanguageOption(
              key: const Key('profile-language-zh'),
              label: l10n.profileLanguageZh,
              selected: current == 'zh',
              value: const Locale('zh'),
              onSelect: onSelect,
            ),
            const Divider(height: 1, color: AbnkColors.taupe200),
            _LanguageOption(
              key: const Key('profile-language-en'),
              label: l10n.profileLanguageEn,
              selected: current == 'en',
              value: const Locale('en'),
              onSelect: onSelect,
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    super.key,
    required this.label,
    required this.selected,
    required this.value,
    required this.onSelect,
  });

  final String label;
  final bool selected;
  final Locale value;
  final ValueChanged<Locale> onSelect;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      onTap: () => onSelect(value),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: AbnkColors.char,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
      ),
      trailing: selected
          ? const Icon(Icons.check, color: AbnkColors.sage700, size: 20)
          : null,
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.entries, this.trailing});

  final List<(String, String)> entries;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AbnkColors.warmwhite,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AbnkColors.taupe200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            for (final (i, (label, value)) in entries.indexed) ...[
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AbnkColors.espresso,
                      ),
                ),
                trailing: i == 0 && trailing != null
                    ? trailing
                    : Text(
                        value,
                        style:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: AbnkColors.char,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
              ),
              if (i != entries.length - 1)
                const Divider(height: 1, color: AbnkColors.taupe200),
            ],
          ],
        ),
      ),
    );
  }
}

class _IdentityStatusChip extends StatelessWidget {
  const _IdentityStatusChip({required this.status});

  final IdentityStatus status;

  @override
  Widget build(BuildContext context) {
    // 证照状态 label 决策上移（Part03 任务 3.4）：接收 l10n 的顶层映射。
    // The identity-status label decision moved up (Part03 task 3.4): a
    // top-level mapping that takes the l10n.
    final label = identityStatusLabel(AppLocalizations.of(context)!, status);
    final fg = switch (status) {
      IdentityStatus.valid => AbnkColors.sage700,
      IdentityStatus.expiringSoon => AbnkColors.ochre700,
      IdentityStatus.expired => AbnkColors.brick700,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AbnkColors.taupe100,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
