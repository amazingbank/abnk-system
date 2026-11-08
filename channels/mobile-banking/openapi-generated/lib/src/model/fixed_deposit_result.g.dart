// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fixed_deposit_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FixedDepositResult extends FixedDepositResult {
  @override
  final int accountId;
  @override
  final Date maturityDate;

  factory _$FixedDepositResult(
          [void Function(FixedDepositResultBuilder)? updates]) =>
      (FixedDepositResultBuilder()..update(updates))._build();

  _$FixedDepositResult._({required this.accountId, required this.maturityDate})
      : super._();
  @override
  FixedDepositResult rebuild(
          void Function(FixedDepositResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FixedDepositResultBuilder toBuilder() =>
      FixedDepositResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FixedDepositResult &&
        accountId == other.accountId &&
        maturityDate == other.maturityDate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jc(_$hash, maturityDate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FixedDepositResult')
          ..add('accountId', accountId)
          ..add('maturityDate', maturityDate))
        .toString();
  }
}

class FixedDepositResultBuilder
    implements Builder<FixedDepositResult, FixedDepositResultBuilder> {
  _$FixedDepositResult? _$v;

  int? _accountId;
  int? get accountId => _$this._accountId;
  set accountId(int? accountId) => _$this._accountId = accountId;

  Date? _maturityDate;
  Date? get maturityDate => _$this._maturityDate;
  set maturityDate(Date? maturityDate) => _$this._maturityDate = maturityDate;

  FixedDepositResultBuilder() {
    FixedDepositResult._defaults(this);
  }

  FixedDepositResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accountId = $v.accountId;
      _maturityDate = $v.maturityDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FixedDepositResult other) {
    _$v = other as _$FixedDepositResult;
  }

  @override
  void update(void Function(FixedDepositResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FixedDepositResult build() => _build();

  _$FixedDepositResult _build() {
    final _$result = _$v ??
        _$FixedDepositResult._(
          accountId: BuiltValueNullFieldError.checkNotNull(
              accountId, r'FixedDepositResult', 'accountId'),
          maturityDate: BuiltValueNullFieldError.checkNotNull(
              maturityDate, r'FixedDepositResult', 'maturityDate'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
