//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'client_identifier.g.dart';

/// 客户证照（对齐 Fineract client identifiers 结构 + 到期状态推导）
///
/// Properties:
/// * [identifierId] 
/// * [documentTypeId] 
/// * [documentTypeName] 
/// * [documentKey] - 证件号
/// * [status] - Fineract 记录状态
/// * [derivedStatus] - 到期状态推导值（expiryDate 对业务日期比较）
/// * [issuanceDate] 
/// * [expiryDate] 
/// * [description] 
@BuiltValue()
abstract class ClientIdentifier implements Built<ClientIdentifier, ClientIdentifierBuilder> {
  @BuiltValueField(wireName: r'identifierId')
  int get identifierId;

  @BuiltValueField(wireName: r'documentTypeId')
  int get documentTypeId;

  @BuiltValueField(wireName: r'documentTypeName')
  String get documentTypeName;

  /// 证件号
  @BuiltValueField(wireName: r'documentKey')
  String get documentKey;

  /// Fineract 记录状态
  @BuiltValueField(wireName: r'status')
  ClientIdentifierStatusEnum get status;
  // enum statusEnum {  ACTIVE,  INACTIVE,  };

  /// 到期状态推导值（expiryDate 对业务日期比较）
  @BuiltValueField(wireName: r'derivedStatus')
  ClientIdentifierDerivedStatusEnum get derivedStatus;
  // enum derivedStatusEnum {  VALID,  EXPIRED,  };

  @BuiltValueField(wireName: r'issuanceDate')
  Date get issuanceDate;

  @BuiltValueField(wireName: r'expiryDate')
  Date get expiryDate;

  @BuiltValueField(wireName: r'description')
  String? get description;

  ClientIdentifier._();

  factory ClientIdentifier([void updates(ClientIdentifierBuilder b)]) = _$ClientIdentifier;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ClientIdentifierBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ClientIdentifier> get serializer => _$ClientIdentifierSerializer();
}

class _$ClientIdentifierSerializer implements PrimitiveSerializer<ClientIdentifier> {
  @override
  final Iterable<Type> types = const [ClientIdentifier, _$ClientIdentifier];

  @override
  final String wireName = r'ClientIdentifier';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ClientIdentifier object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'identifierId';
    yield serializers.serialize(
      object.identifierId,
      specifiedType: const FullType(int),
    );
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
      specifiedType: const FullType(ClientIdentifierStatusEnum),
    );
    yield r'derivedStatus';
    yield serializers.serialize(
      object.derivedStatus,
      specifiedType: const FullType(ClientIdentifierDerivedStatusEnum),
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
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ClientIdentifier object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ClientIdentifierBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'identifierId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.identifierId = valueDes;
          break;
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
            specifiedType: const FullType(ClientIdentifierStatusEnum),
          ) as ClientIdentifierStatusEnum;
          result.status = valueDes;
          break;
        case r'derivedStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ClientIdentifierDerivedStatusEnum),
          ) as ClientIdentifierDerivedStatusEnum;
          result.derivedStatus = valueDes;
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
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ClientIdentifier deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ClientIdentifierBuilder();
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


/// Fineract 记录状态
class ClientIdentifierStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const ClientIdentifierStatusEnum ACTIVE = _$clientIdentifierStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'INACTIVE')
  static const ClientIdentifierStatusEnum INACTIVE = _$clientIdentifierStatusEnum_INACTIVE;

  static Serializer<ClientIdentifierStatusEnum> get serializer => _$clientIdentifierStatusEnumSerializer;

  const ClientIdentifierStatusEnum._(String name): super(name);

  static BuiltSet<ClientIdentifierStatusEnum> get values => _$clientIdentifierStatusEnumValues;
  static ClientIdentifierStatusEnum valueOf(String name) => _$clientIdentifierStatusEnumValueOf(name);
}

/// 到期状态推导值（expiryDate 对业务日期比较）
class ClientIdentifierDerivedStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VALID')
  static const ClientIdentifierDerivedStatusEnum VALID = _$clientIdentifierDerivedStatusEnum_VALID;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const ClientIdentifierDerivedStatusEnum EXPIRED = _$clientIdentifierDerivedStatusEnum_EXPIRED;

  static Serializer<ClientIdentifierDerivedStatusEnum> get serializer => _$clientIdentifierDerivedStatusEnumSerializer;

  const ClientIdentifierDerivedStatusEnum._(String name): super(name);

  static BuiltSet<ClientIdentifierDerivedStatusEnum> get values => _$clientIdentifierDerivedStatusEnumValues;
  static ClientIdentifierDerivedStatusEnum valueOf(String name) => _$clientIdentifierDerivedStatusEnumValueOf(name);
}

