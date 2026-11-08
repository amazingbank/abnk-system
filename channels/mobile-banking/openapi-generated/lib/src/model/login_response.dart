//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'login_response.g.dart';

/// LoginResponse
///
/// Properties:
/// * [token] - JWT 三段式（HS256）
/// * [tokenType] 
/// * [expiresIn] - token 有效期（秒，默认 900）
/// * [channel] 
/// * [username] 
/// * [displayName] 
/// * [clientId] - 映射的种子客户 ID（网关用户表口径，P0.3）
@BuiltValue()
abstract class LoginResponse implements Built<LoginResponse, LoginResponseBuilder> {
  /// JWT 三段式（HS256）
  @BuiltValueField(wireName: r'token')
  String get token;

  @BuiltValueField(wireName: r'tokenType')
  LoginResponseTokenTypeEnum get tokenType;
  // enum tokenTypeEnum {  Bearer,  };

  /// token 有效期（秒，默认 900）
  @BuiltValueField(wireName: r'expiresIn')
  int get expiresIn;

  @BuiltValueField(wireName: r'channel')
  LoginResponseChannelEnum get channel;
  // enum channelEnum {  customer,  };

  @BuiltValueField(wireName: r'username')
  String get username;

  @BuiltValueField(wireName: r'displayName')
  String get displayName;

  /// 映射的种子客户 ID（网关用户表口径，P0.3）
  @BuiltValueField(wireName: r'clientId')
  int get clientId;

  LoginResponse._();

  factory LoginResponse([void updates(LoginResponseBuilder b)]) = _$LoginResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoginResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoginResponse> get serializer => _$LoginResponseSerializer();
}

class _$LoginResponseSerializer implements PrimitiveSerializer<LoginResponse> {
  @override
  final Iterable<Type> types = const [LoginResponse, _$LoginResponse];

  @override
  final String wireName = r'LoginResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoginResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'token';
    yield serializers.serialize(
      object.token,
      specifiedType: const FullType(String),
    );
    yield r'tokenType';
    yield serializers.serialize(
      object.tokenType,
      specifiedType: const FullType(LoginResponseTokenTypeEnum),
    );
    yield r'expiresIn';
    yield serializers.serialize(
      object.expiresIn,
      specifiedType: const FullType(int),
    );
    yield r'channel';
    yield serializers.serialize(
      object.channel,
      specifiedType: const FullType(LoginResponseChannelEnum),
    );
    yield r'username';
    yield serializers.serialize(
      object.username,
      specifiedType: const FullType(String),
    );
    yield r'displayName';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'clientId';
    yield serializers.serialize(
      object.clientId,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LoginResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoginResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.token = valueDes;
          break;
        case r'tokenType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LoginResponseTokenTypeEnum),
          ) as LoginResponseTokenTypeEnum;
          result.tokenType = valueDes;
          break;
        case r'expiresIn':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expiresIn = valueDes;
          break;
        case r'channel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LoginResponseChannelEnum),
          ) as LoginResponseChannelEnum;
          result.channel = valueDes;
          break;
        case r'username':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.username = valueDes;
          break;
        case r'displayName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'clientId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.clientId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LoginResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoginResponseBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


class LoginResponseTokenTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'Bearer')
  static const LoginResponseTokenTypeEnum bearer = _$loginResponseTokenTypeEnum_bearer;

  static Serializer<LoginResponseTokenTypeEnum> get serializer => _$loginResponseTokenTypeEnumSerializer;

  const LoginResponseTokenTypeEnum._(String name): super(name);

  static BuiltSet<LoginResponseTokenTypeEnum> get values => _$loginResponseTokenTypeEnumValues;
  static LoginResponseTokenTypeEnum valueOf(String name) => _$loginResponseTokenTypeEnumValueOf(name);
}

class LoginResponseChannelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'customer')
  static const LoginResponseChannelEnum customer = _$loginResponseChannelEnum_customer;

  static Serializer<LoginResponseChannelEnum> get serializer => _$loginResponseChannelEnumSerializer;

  const LoginResponseChannelEnum._(String name): super(name);

  static BuiltSet<LoginResponseChannelEnum> get values => _$loginResponseChannelEnumValues;
  static LoginResponseChannelEnum valueOf(String name) => _$loginResponseChannelEnumValueOf(name);
}

