//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'identifier_update_payload.g.dart';

/// 证照更新载荷（P0.2 VP0.2.1 实测口径：expiryDate 为核心可变更字段； Fineract 侧 locale/dateFormat 由网关注入）。 
///
/// Properties:
/// * [expiryDate] - 新到期日（YYYY-MM-DD）
/// * [documentKey] - 证件号（可选——变更时提供）
/// * [description] 
@BuiltValue()
abstract class IdentifierUpdatePayload implements Built<IdentifierUpdatePayload, IdentifierUpdatePayloadBuilder> {
  /// 新到期日（YYYY-MM-DD）
  @BuiltValueField(wireName: r'expiryDate')
  Date get expiryDate;

  /// 证件号（可选——变更时提供）
  @BuiltValueField(wireName: r'documentKey')
  String? get documentKey;

  @BuiltValueField(wireName: r'description')
  String? get description;

  IdentifierUpdatePayload._();

  factory IdentifierUpdatePayload([void updates(IdentifierUpdatePayloadBuilder b)]) = _$IdentifierUpdatePayload;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(IdentifierUpdatePayloadBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<IdentifierUpdatePayload> get serializer => _$IdentifierUpdatePayloadSerializer();
}

class _$IdentifierUpdatePayloadSerializer implements PrimitiveSerializer<IdentifierUpdatePayload> {
  @override
  final Iterable<Type> types = const [IdentifierUpdatePayload, _$IdentifierUpdatePayload];

  @override
  final String wireName = r'IdentifierUpdatePayload';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    IdentifierUpdatePayload object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'expiryDate';
    yield serializers.serialize(
      object.expiryDate,
      specifiedType: const FullType(Date),
    );
    if (object.documentKey != null) {
      yield r'documentKey';
      yield serializers.serialize(
        object.documentKey,
        specifiedType: const FullType(String),
      );
    }
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
    IdentifierUpdatePayload object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required IdentifierUpdatePayloadBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'expiryDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.expiryDate = valueDes;
          break;
        case r'documentKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.documentKey = valueDes;
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
  IdentifierUpdatePayload deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = IdentifierUpdatePayloadBuilder();
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


