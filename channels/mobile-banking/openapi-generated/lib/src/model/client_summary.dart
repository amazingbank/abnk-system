//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'client_summary.g.dart';

/// 客户列表行（列表页最小投影 + 证照状态列）
///
/// Properties:
/// * [clientId] 
/// * [externalId] 
/// * [displayName] 
/// * [mobileNo] 
/// * [officeName] 
/// * [status] - 客户状态（Active 等 Fineract 状态值）
/// * [identifierStatus] - 首证照到期状态推导值（无证照为 null）
/// * [identifierExpiryDate] - 首证照到期日（无证照为 null）
@BuiltValue()
abstract class ClientSummary implements Built<ClientSummary, ClientSummaryBuilder> {
  @BuiltValueField(wireName: r'clientId')
  int get clientId;

  @BuiltValueField(wireName: r'externalId')
  String get externalId;

  @BuiltValueField(wireName: r'displayName')
  String get displayName;

  @BuiltValueField(wireName: r'mobileNo')
  String get mobileNo;

  @BuiltValueField(wireName: r'officeName')
  String get officeName;

  /// 客户状态（Active 等 Fineract 状态值）
  @BuiltValueField(wireName: r'status')
  String get status;

  /// 首证照到期状态推导值（无证照为 null）
  @BuiltValueField(wireName: r'identifierStatus')
  ClientSummaryIdentifierStatusEnum? get identifierStatus;
  // enum identifierStatusEnum {  VALID,  EXPIRED,  ,  };

  /// 首证照到期日（无证照为 null）
  @BuiltValueField(wireName: r'identifierExpiryDate')
  Date? get identifierExpiryDate;

  ClientSummary._();

  factory ClientSummary([void updates(ClientSummaryBuilder b)]) = _$ClientSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ClientSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ClientSummary> get serializer => _$ClientSummarySerializer();
}

class _$ClientSummarySerializer implements PrimitiveSerializer<ClientSummary> {
  @override
  final Iterable<Type> types = const [ClientSummary, _$ClientSummary];

  @override
  final String wireName = r'ClientSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ClientSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'clientId';
    yield serializers.serialize(
      object.clientId,
      specifiedType: const FullType(int),
    );
    yield r'externalId';
    yield serializers.serialize(
      object.externalId,
      specifiedType: const FullType(String),
    );
    yield r'displayName';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'mobileNo';
    yield serializers.serialize(
      object.mobileNo,
      specifiedType: const FullType(String),
    );
    yield r'officeName';
    yield serializers.serialize(
      object.officeName,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    if (object.identifierStatus != null) {
      yield r'identifierStatus';
      yield serializers.serialize(
        object.identifierStatus,
        specifiedType: const FullType.nullable(ClientSummaryIdentifierStatusEnum),
      );
    }
    if (object.identifierExpiryDate != null) {
      yield r'identifierExpiryDate';
      yield serializers.serialize(
        object.identifierExpiryDate,
        specifiedType: const FullType.nullable(Date),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ClientSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ClientSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'clientId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.clientId = valueDes;
          break;
        case r'externalId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.externalId = valueDes;
          break;
        case r'displayName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'mobileNo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mobileNo = valueDes;
          break;
        case r'officeName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.officeName = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'identifierStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ClientSummaryIdentifierStatusEnum),
          ) as ClientSummaryIdentifierStatusEnum?;
          if (valueDes == null) continue;
          result.identifierStatus = valueDes;
          break;
        case r'identifierExpiryDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.identifierExpiryDate = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ClientSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ClientSummaryBuilder();
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


/// 首证照到期状态推导值（无证照为 null）
class ClientSummaryIdentifierStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VALID')
  static const ClientSummaryIdentifierStatusEnum VALID = _$clientSummaryIdentifierStatusEnum_VALID;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const ClientSummaryIdentifierStatusEnum EXPIRED = _$clientSummaryIdentifierStatusEnum_EXPIRED;

  static Serializer<ClientSummaryIdentifierStatusEnum> get serializer => _$clientSummaryIdentifierStatusEnumSerializer;

  const ClientSummaryIdentifierStatusEnum._(String name): super(name);

  static BuiltSet<ClientSummaryIdentifierStatusEnum> get values => _$clientSummaryIdentifierStatusEnumValues;
  static ClientSummaryIdentifierStatusEnum valueOf(String name) => _$clientSummaryIdentifierStatusEnumValueOf(name);
}

