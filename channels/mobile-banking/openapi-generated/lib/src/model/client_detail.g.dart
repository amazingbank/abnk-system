// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ClientDetailIdentifierStatusEnum
    _$clientDetailIdentifierStatusEnum_VALID =
    const ClientDetailIdentifierStatusEnum._('VALID');
const ClientDetailIdentifierStatusEnum
    _$clientDetailIdentifierStatusEnum_EXPIRED =
    const ClientDetailIdentifierStatusEnum._('EXPIRED');

ClientDetailIdentifierStatusEnum _$clientDetailIdentifierStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'VALID':
      return _$clientDetailIdentifierStatusEnum_VALID;
    case 'EXPIRED':
      return _$clientDetailIdentifierStatusEnum_EXPIRED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ClientDetailIdentifierStatusEnum>
    _$clientDetailIdentifierStatusEnumValues = BuiltSet<
        ClientDetailIdentifierStatusEnum>(const <ClientDetailIdentifierStatusEnum>[
  _$clientDetailIdentifierStatusEnum_VALID,
  _$clientDetailIdentifierStatusEnum_EXPIRED,
]);

Serializer<ClientDetailIdentifierStatusEnum>
    _$clientDetailIdentifierStatusEnumSerializer =
    _$ClientDetailIdentifierStatusEnumSerializer();

class _$ClientDetailIdentifierStatusEnumSerializer
    implements PrimitiveSerializer<ClientDetailIdentifierStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VALID': 'VALID',
    'EXPIRED': 'EXPIRED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VALID': 'VALID',
    'EXPIRED': 'EXPIRED',
  };

  @override
  final Iterable<Type> types = const <Type>[ClientDetailIdentifierStatusEnum];
  @override
  final String wireName = 'ClientDetailIdentifierStatusEnum';

  @override
  Object serialize(
          Serializers serializers, ClientDetailIdentifierStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ClientDetailIdentifierStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ClientDetailIdentifierStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ClientDetail extends ClientDetail {
  @override
  final int clientId;
  @override
  final String externalId;
  @override
  final String displayName;
  @override
  final String mobileNo;
  @override
  final String officeName;
  @override
  final String status;
  @override
  final ClientDetailIdentifierStatusEnum? identifierStatus;
  @override
  final Date? identifierExpiryDate;
  @override
  final String firstname;
  @override
  final String lastname;
  @override
  final String emailAddress;
  @override
  final ClientIdentifier? identifier;
  @override
  final BuiltList<SavingsAccountSummary> savingsAccounts;
  @override
  final BuiltList<FixedDepositSummary> fixedDepositAccounts;
  @override
  final LoanSummary? loan;

  factory _$ClientDetail([void Function(ClientDetailBuilder)? updates]) =>
      (ClientDetailBuilder()..update(updates))._build();

  _$ClientDetail._(
      {required this.clientId,
      required this.externalId,
      required this.displayName,
      required this.mobileNo,
      required this.officeName,
      required this.status,
      this.identifierStatus,
      this.identifierExpiryDate,
      required this.firstname,
      required this.lastname,
      required this.emailAddress,
      this.identifier,
      required this.savingsAccounts,
      required this.fixedDepositAccounts,
      this.loan})
      : super._();
  @override
  ClientDetail rebuild(void Function(ClientDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ClientDetailBuilder toBuilder() => ClientDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ClientDetail &&
        clientId == other.clientId &&
        externalId == other.externalId &&
        displayName == other.displayName &&
        mobileNo == other.mobileNo &&
        officeName == other.officeName &&
        status == other.status &&
        identifierStatus == other.identifierStatus &&
        identifierExpiryDate == other.identifierExpiryDate &&
        firstname == other.firstname &&
        lastname == other.lastname &&
        emailAddress == other.emailAddress &&
        identifier == other.identifier &&
        savingsAccounts == other.savingsAccounts &&
        fixedDepositAccounts == other.fixedDepositAccounts &&
        loan == other.loan;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, clientId.hashCode);
    _$hash = $jc(_$hash, externalId.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, mobileNo.hashCode);
    _$hash = $jc(_$hash, officeName.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, identifierStatus.hashCode);
    _$hash = $jc(_$hash, identifierExpiryDate.hashCode);
    _$hash = $jc(_$hash, firstname.hashCode);
    _$hash = $jc(_$hash, lastname.hashCode);
    _$hash = $jc(_$hash, emailAddress.hashCode);
    _$hash = $jc(_$hash, identifier.hashCode);
    _$hash = $jc(_$hash, savingsAccounts.hashCode);
    _$hash = $jc(_$hash, fixedDepositAccounts.hashCode);
    _$hash = $jc(_$hash, loan.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ClientDetail')
          ..add('clientId', clientId)
          ..add('externalId', externalId)
          ..add('displayName', displayName)
          ..add('mobileNo', mobileNo)
          ..add('officeName', officeName)
          ..add('status', status)
          ..add('identifierStatus', identifierStatus)
          ..add('identifierExpiryDate', identifierExpiryDate)
          ..add('firstname', firstname)
          ..add('lastname', lastname)
          ..add('emailAddress', emailAddress)
          ..add('identifier', identifier)
          ..add('savingsAccounts', savingsAccounts)
          ..add('fixedDepositAccounts', fixedDepositAccounts)
          ..add('loan', loan))
        .toString();
  }
}

class ClientDetailBuilder
    implements Builder<ClientDetail, ClientDetailBuilder> {
  _$ClientDetail? _$v;

  int? _clientId;
  int? get clientId => _$this._clientId;
  set clientId(int? clientId) => _$this._clientId = clientId;

  String? _externalId;
  String? get externalId => _$this._externalId;
  set externalId(String? externalId) => _$this._externalId = externalId;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _mobileNo;
  String? get mobileNo => _$this._mobileNo;
  set mobileNo(String? mobileNo) => _$this._mobileNo = mobileNo;

  String? _officeName;
  String? get officeName => _$this._officeName;
  set officeName(String? officeName) => _$this._officeName = officeName;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  ClientDetailIdentifierStatusEnum? _identifierStatus;
  ClientDetailIdentifierStatusEnum? get identifierStatus =>
      _$this._identifierStatus;
  set identifierStatus(ClientDetailIdentifierStatusEnum? identifierStatus) =>
      _$this._identifierStatus = identifierStatus;

  Date? _identifierExpiryDate;
  Date? get identifierExpiryDate => _$this._identifierExpiryDate;
  set identifierExpiryDate(Date? identifierExpiryDate) =>
      _$this._identifierExpiryDate = identifierExpiryDate;

  String? _firstname;
  String? get firstname => _$this._firstname;
  set firstname(String? firstname) => _$this._firstname = firstname;

  String? _lastname;
  String? get lastname => _$this._lastname;
  set lastname(String? lastname) => _$this._lastname = lastname;

  String? _emailAddress;
  String? get emailAddress => _$this._emailAddress;
  set emailAddress(String? emailAddress) => _$this._emailAddress = emailAddress;

  ClientIdentifierBuilder? _identifier;
  ClientIdentifierBuilder get identifier =>
      _$this._identifier ??= ClientIdentifierBuilder();
  set identifier(ClientIdentifierBuilder? identifier) =>
      _$this._identifier = identifier;

  ListBuilder<SavingsAccountSummary>? _savingsAccounts;
  ListBuilder<SavingsAccountSummary> get savingsAccounts =>
      _$this._savingsAccounts ??= ListBuilder<SavingsAccountSummary>();
  set savingsAccounts(ListBuilder<SavingsAccountSummary>? savingsAccounts) =>
      _$this._savingsAccounts = savingsAccounts;

  ListBuilder<FixedDepositSummary>? _fixedDepositAccounts;
  ListBuilder<FixedDepositSummary> get fixedDepositAccounts =>
      _$this._fixedDepositAccounts ??= ListBuilder<FixedDepositSummary>();
  set fixedDepositAccounts(
          ListBuilder<FixedDepositSummary>? fixedDepositAccounts) =>
      _$this._fixedDepositAccounts = fixedDepositAccounts;

  LoanSummary? _loan;
  LoanSummary? get loan => _$this._loan;
  set loan(LoanSummary? loan) => _$this._loan = loan;

  ClientDetailBuilder() {
    ClientDetail._defaults(this);
  }

  ClientDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _clientId = $v.clientId;
      _externalId = $v.externalId;
      _displayName = $v.displayName;
      _mobileNo = $v.mobileNo;
      _officeName = $v.officeName;
      _status = $v.status;
      _identifierStatus = $v.identifierStatus;
      _identifierExpiryDate = $v.identifierExpiryDate;
      _firstname = $v.firstname;
      _lastname = $v.lastname;
      _emailAddress = $v.emailAddress;
      _identifier = $v.identifier?.toBuilder();
      _savingsAccounts = $v.savingsAccounts.toBuilder();
      _fixedDepositAccounts = $v.fixedDepositAccounts.toBuilder();
      _loan = $v.loan;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ClientDetail other) {
    _$v = other as _$ClientDetail;
  }

  @override
  void update(void Function(ClientDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ClientDetail build() => _build();

  _$ClientDetail _build() {
    _$ClientDetail _$result;
    try {
      _$result = _$v ??
          _$ClientDetail._(
            clientId: BuiltValueNullFieldError.checkNotNull(
                clientId, r'ClientDetail', 'clientId'),
            externalId: BuiltValueNullFieldError.checkNotNull(
                externalId, r'ClientDetail', 'externalId'),
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'ClientDetail', 'displayName'),
            mobileNo: BuiltValueNullFieldError.checkNotNull(
                mobileNo, r'ClientDetail', 'mobileNo'),
            officeName: BuiltValueNullFieldError.checkNotNull(
                officeName, r'ClientDetail', 'officeName'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'ClientDetail', 'status'),
            identifierStatus: identifierStatus,
            identifierExpiryDate: identifierExpiryDate,
            firstname: BuiltValueNullFieldError.checkNotNull(
                firstname, r'ClientDetail', 'firstname'),
            lastname: BuiltValueNullFieldError.checkNotNull(
                lastname, r'ClientDetail', 'lastname'),
            emailAddress: BuiltValueNullFieldError.checkNotNull(
                emailAddress, r'ClientDetail', 'emailAddress'),
            identifier: _identifier?.build(),
            savingsAccounts: savingsAccounts.build(),
            fixedDepositAccounts: fixedDepositAccounts.build(),
            loan: loan,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'identifier';
        _identifier?.build();
        _$failedField = 'savingsAccounts';
        savingsAccounts.build();
        _$failedField = 'fixedDepositAccounts';
        fixedDepositAccounts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ClientDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
