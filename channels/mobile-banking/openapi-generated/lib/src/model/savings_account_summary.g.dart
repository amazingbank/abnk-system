// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_account_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SavingsAccountSummary extends SavingsAccountSummary {
  @override
  final int id;
  @override
  final String accountNo;
  @override
  final String productName;
  @override
  final num accountBalance;
  @override
  final String currency;
  @override
  final String status;

  factory _$SavingsAccountSummary(
          [void Function(SavingsAccountSummaryBuilder)? updates]) =>
      (SavingsAccountSummaryBuilder()..update(updates))._build();

  _$SavingsAccountSummary._(
      {required this.id,
      required this.accountNo,
      required this.productName,
      required this.accountBalance,
      required this.currency,
      required this.status})
      : super._();
  @override
  SavingsAccountSummary rebuild(
          void Function(SavingsAccountSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SavingsAccountSummaryBuilder toBuilder() =>
      SavingsAccountSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SavingsAccountSummary &&
        id == other.id &&
        accountNo == other.accountNo &&
        productName == other.productName &&
        accountBalance == other.accountBalance &&
        currency == other.currency &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, accountNo.hashCode);
    _$hash = $jc(_$hash, productName.hashCode);
    _$hash = $jc(_$hash, accountBalance.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SavingsAccountSummary')
          ..add('id', id)
          ..add('accountNo', accountNo)
          ..add('productName', productName)
          ..add('accountBalance', accountBalance)
          ..add('currency', currency)
          ..add('status', status))
        .toString();
  }
}

class SavingsAccountSummaryBuilder
    implements Builder<SavingsAccountSummary, SavingsAccountSummaryBuilder> {
  _$SavingsAccountSummary? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _accountNo;
  String? get accountNo => _$this._accountNo;
  set accountNo(String? accountNo) => _$this._accountNo = accountNo;

  String? _productName;
  String? get productName => _$this._productName;
  set productName(String? productName) => _$this._productName = productName;

  num? _accountBalance;
  num? get accountBalance => _$this._accountBalance;
  set accountBalance(num? accountBalance) =>
      _$this._accountBalance = accountBalance;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  SavingsAccountSummaryBuilder() {
    SavingsAccountSummary._defaults(this);
  }

  SavingsAccountSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _accountNo = $v.accountNo;
      _productName = $v.productName;
      _accountBalance = $v.accountBalance;
      _currency = $v.currency;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SavingsAccountSummary other) {
    _$v = other as _$SavingsAccountSummary;
  }

  @override
  void update(void Function(SavingsAccountSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SavingsAccountSummary build() => _build();

  _$SavingsAccountSummary _build() {
    final _$result = _$v ??
        _$SavingsAccountSummary._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'SavingsAccountSummary', 'id'),
          accountNo: BuiltValueNullFieldError.checkNotNull(
              accountNo, r'SavingsAccountSummary', 'accountNo'),
          productName: BuiltValueNullFieldError.checkNotNull(
              productName, r'SavingsAccountSummary', 'productName'),
          accountBalance: BuiltValueNullFieldError.checkNotNull(
              accountBalance, r'SavingsAccountSummary', 'accountBalance'),
          currency: BuiltValueNullFieldError.checkNotNull(
              currency, r'SavingsAccountSummary', 'currency'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'SavingsAccountSummary', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
