// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

abstract class LoanSummaryBuilder {
  void replace(LoanSummary other);
  void update(void Function(LoanSummaryBuilder) updates);
  int? get loanId;
  set loanId(int? loanId);

  String? get externalId;
  set externalId(String? externalId);

  String? get productName;
  set productName(String? productName);

  num? get principal;
  set principal(num? principal);

  num? get interestRate;
  set interestRate(num? interestRate);

  int? get termMonths;
  set termMonths(int? termMonths);

  String? get status;
  set status(String? status);

  bool? get inArrears;
  set inArrears(bool? inArrears);

  int? get overdueDays;
  set overdueDays(int? overdueDays);

  Date? get overdueSinceDate;
  set overdueSinceDate(Date? overdueSinceDate);

  num? get totalOverdue;
  set totalOverdue(num? totalOverdue);

  String? get delinquencyClassification;
  set delinquencyClassification(String? delinquencyClassification);
}

class _$$LoanSummary extends $LoanSummary {
  @override
  final int loanId;
  @override
  final String externalId;
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
  final bool inArrears;
  @override
  final int overdueDays;
  @override
  final Date? overdueSinceDate;
  @override
  final num totalOverdue;
  @override
  final String? delinquencyClassification;

  factory _$$LoanSummary([void Function($LoanSummaryBuilder)? updates]) =>
      ($LoanSummaryBuilder()..update(updates))._build();

  _$$LoanSummary._(
      {required this.loanId,
      required this.externalId,
      required this.productName,
      required this.principal,
      required this.interestRate,
      required this.termMonths,
      required this.status,
      required this.inArrears,
      required this.overdueDays,
      this.overdueSinceDate,
      required this.totalOverdue,
      this.delinquencyClassification})
      : super._();
  @override
  $LoanSummary rebuild(void Function($LoanSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  $LoanSummaryBuilder toBuilder() => $LoanSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is $LoanSummary &&
        loanId == other.loanId &&
        externalId == other.externalId &&
        productName == other.productName &&
        principal == other.principal &&
        interestRate == other.interestRate &&
        termMonths == other.termMonths &&
        status == other.status &&
        inArrears == other.inArrears &&
        overdueDays == other.overdueDays &&
        overdueSinceDate == other.overdueSinceDate &&
        totalOverdue == other.totalOverdue &&
        delinquencyClassification == other.delinquencyClassification;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, loanId.hashCode);
    _$hash = $jc(_$hash, externalId.hashCode);
    _$hash = $jc(_$hash, productName.hashCode);
    _$hash = $jc(_$hash, principal.hashCode);
    _$hash = $jc(_$hash, interestRate.hashCode);
    _$hash = $jc(_$hash, termMonths.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, inArrears.hashCode);
    _$hash = $jc(_$hash, overdueDays.hashCode);
    _$hash = $jc(_$hash, overdueSinceDate.hashCode);
    _$hash = $jc(_$hash, totalOverdue.hashCode);
    _$hash = $jc(_$hash, delinquencyClassification.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'$LoanSummary')
          ..add('loanId', loanId)
          ..add('externalId', externalId)
          ..add('productName', productName)
          ..add('principal', principal)
          ..add('interestRate', interestRate)
          ..add('termMonths', termMonths)
          ..add('status', status)
          ..add('inArrears', inArrears)
          ..add('overdueDays', overdueDays)
          ..add('overdueSinceDate', overdueSinceDate)
          ..add('totalOverdue', totalOverdue)
          ..add('delinquencyClassification', delinquencyClassification))
        .toString();
  }
}

class $LoanSummaryBuilder
    implements Builder<$LoanSummary, $LoanSummaryBuilder>, LoanSummaryBuilder {
  _$$LoanSummary? _$v;

  int? _loanId;
  int? get loanId => _$this._loanId;
  set loanId(covariant int? loanId) => _$this._loanId = loanId;

  String? _externalId;
  String? get externalId => _$this._externalId;
  set externalId(covariant String? externalId) =>
      _$this._externalId = externalId;

  String? _productName;
  String? get productName => _$this._productName;
  set productName(covariant String? productName) =>
      _$this._productName = productName;

  num? _principal;
  num? get principal => _$this._principal;
  set principal(covariant num? principal) => _$this._principal = principal;

  num? _interestRate;
  num? get interestRate => _$this._interestRate;
  set interestRate(covariant num? interestRate) =>
      _$this._interestRate = interestRate;

  int? _termMonths;
  int? get termMonths => _$this._termMonths;
  set termMonths(covariant int? termMonths) => _$this._termMonths = termMonths;

  String? _status;
  String? get status => _$this._status;
  set status(covariant String? status) => _$this._status = status;

  bool? _inArrears;
  bool? get inArrears => _$this._inArrears;
  set inArrears(covariant bool? inArrears) => _$this._inArrears = inArrears;

  int? _overdueDays;
  int? get overdueDays => _$this._overdueDays;
  set overdueDays(covariant int? overdueDays) =>
      _$this._overdueDays = overdueDays;

  Date? _overdueSinceDate;
  Date? get overdueSinceDate => _$this._overdueSinceDate;
  set overdueSinceDate(covariant Date? overdueSinceDate) =>
      _$this._overdueSinceDate = overdueSinceDate;

  num? _totalOverdue;
  num? get totalOverdue => _$this._totalOverdue;
  set totalOverdue(covariant num? totalOverdue) =>
      _$this._totalOverdue = totalOverdue;

  String? _delinquencyClassification;
  String? get delinquencyClassification => _$this._delinquencyClassification;
  set delinquencyClassification(covariant String? delinquencyClassification) =>
      _$this._delinquencyClassification = delinquencyClassification;

  $LoanSummaryBuilder() {
    $LoanSummary._defaults(this);
  }

  $LoanSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _loanId = $v.loanId;
      _externalId = $v.externalId;
      _productName = $v.productName;
      _principal = $v.principal;
      _interestRate = $v.interestRate;
      _termMonths = $v.termMonths;
      _status = $v.status;
      _inArrears = $v.inArrears;
      _overdueDays = $v.overdueDays;
      _overdueSinceDate = $v.overdueSinceDate;
      _totalOverdue = $v.totalOverdue;
      _delinquencyClassification = $v.delinquencyClassification;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant $LoanSummary other) {
    _$v = other as _$$LoanSummary;
  }

  @override
  void update(void Function($LoanSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  $LoanSummary build() => _build();

  _$$LoanSummary _build() {
    final _$result = _$v ??
        _$$LoanSummary._(
          loanId: BuiltValueNullFieldError.checkNotNull(
              loanId, r'$LoanSummary', 'loanId'),
          externalId: BuiltValueNullFieldError.checkNotNull(
              externalId, r'$LoanSummary', 'externalId'),
          productName: BuiltValueNullFieldError.checkNotNull(
              productName, r'$LoanSummary', 'productName'),
          principal: BuiltValueNullFieldError.checkNotNull(
              principal, r'$LoanSummary', 'principal'),
          interestRate: BuiltValueNullFieldError.checkNotNull(
              interestRate, r'$LoanSummary', 'interestRate'),
          termMonths: BuiltValueNullFieldError.checkNotNull(
              termMonths, r'$LoanSummary', 'termMonths'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'$LoanSummary', 'status'),
          inArrears: BuiltValueNullFieldError.checkNotNull(
              inArrears, r'$LoanSummary', 'inArrears'),
          overdueDays: BuiltValueNullFieldError.checkNotNull(
              overdueDays, r'$LoanSummary', 'overdueDays'),
          overdueSinceDate: overdueSinceDate,
          totalOverdue: BuiltValueNullFieldError.checkNotNull(
              totalOverdue, r'$LoanSummary', 'totalOverdue'),
          delinquencyClassification: delinquencyClassification,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
