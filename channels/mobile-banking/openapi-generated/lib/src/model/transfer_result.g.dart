// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TransferResult extends TransferResult {
  @override
  final int transactionId;
  @override
  final num newSourceBalance;

  factory _$TransferResult([void Function(TransferResultBuilder)? updates]) =>
      (TransferResultBuilder()..update(updates))._build();

  _$TransferResult._(
      {required this.transactionId, required this.newSourceBalance})
      : super._();
  @override
  TransferResult rebuild(void Function(TransferResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TransferResultBuilder toBuilder() => TransferResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TransferResult &&
        transactionId == other.transactionId &&
        newSourceBalance == other.newSourceBalance;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, transactionId.hashCode);
    _$hash = $jc(_$hash, newSourceBalance.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TransferResult')
          ..add('transactionId', transactionId)
          ..add('newSourceBalance', newSourceBalance))
        .toString();
  }
}

class TransferResultBuilder
    implements Builder<TransferResult, TransferResultBuilder> {
  _$TransferResult? _$v;

  int? _transactionId;
  int? get transactionId => _$this._transactionId;
  set transactionId(int? transactionId) =>
      _$this._transactionId = transactionId;

  num? _newSourceBalance;
  num? get newSourceBalance => _$this._newSourceBalance;
  set newSourceBalance(num? newSourceBalance) =>
      _$this._newSourceBalance = newSourceBalance;

  TransferResultBuilder() {
    TransferResult._defaults(this);
  }

  TransferResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _transactionId = $v.transactionId;
      _newSourceBalance = $v.newSourceBalance;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TransferResult other) {
    _$v = other as _$TransferResult;
  }

  @override
  void update(void Function(TransferResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TransferResult build() => _build();

  _$TransferResult _build() {
    final _$result = _$v ??
        _$TransferResult._(
          transactionId: BuiltValueNullFieldError.checkNotNull(
              transactionId, r'TransferResult', 'transactionId'),
          newSourceBalance: BuiltValueNullFieldError.checkNotNull(
              newSourceBalance, r'TransferResult', 'newSourceBalance'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
