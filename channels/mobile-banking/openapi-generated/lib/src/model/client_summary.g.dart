// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ClientSummaryIdentifierStatusEnum
    _$clientSummaryIdentifierStatusEnum_VALID =
    const ClientSummaryIdentifierStatusEnum._('VALID');
const ClientSummaryIdentifierStatusEnum
    _$clientSummaryIdentifierStatusEnum_EXPIRED =
    const ClientSummaryIdentifierStatusEnum._('EXPIRED');

ClientSummaryIdentifierStatusEnum _$clientSummaryIdentifierStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'VALID':
      return _$clientSummaryIdentifierStatusEnum_VALID;
    case 'EXPIRED':
      return _$clientSummaryIdentifierStatusEnum_EXPIRED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ClientSummaryIdentifierStatusEnum>
    _$clientSummaryIdentifierStatusEnumValues = BuiltSet<
        ClientSummaryIdentifierStatusEnum>(const <ClientSummaryIdentifierStatusEnum>[
  _$clientSummaryIdentifierStatusEnum_VALID,
  _$clientSummaryIdentifierStatusEnum_EXPIRED,
]);

Serializer<ClientSummaryIdentifierStatusEnum>
    _$clientSummaryIdentifierStatusEnumSerializer =
    _$ClientSummaryIdentifierStatusEnumSerializer();

class _$ClientSummaryIdentifierStatusEnumSerializer
    implements PrimitiveSerializer<ClientSummaryIdentifierStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VALID': 'VALID',
    'EXPIRED': 'EXPIRED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VALID': 'VALID',
    'EXPIRED': 'EXPIRED',
  };

  @override
  final Iterable<Type> types = const <Type>[ClientSummaryIdentifierStatusEnum];
  @override
  final String wireName = 'ClientSummaryIdentifierStatusEnum';

  @override
  Object serialize(
          Serializers serializers, ClientSummaryIdentifierStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ClientSummaryIdentifierStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ClientSummaryIdentifierStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ClientSummary extends ClientSummary {
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
  final ClientSummaryIdentifierStatusEnum? identifierStatus;
  @override
  final Date? identifierExpiryDate;

  factory _$ClientSummary([void Function(ClientSummaryBuilder)? updates]) =>
      (ClientSummaryBuilder()..update(updates))._build();

  _$ClientSummary._(
      {required this.clientId,
      required this.externalId,
      required this.displayName,
      required this.mobileNo,
      required this.officeName,
      required this.status,
      this.identifierStatus,
      this.identifierExpiryDate})
      : super._();
  @override
  ClientSummary rebuild(void Function(ClientSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ClientSummaryBuilder toBuilder() => ClientSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ClientSummary &&
        clientId == other.clientId &&
        externalId == other.externalId &&
        displayName == other.displayName &&
        mobileNo == other.mobileNo &&
        officeName == other.officeName &&
        status == other.status &&
        identifierStatus == other.identifierStatus &&
        identifierExpiryDate == other.identifierExpiryDate;
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
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ClientSummary')
          ..add('clientId', clientId)
          ..add('externalId', externalId)
          ..add('displayName', displayName)
          ..add('mobileNo', mobileNo)
          ..add('officeName', officeName)
          ..add('status', status)
          ..add('identifierStatus', identifierStatus)
          ..add('identifierExpiryDate', identifierExpiryDate))
        .toString();
  }
}

class ClientSummaryBuilder
    implements Builder<ClientSummary, ClientSummaryBuilder> {
  _$ClientSummary? _$v;

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

  ClientSummaryIdentifierStatusEnum? _identifierStatus;
  ClientSummaryIdentifierStatusEnum? get identifierStatus =>
      _$this._identifierStatus;
  set identifierStatus(ClientSummaryIdentifierStatusEnum? identifierStatus) =>
      _$this._identifierStatus = identifierStatus;

  Date? _identifierExpiryDate;
  Date? get identifierExpiryDate => _$this._identifierExpiryDate;
  set identifierExpiryDate(Date? identifierExpiryDate) =>
      _$this._identifierExpiryDate = identifierExpiryDate;

  ClientSummaryBuilder() {
    ClientSummary._defaults(this);
  }

  ClientSummaryBuilder get _$this {
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
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ClientSummary other) {
    _$v = other as _$ClientSummary;
  }

  @override
  void update(void Function(ClientSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ClientSummary build() => _build();

  _$ClientSummary _build() {
    final _$result = _$v ??
        _$ClientSummary._(
          clientId: BuiltValueNullFieldError.checkNotNull(
              clientId, r'ClientSummary', 'clientId'),
          externalId: BuiltValueNullFieldError.checkNotNull(
              externalId, r'ClientSummary', 'externalId'),
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'ClientSummary', 'displayName'),
          mobileNo: BuiltValueNullFieldError.checkNotNull(
              mobileNo, r'ClientSummary', 'mobileNo'),
          officeName: BuiltValueNullFieldError.checkNotNull(
              officeName, r'ClientSummary', 'officeName'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ClientSummary', 'status'),
          identifierStatus: identifierStatus,
          identifierExpiryDate: identifierExpiryDate,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
