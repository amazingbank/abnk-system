// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fixed_deposit_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FixedDepositRequest extends FixedDepositRequest {
  @override
  final int productId;
  @override
  final int sourceAccountId;
  @override
  final num amount;

  factory _$FixedDepositRequest(
          [void Function(FixedDepositRequestBuilder)? updates]) =>
      (FixedDepositRequestBuilder()..update(updates))._build();

  _$FixedDepositRequest._(
      {required this.productId,
      required this.sourceAccountId,
      required this.amount})
      : super._();
  @override
  FixedDepositRequest rebuild(
          void Function(FixedDepositRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FixedDepositRequestBuilder toBuilder() =>
      FixedDepositRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FixedDepositRequest &&
        productId == other.productId &&
        sourceAccountId == other.sourceAccountId &&
        amount == other.amount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, productId.hashCode);
    _$hash = $jc(_$hash, sourceAccountId.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FixedDepositRequest')
          ..add('productId', productId)
          ..add('sourceAccountId', sourceAccountId)
          ..add('amount', amount))
        .toString();
  }
}

class FixedDepositRequestBuilder
    implements Builder<FixedDepositRequest, FixedDepositRequestBuilder> {
  _$FixedDepositRequest? _$v;

  int? _productId;
  int? get productId => _$this._productId;
  set productId(int? productId) => _$this._productId = productId;

  int? _sourceAccountId;
  int? get sourceAccountId => _$this._sourceAccountId;
  set sourceAccountId(int? sourceAccountId) =>
      _$this._sourceAccountId = sourceAccountId;

  num? _amount;
  num? get amount => _$this._amount;
  set amount(num? amount) => _$this._amount = amount;

  FixedDepositRequestBuilder() {
    FixedDepositRequest._defaults(this);
  }

  FixedDepositRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _productId = $v.productId;
      _sourceAccountId = $v.sourceAccountId;
      _amount = $v.amount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FixedDepositRequest other) {
    _$v = other as _$FixedDepositRequest;
  }

  @override
  void update(void Function(FixedDepositRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FixedDepositRequest build() => _build();

  _$FixedDepositRequest _build() {
    final _$result = _$v ??
        _$FixedDepositRequest._(
          productId: BuiltValueNullFieldError.checkNotNull(
              productId, r'FixedDepositRequest', 'productId'),
          sourceAccountId: BuiltValueNullFieldError.checkNotNull(
              sourceAccountId, r'FixedDepositRequest', 'sourceAccountId'),
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'FixedDepositRequest', 'amount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
