// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_approve_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoanApproveRequest extends LoanApproveRequest {
  @override
  final Date approvedOnDate;
  @override
  final String? note;

  factory _$LoanApproveRequest(
          [void Function(LoanApproveRequestBuilder)? updates]) =>
      (LoanApproveRequestBuilder()..update(updates))._build();

  _$LoanApproveRequest._({required this.approvedOnDate, this.note}) : super._();
  @override
  LoanApproveRequest rebuild(
          void Function(LoanApproveRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoanApproveRequestBuilder toBuilder() =>
      LoanApproveRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoanApproveRequest &&
        approvedOnDate == other.approvedOnDate &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, approvedOnDate.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoanApproveRequest')
          ..add('approvedOnDate', approvedOnDate)
          ..add('note', note))
        .toString();
  }
}

class LoanApproveRequestBuilder
    implements Builder<LoanApproveRequest, LoanApproveRequestBuilder> {
  _$LoanApproveRequest? _$v;

  Date? _approvedOnDate;
  Date? get approvedOnDate => _$this._approvedOnDate;
  set approvedOnDate(Date? approvedOnDate) =>
      _$this._approvedOnDate = approvedOnDate;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  LoanApproveRequestBuilder() {
    LoanApproveRequest._defaults(this);
  }

  LoanApproveRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _approvedOnDate = $v.approvedOnDate;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoanApproveRequest other) {
    _$v = other as _$LoanApproveRequest;
  }

  @override
  void update(void Function(LoanApproveRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoanApproveRequest build() => _build();

  _$LoanApproveRequest _build() {
    final _$result = _$v ??
        _$LoanApproveRequest._(
          approvedOnDate: BuiltValueNullFieldError.checkNotNull(
              approvedOnDate, r'LoanApproveRequest', 'approvedOnDate'),
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
