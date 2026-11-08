// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bo_login_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BoLoginResponseTokenTypeEnum _$boLoginResponseTokenTypeEnum_bearer =
    const BoLoginResponseTokenTypeEnum._('bearer');

BoLoginResponseTokenTypeEnum _$boLoginResponseTokenTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'bearer':
      return _$boLoginResponseTokenTypeEnum_bearer;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BoLoginResponseTokenTypeEnum>
    _$boLoginResponseTokenTypeEnumValues =
    BuiltSet<BoLoginResponseTokenTypeEnum>(const <BoLoginResponseTokenTypeEnum>[
  _$boLoginResponseTokenTypeEnum_bearer,
]);

const BoLoginResponseChannelEnum _$boLoginResponseChannelEnum_internal =
    const BoLoginResponseChannelEnum._('internal');

BoLoginResponseChannelEnum _$boLoginResponseChannelEnumValueOf(String name) {
  switch (name) {
    case 'internal':
      return _$boLoginResponseChannelEnum_internal;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BoLoginResponseChannelEnum> _$boLoginResponseChannelEnumValues =
    BuiltSet<BoLoginResponseChannelEnum>(const <BoLoginResponseChannelEnum>[
  _$boLoginResponseChannelEnum_internal,
]);

const BoLoginResponseRoleEnum _$boLoginResponseRoleEnum_ADMIN =
    const BoLoginResponseRoleEnum._('ADMIN');

BoLoginResponseRoleEnum _$boLoginResponseRoleEnumValueOf(String name) {
  switch (name) {
    case 'ADMIN':
      return _$boLoginResponseRoleEnum_ADMIN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BoLoginResponseRoleEnum> _$boLoginResponseRoleEnumValues =
    BuiltSet<BoLoginResponseRoleEnum>(const <BoLoginResponseRoleEnum>[
  _$boLoginResponseRoleEnum_ADMIN,
]);

Serializer<BoLoginResponseTokenTypeEnum>
    _$boLoginResponseTokenTypeEnumSerializer =
    _$BoLoginResponseTokenTypeEnumSerializer();
Serializer<BoLoginResponseChannelEnum> _$boLoginResponseChannelEnumSerializer =
    _$BoLoginResponseChannelEnumSerializer();
Serializer<BoLoginResponseRoleEnum> _$boLoginResponseRoleEnumSerializer =
    _$BoLoginResponseRoleEnumSerializer();

class _$BoLoginResponseTokenTypeEnumSerializer
    implements PrimitiveSerializer<BoLoginResponseTokenTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'bearer': 'Bearer',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Bearer': 'bearer',
  };

  @override
  final Iterable<Type> types = const <Type>[BoLoginResponseTokenTypeEnum];
  @override
  final String wireName = 'BoLoginResponseTokenTypeEnum';

  @override
  Object serialize(Serializers serializers, BoLoginResponseTokenTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BoLoginResponseTokenTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BoLoginResponseTokenTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BoLoginResponseChannelEnumSerializer
    implements PrimitiveSerializer<BoLoginResponseChannelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'internal': 'internal',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'internal': 'internal',
  };

  @override
  final Iterable<Type> types = const <Type>[BoLoginResponseChannelEnum];
  @override
  final String wireName = 'BoLoginResponseChannelEnum';

  @override
  Object serialize(Serializers serializers, BoLoginResponseChannelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BoLoginResponseChannelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BoLoginResponseChannelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BoLoginResponseRoleEnumSerializer
    implements PrimitiveSerializer<BoLoginResponseRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ADMIN': 'ADMIN',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ADMIN': 'ADMIN',
  };

  @override
  final Iterable<Type> types = const <Type>[BoLoginResponseRoleEnum];
  @override
  final String wireName = 'BoLoginResponseRoleEnum';

  @override
  Object serialize(Serializers serializers, BoLoginResponseRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BoLoginResponseRoleEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BoLoginResponseRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BoLoginResponse extends BoLoginResponse {
  @override
  final String token;
  @override
  final BoLoginResponseTokenTypeEnum tokenType;
  @override
  final int expiresIn;
  @override
  final BoLoginResponseChannelEnum channel;
  @override
  final String username;
  @override
  final String displayName;
  @override
  final BoLoginResponseRoleEnum role;

  factory _$BoLoginResponse([void Function(BoLoginResponseBuilder)? updates]) =>
      (BoLoginResponseBuilder()..update(updates))._build();

  _$BoLoginResponse._(
      {required this.token,
      required this.tokenType,
      required this.expiresIn,
      required this.channel,
      required this.username,
      required this.displayName,
      required this.role})
      : super._();
  @override
  BoLoginResponse rebuild(void Function(BoLoginResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BoLoginResponseBuilder toBuilder() => BoLoginResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BoLoginResponse &&
        token == other.token &&
        tokenType == other.tokenType &&
        expiresIn == other.expiresIn &&
        channel == other.channel &&
        username == other.username &&
        displayName == other.displayName &&
        role == other.role;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jc(_$hash, tokenType.hashCode);
    _$hash = $jc(_$hash, expiresIn.hashCode);
    _$hash = $jc(_$hash, channel.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BoLoginResponse')
          ..add('token', token)
          ..add('tokenType', tokenType)
          ..add('expiresIn', expiresIn)
          ..add('channel', channel)
          ..add('username', username)
          ..add('displayName', displayName)
          ..add('role', role))
        .toString();
  }
}

class BoLoginResponseBuilder
    implements Builder<BoLoginResponse, BoLoginResponseBuilder> {
  _$BoLoginResponse? _$v;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  BoLoginResponseTokenTypeEnum? _tokenType;
  BoLoginResponseTokenTypeEnum? get tokenType => _$this._tokenType;
  set tokenType(BoLoginResponseTokenTypeEnum? tokenType) =>
      _$this._tokenType = tokenType;

  int? _expiresIn;
  int? get expiresIn => _$this._expiresIn;
  set expiresIn(int? expiresIn) => _$this._expiresIn = expiresIn;

  BoLoginResponseChannelEnum? _channel;
  BoLoginResponseChannelEnum? get channel => _$this._channel;
  set channel(BoLoginResponseChannelEnum? channel) => _$this._channel = channel;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  BoLoginResponseRoleEnum? _role;
  BoLoginResponseRoleEnum? get role => _$this._role;
  set role(BoLoginResponseRoleEnum? role) => _$this._role = role;

  BoLoginResponseBuilder() {
    BoLoginResponse._defaults(this);
  }

  BoLoginResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _token = $v.token;
      _tokenType = $v.tokenType;
      _expiresIn = $v.expiresIn;
      _channel = $v.channel;
      _username = $v.username;
      _displayName = $v.displayName;
      _role = $v.role;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BoLoginResponse other) {
    _$v = other as _$BoLoginResponse;
  }

  @override
  void update(void Function(BoLoginResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BoLoginResponse build() => _build();

  _$BoLoginResponse _build() {
    final _$result = _$v ??
        _$BoLoginResponse._(
          token: BuiltValueNullFieldError.checkNotNull(
              token, r'BoLoginResponse', 'token'),
          tokenType: BuiltValueNullFieldError.checkNotNull(
              tokenType, r'BoLoginResponse', 'tokenType'),
          expiresIn: BuiltValueNullFieldError.checkNotNull(
              expiresIn, r'BoLoginResponse', 'expiresIn'),
          channel: BuiltValueNullFieldError.checkNotNull(
              channel, r'BoLoginResponse', 'channel'),
          username: BuiltValueNullFieldError.checkNotNull(
              username, r'BoLoginResponse', 'username'),
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'BoLoginResponse', 'displayName'),
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'BoLoginResponse', 'role'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
