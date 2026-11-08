// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoanDetail extends LoanDetail {
  @override
  final int loanId;
  @override
  final String productName;
  @override
  final num principal;
  @override
  final num interestRate;
  @override
  final int termMonths;
  @override
  final String status;
  @override
  final Date submittedOnDate;
  @override
  final Date? disbursedOnDate;
  @override
  final num? totalOutstanding;

  factory _$LoanDetail([void Function(LoanDetailBuilder)? updates]) =>
      (LoanDetailBuilder()..update(updates))._build();

  _$LoanDetail._(
      {required this.loanId,
      required this.productName,
      required this.principal,
      required this.interestRate,
      required this.termMonths,
      required this.status,
      required this.submittedOnDate,
      this.disbursedOnDate,
      this.totalOutstanding})
      : super._();
  @override
  LoanDetail rebuild(void Function(LoanDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoanDetailBuilder toBuilder() => LoanDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoanDetail &&
        loanId == other.loanId &&
        productName == other.productName &&
        principal == other.principal &&
        interestRate == other.interestRate &&
        termMonths == other.termMonths &&
        status == other.status &&
        submittedOnDate == other.submittedOnDate &&
        disbursedOnDate == other.disbursedOnDate &&
        totalOutstanding == other.totalOutstanding;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, loanId.hashCode);
    _$hash = $jc(_$hash, productName.hashCode);
    _$hash = $jc(_$hash, principal.hashCode);
    _$hash = $jc(_$hash, interestRate.hashCode);
    _$hash = $jc(_$hash, termMonths.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, submittedOnDate.hashCode);
    _$hash = $jc(_$hash, disbursedOnDate.hashCode);
    _$hash = $jc(_$hash, totalOutstanding.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoanDetail')
          ..add('loanId', loanId)
          ..add('productName', productName)
          ..add('principal', principal)
          ..add('interestRate', interestRate)
          ..add('termMonths', termMonths)
          ..add('status', status)
          ..add('submittedOnDate', submittedOnDate)
          ..add('disbursedOnDate', disbursedOnDate)
          ..add('totalOutstanding', totalOutstanding))
        .toString();
  }
}

class LoanDetailBuilder implements Builder<LoanDetail, LoanDetailBuilder> {
  _$LoanDetail? _$v;

  int? _loanId;
  int? get loanId => _$this._loanId;
  set loanId(int? loanId) => _$this._loanId = loanId;

  String? _productName;
  String? get productName => _$this._productName;
  set productName(String? productName) => _$this._productName = productName;

  num? _principal;
  num? get principal => _$this._principal;
  set principal(num? principal) => _$this._principal = principal;

  num? _interestRate;
  num? get interestRate => _$this._interestRate;
  set interestRate(num? interestRate) => _$this._interestRate = interestRate;

  int? _termMonths;
  int? get termMonths => _$this._termMonths;
  set termMonths(int? termMonths) => _$this._termMonths = termMonths;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  Date? _submittedOnDate;
  Date? get submittedOnDate => _$this._submittedOnDate;
  set submittedOnDate(Date? submittedOnDate) =>
      _$this._submittedOnDate = submittedOnDate;

  Date? _disbursedOnDate;
  Date? get disbursedOnDate => _$this._disbursedOnDate;
  set disbursedOnDate(Date? disbursedOnDate) =>
      _$this._disbursedOnDate = disbursedOnDate;

  num? _totalOutstanding;
  num? get totalOutstanding => _$this._totalOutstanding;
  set totalOutstanding(num? totalOutstanding) =>
      _$this._totalOutstanding = totalOutstanding;

  LoanDetailBuilder() {
    LoanDetail._defaults(this);
  }

  LoanDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _loanId = $v.loanId;
      _productName = $v.productName;
      _principal = $v.principal;
      _interestRate = $v.interestRate;
      _termMonths = $v.termMonths;
      _status = $v.status;
      _submittedOnDate = $v.submittedOnDate;
      _disbursedOnDate = $v.disbursedOnDate;
      _totalOutstanding = $v.totalOutstanding;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoanDetail other) {
    _$v = other as _$LoanDetail;
  }

  @override
  void update(void Function(LoanDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoanDetail build() => _build();

  _$LoanDetail _build() {
    final _$result = _$v ??
        _$LoanDetail._(
          loanId: BuiltValueNullFieldError.checkNotNull(
              loanId, r'LoanDetail', 'loanId'),
          productName: BuiltValueNullFieldError.checkNotNull(
              productName, r'LoanDetail', 'productName'),
          principal: BuiltValueNullFieldError.checkNotNull(
              principal, r'LoanDetail', 'principal'),
          interestRate: BuiltValueNullFieldError.checkNotNull(
              interestRate, r'LoanDetail', 'interestRate'),
          termMonths: BuiltValueNullFieldError.checkNotNull(
              termMonths, r'LoanDetail', 'termMonths'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'LoanDetail', 'status'),
          submittedOnDate: BuiltValueNullFieldError.checkNotNull(
              submittedOnDate, r'LoanDetail', 'submittedOnDate'),
          disbursedOnDate: disbursedOnDate,
          totalOutstanding: totalOutstanding,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
