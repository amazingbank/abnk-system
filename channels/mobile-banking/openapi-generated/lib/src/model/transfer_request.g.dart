// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TransferRequest extends TransferRequest {
  @override
  final int toAccountId;
  @override
  final num amount;
  @override
  final String externalId;
  @override
  final String? note;

  factory _$TransferRequest([void Function(TransferRequestBuilder)? updates]) =>
      (TransferRequestBuilder()..update(updates))._build();

  _$TransferRequest._(
      {required this.toAccountId,
      required this.amount,
      required this.externalId,
      this.note})
      : super._();
  @override
  TransferRequest rebuild(void Function(TransferRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TransferRequestBuilder toBuilder() => TransferRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TransferRequest &&
        toAccountId == other.toAccountId &&
        amount == other.amount &&
        externalId == other.externalId &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, toAccountId.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, externalId.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TransferRequest')
          ..add('toAccountId', toAccountId)
          ..add('amount', amount)
          ..add('externalId', externalId)
          ..add('note', note))
        .toString();
  }
}

class TransferRequestBuilder
    implements Builder<TransferRequest, TransferRequestBuilder> {
  _$TransferRequest? _$v;

  int? _toAccountId;
  int? get toAccountId => _$this._toAccountId;
  set toAccountId(int? toAccountId) => _$this._toAccountId = toAccountId;

  num? _amount;
  num? get amount => _$this._amount;
  set amount(num? amount) => _$this._amount = amount;

  String? _externalId;
  String? get externalId => _$this._externalId;
  set externalId(String? externalId) => _$this._externalId = externalId;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  TransferRequestBuilder() {
    TransferRequest._defaults(this);
  }

  TransferRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _toAccountId = $v.toAccountId;
      _amount = $v.amount;
      _externalId = $v.externalId;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TransferRequest other) {
    _$v = other as _$TransferRequest;
  }

  @override
  void update(void Function(TransferRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TransferRequest build() => _build();

  _$TransferRequest _build() {
    final _$result = _$v ??
        _$TransferRequest._(
          toAccountId: BuiltValueNullFieldError.checkNotNull(
              toAccountId, r'TransferRequest', 'toAccountId'),
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'TransferRequest', 'amount'),
          externalId: BuiltValueNullFieldError.checkNotNull(
              externalId, r'TransferRequest', 'externalId'),
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
