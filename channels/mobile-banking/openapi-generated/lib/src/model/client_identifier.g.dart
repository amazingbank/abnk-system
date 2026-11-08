// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_identifier.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ClientIdentifierStatusEnum _$clientIdentifierStatusEnum_ACTIVE =
    const ClientIdentifierStatusEnum._('ACTIVE');
const ClientIdentifierStatusEnum _$clientIdentifierStatusEnum_INACTIVE =
    const ClientIdentifierStatusEnum._('INACTIVE');

ClientIdentifierStatusEnum _$clientIdentifierStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$clientIdentifierStatusEnum_ACTIVE;
    case 'INACTIVE':
      return _$clientIdentifierStatusEnum_INACTIVE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ClientIdentifierStatusEnum> _$clientIdentifierStatusEnumValues =
    BuiltSet<ClientIdentifierStatusEnum>(const <ClientIdentifierStatusEnum>[
  _$clientIdentifierStatusEnum_ACTIVE,
  _$clientIdentifierStatusEnum_INACTIVE,
]);

const ClientIdentifierDerivedStatusEnum
    _$clientIdentifierDerivedStatusEnum_VALID =
    const ClientIdentifierDerivedStatusEnum._('VALID');
const ClientIdentifierDerivedStatusEnum
    _$clientIdentifierDerivedStatusEnum_EXPIRED =
    const ClientIdentifierDerivedStatusEnum._('EXPIRED');

ClientIdentifierDerivedStatusEnum _$clientIdentifierDerivedStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'VALID':
      return _$clientIdentifierDerivedStatusEnum_VALID;
    case 'EXPIRED':
      return _$clientIdentifierDerivedStatusEnum_EXPIRED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ClientIdentifierDerivedStatusEnum>
    _$clientIdentifierDerivedStatusEnumValues = BuiltSet<
        ClientIdentifierDerivedStatusEnum>(const <ClientIdentifierDerivedStatusEnum>[
  _$clientIdentifierDerivedStatusEnum_VALID,
  _$clientIdentifierDerivedStatusEnum_EXPIRED,
]);

Serializer<ClientIdentifierStatusEnum> _$clientIdentifierStatusEnumSerializer =
    _$ClientIdentifierStatusEnumSerializer();
Serializer<ClientIdentifierDerivedStatusEnum>
    _$clientIdentifierDerivedStatusEnumSerializer =
    _$ClientIdentifierDerivedStatusEnumSerializer();

class _$ClientIdentifierStatusEnumSerializer
    implements PrimitiveSerializer<ClientIdentifierStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'INACTIVE': 'INACTIVE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'INACTIVE': 'INACTIVE',
  };

  @override
  final Iterable<Type> types = const <Type>[ClientIdentifierStatusEnum];
  @override
  final String wireName = 'ClientIdentifierStatusEnum';

  @override
  Object serialize(Serializers serializers, ClientIdentifierStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ClientIdentifierStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ClientIdentifierStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ClientIdentifierDerivedStatusEnumSerializer
    implements PrimitiveSerializer<ClientIdentifierDerivedStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VALID': 'VALID',
    'EXPIRED': 'EXPIRED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VALID': 'VALID',
    'EXPIRED': 'EXPIRED',
  };

  @override
  final Iterable<Type> types = const <Type>[ClientIdentifierDerivedStatusEnum];
  @override
  final String wireName = 'ClientIdentifierDerivedStatusEnum';

  @override
  Object serialize(
          Serializers serializers, ClientIdentifierDerivedStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ClientIdentifierDerivedStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ClientIdentifierDerivedStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ClientIdentifier extends ClientIdentifier {
  @override
  final int identifierId;
  @override
  final int documentTypeId;
  @override
  final String documentTypeName;
  @override
  final String documentKey;
  @override
  final ClientIdentifierStatusEnum status;
  @override
  final ClientIdentifierDerivedStatusEnum derivedStatus;
  @override
  final Date issuanceDate;
  @override
  final Date expiryDate;
  @override
  final String? description;

  factory _$ClientIdentifier(
          [void Function(ClientIdentifierBuilder)? updates]) =>
      (ClientIdentifierBuilder()..update(updates))._build();

  _$ClientIdentifier._(
      {required this.identifierId,
      required this.documentTypeId,
      required this.documentTypeName,
      required this.documentKey,
      required this.status,
      required this.derivedStatus,
      required this.issuanceDate,
      required this.expiryDate,
      this.description})
      : super._();
  @override
  ClientIdentifier rebuild(void Function(ClientIdentifierBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ClientIdentifierBuilder toBuilder() =>
      ClientIdentifierBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ClientIdentifier &&
        identifierId == other.identifierId &&
        documentTypeId == other.documentTypeId &&
        documentTypeName == other.documentTypeName &&
        documentKey == other.documentKey &&
        status == other.status &&
        derivedStatus == other.derivedStatus &&
        issuanceDate == other.issuanceDate &&
        expiryDate == other.expiryDate &&
        description == other.description;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, identifierId.hashCode);
    _$hash = $jc(_$hash, documentTypeId.hashCode);
    _$hash = $jc(_$hash, documentTypeName.hashCode);
    _$hash = $jc(_$hash, documentKey.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, derivedStatus.hashCode);
    _$hash = $jc(_$hash, issuanceDate.hashCode);
    _$hash = $jc(_$hash, expiryDate.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ClientIdentifier')
          ..add('identifierId', identifierId)
          ..add('documentTypeId', documentTypeId)
          ..add('documentTypeName', documentTypeName)
          ..add('documentKey', documentKey)
          ..add('status', status)
          ..add('derivedStatus', derivedStatus)
          ..add('issuanceDate', issuanceDate)
          ..add('expiryDate', expiryDate)
          ..add('description', description))
        .toString();
  }
}

class ClientIdentifierBuilder
    implements Builder<ClientIdentifier, ClientIdentifierBuilder> {
  _$ClientIdentifier? _$v;

  int? _identifierId;
  int? get identifierId => _$this._identifierId;
  set identifierId(int? identifierId) => _$this._identifierId = identifierId;

  int? _documentTypeId;
  int? get documentTypeId => _$this._documentTypeId;
  set documentTypeId(int? documentTypeId) =>
      _$this._documentTypeId = documentTypeId;

  String? _documentTypeName;
  String? get documentTypeName => _$this._documentTypeName;
  set documentTypeName(String? documentTypeName) =>
      _$this._documentTypeName = documentTypeName;

  String? _documentKey;
  String? get documentKey => _$this._documentKey;
  set documentKey(String? documentKey) => _$this._documentKey = documentKey;

  ClientIdentifierStatusEnum? _status;
  ClientIdentifierStatusEnum? get status => _$this._status;
  set status(ClientIdentifierStatusEnum? status) => _$this._status = status;

  ClientIdentifierDerivedStatusEnum? _derivedStatus;
  ClientIdentifierDerivedStatusEnum? get derivedStatus => _$this._derivedStatus;
  set derivedStatus(ClientIdentifierDerivedStatusEnum? derivedStatus) =>
      _$this._derivedStatus = derivedStatus;

  Date? _issuanceDate;
  Date? get issuanceDate => _$this._issuanceDate;
  set issuanceDate(Date? issuanceDate) => _$this._issuanceDate = issuanceDate;

  Date? _expiryDate;
  Date? get expiryDate => _$this._expiryDate;
  set expiryDate(Date? expiryDate) => _$this._expiryDate = expiryDate;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  ClientIdentifierBuilder() {
    ClientIdentifier._defaults(this);
  }

  ClientIdentifierBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _identifierId = $v.identifierId;
      _documentTypeId = $v.documentTypeId;
      _documentTypeName = $v.documentTypeName;
      _documentKey = $v.documentKey;
      _status = $v.status;
      _derivedStatus = $v.derivedStatus;
      _issuanceDate = $v.issuanceDate;
      _expiryDate = $v.expiryDate;
      _description = $v.description;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ClientIdentifier other) {
    _$v = other as _$ClientIdentifier;
  }

  @override
  void update(void Function(ClientIdentifierBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ClientIdentifier build() => _build();

  _$ClientIdentifier _build() {
    final _$result = _$v ??
        _$ClientIdentifier._(
          identifierId: BuiltValueNullFieldError.checkNotNull(
              identifierId, r'ClientIdentifier', 'identifierId'),
          documentTypeId: BuiltValueNullFieldError.checkNotNull(
              documentTypeId, r'ClientIdentifier', 'documentTypeId'),
          documentTypeName: BuiltValueNullFieldError.checkNotNull(
              documentTypeName, r'ClientIdentifier', 'documentTypeName'),
          documentKey: BuiltValueNullFieldError.checkNotNull(
              documentKey, r'ClientIdentifier', 'documentKey'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ClientIdentifier', 'status'),
          derivedStatus: BuiltValueNullFieldError.checkNotNull(
              derivedStatus, r'ClientIdentifier', 'derivedStatus'),
          issuanceDate: BuiltValueNullFieldError.checkNotNull(
              issuanceDate, r'ClientIdentifier', 'issuanceDate'),
          expiryDate: BuiltValueNullFieldError.checkNotNull(
              expiryDate, r'ClientIdentifier', 'expiryDate'),
          description: description,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
