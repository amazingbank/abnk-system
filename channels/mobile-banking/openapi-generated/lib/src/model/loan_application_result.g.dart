// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_application_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoanApplicationResult extends LoanApplicationResult {
  @override
  final int loanId;
  @override
  final String status;

  factory _$LoanApplicationResult(
          [void Function(LoanApplicationResultBuilder)? updates]) =>
      (LoanApplicationResultBuilder()..update(updates))._build();

  _$LoanApplicationResult._({required this.loanId, required this.status})
      : super._();
  @override
  LoanApplicationResult rebuild(
          void Function(LoanApplicationResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoanApplicationResultBuilder toBuilder() =>
      LoanApplicationResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoanApplicationResult &&
        loanId == other.loanId &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, loanId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoanApplicationResult')
          ..add('loanId', loanId)
          ..add('status', status))
        .toString();
  }
}

class LoanApplicationResultBuilder
    implements Builder<LoanApplicationResult, LoanApplicationResultBuilder> {
  _$LoanApplicationResult? _$v;

  int? _loanId;
  int? get loanId => _$this._loanId;
  set loanId(int? loanId) => _$this._loanId = loanId;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  LoanApplicationResultBuilder() {
    LoanApplicationResult._defaults(this);
  }

  LoanApplicationResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _loanId = $v.loanId;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoanApplicationResult other) {
    _$v = other as _$LoanApplicationResult;
  }

  @override
  void update(void Function(LoanApplicationResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoanApplicationResult build() => _build();

  _$LoanApplicationResult _build() {
    final _$result = _$v ??
        _$LoanApplicationResult._(
          loanId: BuiltValueNullFieldError.checkNotNull(
              loanId, r'LoanApplicationResult', 'loanId'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'LoanApplicationResult', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
