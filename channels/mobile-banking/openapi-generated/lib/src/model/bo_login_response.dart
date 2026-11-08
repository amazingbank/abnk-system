//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'bo_login_response.g.dart';

/// BoLoginResponse
///
/// Properties:
/// * [token] - JWT 三段式（HS256）
/// * [tokenType] 
/// * [expiresIn] - token 有效期（秒，默认 900）
/// * [channel] 
/// * [username] 
/// * [displayName] 
/// * [role] - 运营角色（基线单一 ADMIN）
@BuiltValue()
abstract class BoLoginResponse implements Built<BoLoginResponse, BoLoginResponseBuilder> {
  /// JWT 三段式（HS256）
  @BuiltValueField(wireName: r'token')
  String get token;

  @BuiltValueField(wireName: r'tokenType')
  BoLoginResponseTokenTypeEnum get tokenType;
  // enum tokenTypeEnum {  Bearer,  };

  /// token 有效期（秒，默认 900）
  @BuiltValueField(wireName: r'expiresIn')
  int get expiresIn;

  @BuiltValueField(wireName: r'channel')
  BoLoginResponseChannelEnum get channel;
  // enum channelEnum {  internal,  };

  @BuiltValueField(wireName: r'username')
  String get username;

  @BuiltValueField(wireName: r'displayName')
  String get displayName;

  /// 运营角色（基线单一 ADMIN）
  @BuiltValueField(wireName: r'role')
  BoLoginResponseRoleEnum get role;
  // enum roleEnum {  ADMIN,  };

  BoLoginResponse._();

  factory BoLoginResponse([void updates(BoLoginResponseBuilder b)]) = _$BoLoginResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BoLoginResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BoLoginResponse> get serializer => _$BoLoginResponseSerializer();
}

class _$BoLoginResponseSerializer implements PrimitiveSerializer<BoLoginResponse> {
  @override
  final Iterable<Type> types = const [BoLoginResponse, _$BoLoginResponse];

  @override
  final String wireName = r'BoLoginResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BoLoginResponse object, {
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
      specifiedType: const FullType(BoLoginResponseTokenTypeEnum),
    );
    yield r'expiresIn';
    yield serializers.serialize(
      object.expiresIn,
      specifiedType: const FullType(int),
    );
    yield r'channel';
    yield serializers.serialize(
      object.channel,
      specifiedType: const FullType(BoLoginResponseChannelEnum),
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
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(BoLoginResponseRoleEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BoLoginResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BoLoginResponseBuilder result,
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
            specifiedType: const FullType(BoLoginResponseTokenTypeEnum),
          ) as BoLoginResponseTokenTypeEnum;
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
            specifiedType: const FullType(BoLoginResponseChannelEnum),
          ) as BoLoginResponseChannelEnum;
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
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BoLoginResponseRoleEnum),
          ) as BoLoginResponseRoleEnum;
          result.role = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BoLoginResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BoLoginResponseBuilder();
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


class BoLoginResponseTokenTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'Bearer')
  static const BoLoginResponseTokenTypeEnum bearer = _$boLoginResponseTokenTypeEnum_bearer;

  static Serializer<BoLoginResponseTokenTypeEnum> get serializer => _$boLoginResponseTokenTypeEnumSerializer;

  const BoLoginResponseTokenTypeEnum._(String name): super(name);

  static BuiltSet<BoLoginResponseTokenTypeEnum> get values => _$boLoginResponseTokenTypeEnumValues;
  static BoLoginResponseTokenTypeEnum valueOf(String name) => _$boLoginResponseTokenTypeEnumValueOf(name);
}

class BoLoginResponseChannelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'internal')
  static const BoLoginResponseChannelEnum internal = _$boLoginResponseChannelEnum_internal;

  static Serializer<BoLoginResponseChannelEnum> get serializer => _$boLoginResponseChannelEnumSerializer;

  const BoLoginResponseChannelEnum._(String name): super(name);

  static BuiltSet<BoLoginResponseChannelEnum> get values => _$boLoginResponseChannelEnumValues;
  static BoLoginResponseChannelEnum valueOf(String name) => _$boLoginResponseChannelEnumValueOf(name);
}

/// 运营角色（基线单一 ADMIN）
class BoLoginResponseRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const BoLoginResponseRoleEnum ADMIN = _$boLoginResponseRoleEnum_ADMIN;

  static Serializer<BoLoginResponseRoleEnum> get serializer => _$boLoginResponseRoleEnumSerializer;

  const BoLoginResponseRoleEnum._(String name): super(name);

  static BuiltSet<BoLoginResponseRoleEnum> get values => _$boLoginResponseRoleEnumValues;
  static BoLoginResponseRoleEnum valueOf(String name) => _$boLoginResponseRoleEnumValueOf(name);
}

