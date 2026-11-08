// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_disburse_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoanDisburseRequest extends LoanDisburseRequest {
  @override
  final Date actualDisbursementDate;
  @override
  final String? note;

  factory _$LoanDisburseRequest(
          [void Function(LoanDisburseRequestBuilder)? updates]) =>
      (LoanDisburseRequestBuilder()..update(updates))._build();

  _$LoanDisburseRequest._({required this.actualDisbursementDate, this.note})
      : super._();
  @override
  LoanDisburseRequest rebuild(
          void Function(LoanDisburseRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoanDisburseRequestBuilder toBuilder() =>
      LoanDisburseRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoanDisburseRequest &&
        actualDisbursementDate == other.actualDisbursementDate &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, actualDisbursementDate.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoanDisburseRequest')
          ..add('actualDisbursementDate', actualDisbursementDate)
          ..add('note', note))
        .toString();
  }
}

class LoanDisburseRequestBuilder
    implements Builder<LoanDisburseRequest, LoanDisburseRequestBuilder> {
  _$LoanDisburseRequest? _$v;

  Date? _actualDisbursementDate;
  Date? get actualDisbursementDate => _$this._actualDisbursementDate;
  set actualDisbursementDate(Date? actualDisbursementDate) =>
      _$this._actualDisbursementDate = actualDisbursementDate;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  LoanDisburseRequestBuilder() {
    LoanDisburseRequest._defaults(this);
  }

  LoanDisburseRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _actualDisbursementDate = $v.actualDisbursementDate;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoanDisburseRequest other) {
    _$v = other as _$LoanDisburseRequest;
  }

  @override
  void update(void Function(LoanDisburseRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoanDisburseRequest build() => _build();

  _$LoanDisburseRequest _build() {
    final _$result = _$v ??
        _$LoanDisburseRequest._(
          actualDisbursementDate: BuiltValueNullFieldError.checkNotNull(
              actualDisbursementDate,
              r'LoanDisburseRequest',
              'actualDisbursementDate'),
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
