// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AccountSummary extends AccountSummary {
  @override
  final BuiltList<Account> savingsAccounts;
  @override
  final BuiltList<Account> fixedDepositAccounts;

  factory _$AccountSummary([void Function(AccountSummaryBuilder)? updates]) =>
      (AccountSummaryBuilder()..update(updates))._build();

  _$AccountSummary._(
      {required this.savingsAccounts, required this.fixedDepositAccounts})
      : super._();
  @override
  AccountSummary rebuild(void Function(AccountSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountSummaryBuilder toBuilder() => AccountSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountSummary &&
        savingsAccounts == other.savingsAccounts &&
        fixedDepositAccounts == other.fixedDepositAccounts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, savingsAccounts.hashCode);
    _$hash = $jc(_$hash, fixedDepositAccounts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AccountSummary')
          ..add('savingsAccounts', savingsAccounts)
          ..add('fixedDepositAccounts', fixedDepositAccounts))
        .toString();
  }
}

class AccountSummaryBuilder
    implements Builder<AccountSummary, AccountSummaryBuilder> {
  _$AccountSummary? _$v;

  ListBuilder<Account>? _savingsAccounts;
  ListBuilder<Account> get savingsAccounts =>
      _$this._savingsAccounts ??= ListBuilder<Account>();
  set savingsAccounts(ListBuilder<Account>? savingsAccounts) =>
      _$this._savingsAccounts = savingsAccounts;

  ListBuilder<Account>? _fixedDepositAccounts;
  ListBuilder<Account> get fixedDepositAccounts =>
      _$this._fixedDepositAccounts ??= ListBuilder<Account>();
  set fixedDepositAccounts(ListBuilder<Account>? fixedDepositAccounts) =>
      _$this._fixedDepositAccounts = fixedDepositAccounts;

  AccountSummaryBuilder() {
    AccountSummary._defaults(this);
  }

  AccountSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _savingsAccounts = $v.savingsAccounts.toBuilder();
      _fixedDepositAccounts = $v.fixedDepositAccounts.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountSummary other) {
    _$v = other as _$AccountSummary;
  }

  @override
  void update(void Function(AccountSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountSummary build() => _build();

  _$AccountSummary _build() {
    _$AccountSummary _$result;
    try {
      _$result = _$v ??
          _$AccountSummary._(
            savingsAccounts: savingsAccounts.build(),
            fixedDepositAccounts: fixedDepositAccounts.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'savingsAccounts';
        savingsAccounts.build();
        _$failedField = 'fixedDepositAccounts';
        fixedDepositAccounts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AccountSummary', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
