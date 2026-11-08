// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_application_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoanApplicationRequest extends LoanApplicationRequest {
  @override
  final int productId;
  @override
  final num principal;
  @override
  final int termMonths;
  @override
  final String? purpose;

  factory _$LoanApplicationRequest(
          [void Function(LoanApplicationRequestBuilder)? updates]) =>
      (LoanApplicationRequestBuilder()..update(updates))._build();

  _$LoanApplicationRequest._(
      {required this.productId,
      required this.principal,
      required this.termMonths,
      this.purpose})
      : super._();
  @override
  LoanApplicationRequest rebuild(
          void Function(LoanApplicationRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoanApplicationRequestBuilder toBuilder() =>
      LoanApplicationRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoanApplicationRequest &&
        productId == other.productId &&
        principal == other.principal &&
        termMonths == other.termMonths &&
        purpose == other.purpose;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, productId.hashCode);
    _$hash = $jc(_$hash, principal.hashCode);
    _$hash = $jc(_$hash, termMonths.hashCode);
    _$hash = $jc(_$hash, purpose.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoanApplicationRequest')
          ..add('productId', productId)
          ..add('principal', principal)
          ..add('termMonths', termMonths)
          ..add('purpose', purpose))
        .toString();
  }
}

class LoanApplicationRequestBuilder
    implements Builder<LoanApplicationRequest, LoanApplicationRequestBuilder> {
  _$LoanApplicationRequest? _$v;

  int? _productId;
  int? get productId => _$this._productId;
  set productId(int? productId) => _$this._productId = productId;

  num? _principal;
  num? get principal => _$this._principal;
  set principal(num? principal) => _$this._principal = principal;

  int? _termMonths;
  int? get termMonths => _$this._termMonths;
  set termMonths(int? termMonths) => _$this._termMonths = termMonths;

  String? _purpose;
  String? get purpose => _$this._purpose;
  set purpose(String? purpose) => _$this._purpose = purpose;

  LoanApplicationRequestBuilder() {
    LoanApplicationRequest._defaults(this);
  }

  LoanApplicationRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _productId = $v.productId;
      _principal = $v.principal;
      _termMonths = $v.termMonths;
      _purpose = $v.purpose;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoanApplicationRequest other) {
    _$v = other as _$LoanApplicationRequest;
  }

  @override
  void update(void Function(LoanApplicationRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoanApplicationRequest build() => _build();

  _$LoanApplicationRequest _build() {
    final _$result = _$v ??
        _$LoanApplicationRequest._(
          productId: BuiltValueNullFieldError.checkNotNull(
              productId, r'LoanApplicationRequest', 'productId'),
          principal: BuiltValueNullFieldError.checkNotNull(
              principal, r'LoanApplicationRequest', 'principal'),
          termMonths: BuiltValueNullFieldError.checkNotNull(
              termMonths, r'LoanApplicationRequest', 'termMonths'),
          purpose: purpose,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
