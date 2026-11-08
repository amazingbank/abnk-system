// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_ops_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoanOpsItem extends LoanOpsItem {
  @override
  final int clientId;
  @override
  final String clientName;
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

  factory _$LoanOpsItem([void Function(LoanOpsItemBuilder)? updates]) =>
      (LoanOpsItemBuilder()..update(updates))._build();

  _$LoanOpsItem._(
      {required this.clientId,
      required this.clientName,
      required this.loanId,
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
  LoanOpsItem rebuild(void Function(LoanOpsItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoanOpsItemBuilder toBuilder() => LoanOpsItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoanOpsItem &&
        clientId == other.clientId &&
        clientName == other.clientName &&
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
    _$hash = $jc(_$hash, clientId.hashCode);
    _$hash = $jc(_$hash, clientName.hashCode);
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
    return (newBuiltValueToStringHelper(r'LoanOpsItem')
          ..add('clientId', clientId)
          ..add('clientName', clientName)
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

class LoanOpsItemBuilder
    implements Builder<LoanOpsItem, LoanOpsItemBuilder>, LoanSummaryBuilder {
  _$LoanOpsItem? _$v;

  int? _clientId;
  int? get clientId => _$this._clientId;
  set clientId(covariant int? clientId) => _$this._clientId = clientId;

  String? _clientName;
  String? get clientName => _$this._clientName;
  set clientName(covariant String? clientName) =>
      _$this._clientName = clientName;

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

  LoanOpsItemBuilder() {
    LoanOpsItem._defaults(this);
  }

  LoanOpsItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _clientId = $v.clientId;
      _clientName = $v.clientName;
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
  void replace(covariant LoanOpsItem other) {
    _$v = other as _$LoanOpsItem;
  }

  @override
  void update(void Function(LoanOpsItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoanOpsItem build() => _build();

  _$LoanOpsItem _build() {
    final _$result = _$v ??
        _$LoanOpsItem._(
          clientId: BuiltValueNullFieldError.checkNotNull(
              clientId, r'LoanOpsItem', 'clientId'),
          clientName: BuiltValueNullFieldError.checkNotNull(
              clientName, r'LoanOpsItem', 'clientName'),
          loanId: BuiltValueNullFieldError.checkNotNull(
              loanId, r'LoanOpsItem', 'loanId'),
          externalId: BuiltValueNullFieldError.checkNotNull(
              externalId, r'LoanOpsItem', 'externalId'),
          productName: BuiltValueNullFieldError.checkNotNull(
              productName, r'LoanOpsItem', 'productName'),
          principal: BuiltValueNullFieldError.checkNotNull(
              principal, r'LoanOpsItem', 'principal'),
          interestRate: BuiltValueNullFieldError.checkNotNull(
              interestRate, r'LoanOpsItem', 'interestRate'),
          termMonths: BuiltValueNullFieldError.checkNotNull(
              termMonths, r'LoanOpsItem', 'termMonths'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'LoanOpsItem', 'status'),
          inArrears: BuiltValueNullFieldError.checkNotNull(
              inArrears, r'LoanOpsItem', 'inArrears'),
          overdueDays: BuiltValueNullFieldError.checkNotNull(
              overdueDays, r'LoanOpsItem', 'overdueDays'),
          overdueSinceDate: overdueSinceDate,
          totalOverdue: BuiltValueNullFieldError.checkNotNull(
              totalOverdue, r'LoanOpsItem', 'totalOverdue'),
          delinquencyClassification: delinquencyClassification,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
