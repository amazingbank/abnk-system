// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_command_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoanCommandResult extends LoanCommandResult {
  @override
  final int loanId;
  @override
  final String status;
  @override
  final Date? processedOnDate;

  factory _$LoanCommandResult(
          [void Function(LoanCommandResultBuilder)? updates]) =>
      (LoanCommandResultBuilder()..update(updates))._build();

  _$LoanCommandResult._(
      {required this.loanId, required this.status, this.processedOnDate})
      : super._();
  @override
  LoanCommandResult rebuild(void Function(LoanCommandResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoanCommandResultBuilder toBuilder() =>
      LoanCommandResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoanCommandResult &&
        loanId == other.loanId &&
        status == other.status &&
        processedOnDate == other.processedOnDate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, loanId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, processedOnDate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoanCommandResult')
          ..add('loanId', loanId)
          ..add('status', status)
          ..add('processedOnDate', processedOnDate))
        .toString();
  }
}

class LoanCommandResultBuilder
    implements Builder<LoanCommandResult, LoanCommandResultBuilder> {
  _$LoanCommandResult? _$v;

  int? _loanId;
  int? get loanId => _$this._loanId;
  set loanId(int? loanId) => _$this._loanId = loanId;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  Date? _processedOnDate;
  Date? get processedOnDate => _$this._processedOnDate;
  set processedOnDate(Date? processedOnDate) =>
      _$this._processedOnDate = processedOnDate;

  LoanCommandResultBuilder() {
    LoanCommandResult._defaults(this);
  }

  LoanCommandResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _loanId = $v.loanId;
      _status = $v.status;
      _processedOnDate = $v.processedOnDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoanCommandResult other) {
    _$v = other as _$LoanCommandResult;
  }

  @override
  void update(void Function(LoanCommandResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoanCommandResult build() => _build();

  _$LoanCommandResult _build() {
    final _$result = _$v ??
        _$LoanCommandResult._(
          loanId: BuiltValueNullFieldError.checkNotNull(
              loanId, r'LoanCommandResult', 'loanId'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'LoanCommandResult', 'status'),
          processedOnDate: processedOnDate,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
