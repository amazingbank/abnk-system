// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const LoginResponseTokenTypeEnum _$loginResponseTokenTypeEnum_bearer =
    const LoginResponseTokenTypeEnum._('bearer');

LoginResponseTokenTypeEnum _$loginResponseTokenTypeEnumValueOf(String name) {
  switch (name) {
    case 'bearer':
      return _$loginResponseTokenTypeEnum_bearer;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<LoginResponseTokenTypeEnum> _$loginResponseTokenTypeEnumValues =
    BuiltSet<LoginResponseTokenTypeEnum>(const <LoginResponseTokenTypeEnum>[
  _$loginResponseTokenTypeEnum_bearer,
]);

const LoginResponseChannelEnum _$loginResponseChannelEnum_customer =
    const LoginResponseChannelEnum._('customer');

LoginResponseChannelEnum _$loginResponseChannelEnumValueOf(String name) {
  switch (name) {
    case 'customer':
      return _$loginResponseChannelEnum_customer;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<LoginResponseChannelEnum> _$loginResponseChannelEnumValues =
    BuiltSet<LoginResponseChannelEnum>(const <LoginResponseChannelEnum>[
  _$loginResponseChannelEnum_customer,
]);

Serializer<LoginResponseTokenTypeEnum> _$loginResponseTokenTypeEnumSerializer =
    _$LoginResponseTokenTypeEnumSerializer();
Serializer<LoginResponseChannelEnum> _$loginResponseChannelEnumSerializer =
    _$LoginResponseChannelEnumSerializer();

class _$LoginResponseTokenTypeEnumSerializer
    implements PrimitiveSerializer<LoginResponseTokenTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'bearer': 'Bearer',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Bearer': 'bearer',
  };

  @override
  final Iterable<Type> types = const <Type>[LoginResponseTokenTypeEnum];
  @override
  final String wireName = 'LoginResponseTokenTypeEnum';

  @override
  Object serialize(Serializers serializers, LoginResponseTokenTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  LoginResponseTokenTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      LoginResponseTokenTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$LoginResponseChannelEnumSerializer
    implements PrimitiveSerializer<LoginResponseChannelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'customer': 'customer',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'customer': 'customer',
  };

  @override
  final Iterable<Type> types = const <Type>[LoginResponseChannelEnum];
  @override
  final String wireName = 'LoginResponseChannelEnum';

  @override
  Object serialize(Serializers serializers, LoginResponseChannelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  LoginResponseChannelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      LoginResponseChannelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$LoginResponse extends LoginResponse {
  @override
  final String token;
  @override
  final LoginResponseTokenTypeEnum tokenType;
  @override
  final int expiresIn;
  @override
  final LoginResponseChannelEnum channel;
  @override
  final String username;
  @override
  final String displayName;
  @override
  final int clientId;

  factory _$LoginResponse([void Function(LoginResponseBuilder)? updates]) =>
      (LoginResponseBuilder()..update(updates))._build();

  _$LoginResponse._(
      {required this.token,
      required this.tokenType,
      required this.expiresIn,
      required this.channel,
      required this.username,
      required this.displayName,
      required this.clientId})
      : super._();
  @override
  LoginResponse rebuild(void Function(LoginResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoginResponseBuilder toBuilder() => LoginResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoginResponse &&
        token == other.token &&
        tokenType == other.tokenType &&
        expiresIn == other.expiresIn &&
        channel == other.channel &&
        username == other.username &&
        displayName == other.displayName &&
        clientId == other.clientId;
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
    _$hash = $jc(_$hash, clientId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoginResponse')
          ..add('token', token)
          ..add('tokenType', tokenType)
          ..add('expiresIn', expiresIn)
          ..add('channel', channel)
          ..add('username', username)
          ..add('displayName', displayName)
          ..add('clientId', clientId))
        .toString();
  }
}

class LoginResponseBuilder
    implements Builder<LoginResponse, LoginResponseBuilder> {
  _$LoginResponse? _$v;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  LoginResponseTokenTypeEnum? _tokenType;
  LoginResponseTokenTypeEnum? get tokenType => _$this._tokenType;
  set tokenType(LoginResponseTokenTypeEnum? tokenType) =>
      _$this._tokenType = tokenType;

  int? _expiresIn;
  int? get expiresIn => _$this._expiresIn;
  set expiresIn(int? expiresIn) => _$this._expiresIn = expiresIn;

  LoginResponseChannelEnum? _channel;
  LoginResponseChannelEnum? get channel => _$this._channel;
  set channel(LoginResponseChannelEnum? channel) => _$this._channel = channel;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  int? _clientId;
  int? get clientId => _$this._clientId;
  set clientId(int? clientId) => _$this._clientId = clientId;

  LoginResponseBuilder() {
    LoginResponse._defaults(this);
  }

  LoginResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _token = $v.token;
      _tokenType = $v.tokenType;
      _expiresIn = $v.expiresIn;
      _channel = $v.channel;
      _username = $v.username;
      _displayName = $v.displayName;
      _clientId = $v.clientId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoginResponse other) {
    _$v = other as _$LoginResponse;
  }

  @override
  void update(void Function(LoginResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoginResponse build() => _build();

  _$LoginResponse _build() {
    final _$result = _$v ??
        _$LoginResponse._(
          token: BuiltValueNullFieldError.checkNotNull(
              token, r'LoginResponse', 'token'),
          tokenType: BuiltValueNullFieldError.checkNotNull(
              tokenType, r'LoginResponse', 'tokenType'),
          expiresIn: BuiltValueNullFieldError.checkNotNull(
              expiresIn, r'LoginResponse', 'expiresIn'),
          channel: BuiltValueNullFieldError.checkNotNull(
              channel, r'LoginResponse', 'channel'),
          username: BuiltValueNullFieldError.checkNotNull(
              username, r'LoginResponse', 'username'),
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'LoginResponse', 'displayName'),
          clientId: BuiltValueNullFieldError.checkNotNull(
              clientId, r'LoginResponse', 'clientId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
