// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fixed_deposit_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FixedDepositSummary extends FixedDepositSummary {
  @override
  final int id;
  @override
  final String accountNo;
  @override
  final String productName;
  @override
  final num accountBalance;
  @override
  final num interestRate;
  @override
  final Date maturityDate;
  @override
  final String status;

  factory _$FixedDepositSummary(
          [void Function(FixedDepositSummaryBuilder)? updates]) =>
      (FixedDepositSummaryBuilder()..update(updates))._build();

  _$FixedDepositSummary._(
      {required this.id,
      required this.accountNo,
      required this.productName,
      required this.accountBalance,
      required this.interestRate,
      required this.maturityDate,
      required this.status})
      : super._();
  @override
  FixedDepositSummary rebuild(
          void Function(FixedDepositSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FixedDepositSummaryBuilder toBuilder() =>
      FixedDepositSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FixedDepositSummary &&
        id == other.id &&
        accountNo == other.accountNo &&
        productName == other.productName &&
        accountBalance == other.accountBalance &&
        interestRate == other.interestRate &&
        maturityDate == other.maturityDate &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, accountNo.hashCode);
    _$hash = $jc(_$hash, productName.hashCode);
    _$hash = $jc(_$hash, accountBalance.hashCode);
    _$hash = $jc(_$hash, interestRate.hashCode);
    _$hash = $jc(_$hash, maturityDate.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FixedDepositSummary')
          ..add('id', id)
          ..add('accountNo', accountNo)
          ..add('productName', productName)
          ..add('accountBalance', accountBalance)
          ..add('interestRate', interestRate)
          ..add('maturityDate', maturityDate)
          ..add('status', status))
        .toString();
  }
}

class FixedDepositSummaryBuilder
    implements Builder<FixedDepositSummary, FixedDepositSummaryBuilder> {
  _$FixedDepositSummary? _$v;

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

  num? _interestRate;
  num? get interestRate => _$this._interestRate;
  set interestRate(num? interestRate) => _$this._interestRate = interestRate;

  Date? _maturityDate;
  Date? get maturityDate => _$this._maturityDate;
  set maturityDate(Date? maturityDate) => _$this._maturityDate = maturityDate;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  FixedDepositSummaryBuilder() {
    FixedDepositSummary._defaults(this);
  }

  FixedDepositSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _accountNo = $v.accountNo;
      _productName = $v.productName;
      _accountBalance = $v.accountBalance;
      _interestRate = $v.interestRate;
      _maturityDate = $v.maturityDate;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FixedDepositSummary other) {
    _$v = other as _$FixedDepositSummary;
  }

  @override
  void update(void Function(FixedDepositSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FixedDepositSummary build() => _build();

  _$FixedDepositSummary _build() {
    final _$result = _$v ??
        _$FixedDepositSummary._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'FixedDepositSummary', 'id'),
          accountNo: BuiltValueNullFieldError.checkNotNull(
              accountNo, r'FixedDepositSummary', 'accountNo'),
          productName: BuiltValueNullFieldError.checkNotNull(
              productName, r'FixedDepositSummary', 'productName'),
          accountBalance: BuiltValueNullFieldError.checkNotNull(
              accountBalance, r'FixedDepositSummary', 'accountBalance'),
          interestRate: BuiltValueNullFieldError.checkNotNull(
              interestRate, r'FixedDepositSummary', 'interestRate'),
          maturityDate: BuiltValueNullFieldError.checkNotNull(
              maturityDate, r'FixedDepositSummary', 'maturityDate'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'FixedDepositSummary', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
