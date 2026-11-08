// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'identity_info.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const IdentityInfoStatusEnum _$identityInfoStatusEnum_VALID =
    const IdentityInfoStatusEnum._('VALID');
const IdentityInfoStatusEnum _$identityInfoStatusEnum_EXPIRING_SOON =
    const IdentityInfoStatusEnum._('EXPIRING_SOON');
const IdentityInfoStatusEnum _$identityInfoStatusEnum_EXPIRED =
    const IdentityInfoStatusEnum._('EXPIRED');

IdentityInfoStatusEnum _$identityInfoStatusEnumValueOf(String name) {
  switch (name) {
    case 'VALID':
      return _$identityInfoStatusEnum_VALID;
    case 'EXPIRING_SOON':
      return _$identityInfoStatusEnum_EXPIRING_SOON;
    case 'EXPIRED':
      return _$identityInfoStatusEnum_EXPIRED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<IdentityInfoStatusEnum> _$identityInfoStatusEnumValues =
    BuiltSet<IdentityInfoStatusEnum>(const <IdentityInfoStatusEnum>[
  _$identityInfoStatusEnum_VALID,
  _$identityInfoStatusEnum_EXPIRING_SOON,
  _$identityInfoStatusEnum_EXPIRED,
]);

Serializer<IdentityInfoStatusEnum> _$identityInfoStatusEnumSerializer =
    _$IdentityInfoStatusEnumSerializer();

class _$IdentityInfoStatusEnumSerializer
    implements PrimitiveSerializer<IdentityInfoStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VALID': 'VALID',
    'EXPIRING_SOON': 'EXPIRING_SOON',
    'EXPIRED': 'EXPIRED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VALID': 'VALID',
    'EXPIRING_SOON': 'EXPIRING_SOON',
    'EXPIRED': 'EXPIRED',
  };

  @override
  final Iterable<Type> types = const <Type>[IdentityInfoStatusEnum];
  @override
  final String wireName = 'IdentityInfoStatusEnum';

  @override
  Object serialize(Serializers serializers, IdentityInfoStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  IdentityInfoStatusEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      IdentityInfoStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$IdentityInfo extends IdentityInfo {
  @override
  final int documentTypeId;
  @override
  final String documentTypeName;
  @override
  final String documentKey;
  @override
  final IdentityInfoStatusEnum status;
  @override
  final Date issuanceDate;
  @override
  final Date expiryDate;

  factory _$IdentityInfo([void Function(IdentityInfoBuilder)? updates]) =>
      (IdentityInfoBuilder()..update(updates))._build();

  _$IdentityInfo._(
      {required this.documentTypeId,
      required this.documentTypeName,
      required this.documentKey,
      required this.status,
      required this.issuanceDate,
      required this.expiryDate})
      : super._();
  @override
  IdentityInfo rebuild(void Function(IdentityInfoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IdentityInfoBuilder toBuilder() => IdentityInfoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IdentityInfo &&
        documentTypeId == other.documentTypeId &&
        documentTypeName == other.documentTypeName &&
        documentKey == other.documentKey &&
        status == other.status &&
        issuanceDate == other.issuanceDate &&
        expiryDate == other.expiryDate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, documentTypeId.hashCode);
    _$hash = $jc(_$hash, documentTypeName.hashCode);
    _$hash = $jc(_$hash, documentKey.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, issuanceDate.hashCode);
    _$hash = $jc(_$hash, expiryDate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'IdentityInfo')
          ..add('documentTypeId', documentTypeId)
          ..add('documentTypeName', documentTypeName)
          ..add('documentKey', documentKey)
          ..add('status', status)
          ..add('issuanceDate', issuanceDate)
          ..add('expiryDate', expiryDate))
        .toString();
  }
}

class IdentityInfoBuilder
    implements Builder<IdentityInfo, IdentityInfoBuilder> {
  _$IdentityInfo? _$v;

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

  IdentityInfoStatusEnum? _status;
  IdentityInfoStatusEnum? get status => _$this._status;
  set status(IdentityInfoStatusEnum? status) => _$this._status = status;

  Date? _issuanceDate;
  Date? get issuanceDate => _$this._issuanceDate;
  set issuanceDate(Date? issuanceDate) => _$this._issuanceDate = issuanceDate;

  Date? _expiryDate;
  Date? get expiryDate => _$this._expiryDate;
  set expiryDate(Date? expiryDate) => _$this._expiryDate = expiryDate;

  IdentityInfoBuilder() {
    IdentityInfo._defaults(this);
  }

  IdentityInfoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _documentTypeId = $v.documentTypeId;
      _documentTypeName = $v.documentTypeName;
      _documentKey = $v.documentKey;
      _status = $v.status;
      _issuanceDate = $v.issuanceDate;
      _expiryDate = $v.expiryDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IdentityInfo other) {
    _$v = other as _$IdentityInfo;
  }

  @override
  void update(void Function(IdentityInfoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  IdentityInfo build() => _build();

  _$IdentityInfo _build() {
    final _$result = _$v ??
        _$IdentityInfo._(
          documentTypeId: BuiltValueNullFieldError.checkNotNull(
              documentTypeId, r'IdentityInfo', 'documentTypeId'),
          documentTypeName: BuiltValueNullFieldError.checkNotNull(
              documentTypeName, r'IdentityInfo', 'documentTypeName'),
          documentKey: BuiltValueNullFieldError.checkNotNull(
              documentKey, r'IdentityInfo', 'documentKey'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'IdentityInfo', 'status'),
          issuanceDate: BuiltValueNullFieldError.checkNotNull(
              issuanceDate, r'IdentityInfo', 'issuanceDate'),
          expiryDate: BuiltValueNullFieldError.checkNotNull(
              expiryDate, r'IdentityInfo', 'expiryDate'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
