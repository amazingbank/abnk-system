//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'identity_info.g.dart';

/// 客户证照信息（只读；status 为到期状态推导值——纯读计算无拦截）
///
/// Properties:
/// * [documentTypeId] 
/// * [documentTypeName] 
/// * [documentKey] - 证件号（脱敏形态，如 3301**********001X）
/// * [status] - 到期状态三态（expiryDate 对业务日期比较推导）
/// * [issuanceDate] 
/// * [expiryDate] 
@BuiltValue()
abstract class IdentityInfo implements Built<IdentityInfo, IdentityInfoBuilder> {
  @BuiltValueField(wireName: r'documentTypeId')
  int get documentTypeId;

  @BuiltValueField(wireName: r'documentTypeName')
  String get documentTypeName;

  /// 证件号（脱敏形态，如 3301**********001X）
  @BuiltValueField(wireName: r'documentKey')
  String get documentKey;

  /// 到期状态三态（expiryDate 对业务日期比较推导）
  @BuiltValueField(wireName: r'status')
  IdentityInfoStatusEnum get status;
  // enum statusEnum {  VALID,  EXPIRING_SOON,  EXPIRED,  };

  @BuiltValueField(wireName: r'issuanceDate')
  Date get issuanceDate;

  @BuiltValueField(wireName: r'expiryDate')
  Date get expiryDate;

  IdentityInfo._();

  factory IdentityInfo([void updates(IdentityInfoBuilder b)]) = _$IdentityInfo;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(IdentityInfoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<IdentityInfo> get serializer => _$IdentityInfoSerializer();
}

class _$IdentityInfoSerializer implements PrimitiveSerializer<IdentityInfo> {
  @override
  final Iterable<Type> types = const [IdentityInfo, _$IdentityInfo];

  @override
  final String wireName = r'IdentityInfo';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    IdentityInfo object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'documentTypeId';
    yield serializers.serialize(
      object.documentTypeId,
      specifiedType: const FullType(int),
    );
    yield r'documentTypeName';
    yield serializers.serialize(
      object.documentTypeName,
      specifiedType: const FullType(String),
    );
    yield r'documentKey';
    yield serializers.serialize(
      object.documentKey,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(IdentityInfoStatusEnum),
    );
    yield r'issuanceDate';
    yield serializers.serialize(
      object.issuanceDate,
      specifiedType: const FullType(Date),
    );
    yield r'expiryDate';
    yield serializers.serialize(
      object.expiryDate,
      specifiedType: const FullType(Date),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    IdentityInfo object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required IdentityInfoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'documentTypeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.documentTypeId = valueDes;
          break;
        case r'documentTypeName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.documentTypeName = valueDes;
          break;
        case r'documentKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.documentKey = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(IdentityInfoStatusEnum),
          ) as IdentityInfoStatusEnum;
          result.status = valueDes;
          break;
        case r'issuanceDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.issuanceDate = valueDes;
          break;
        case r'expiryDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.expiryDate = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  IdentityInfo deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = IdentityInfoBuilder();
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


/// 到期状态三态（expiryDate 对业务日期比较推导）
class IdentityInfoStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VALID')
  static const IdentityInfoStatusEnum VALID = _$identityInfoStatusEnum_VALID;
  @BuiltValueEnumConst(wireName: r'EXPIRING_SOON')
  static const IdentityInfoStatusEnum EXPIRING_SOON = _$identityInfoStatusEnum_EXPIRING_SOON;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const IdentityInfoStatusEnum EXPIRED = _$identityInfoStatusEnum_EXPIRED;

  static Serializer<IdentityInfoStatusEnum> get serializer => _$identityInfoStatusEnumSerializer;

  const IdentityInfoStatusEnum._(String name): super(name);

  static BuiltSet<IdentityInfoStatusEnum> get values => _$identityInfoStatusEnumValues;
  static IdentityInfoStatusEnum valueOf(String name) => _$identityInfoStatusEnumValueOf(name);
}

