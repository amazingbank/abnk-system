//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/client_summary.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'client_list_result.g.dart';

/// 客户列表结果
///
/// Properties:
/// * [total] 
/// * [items] 
@BuiltValue()
abstract class ClientListResult implements Built<ClientListResult, ClientListResultBuilder> {
  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'items')
  BuiltList<ClientSummary> get items;

  ClientListResult._();

  factory ClientListResult([void updates(ClientListResultBuilder b)]) = _$ClientListResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ClientListResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ClientListResult> get serializer => _$ClientListResultSerializer();
}

class _$ClientListResultSerializer implements PrimitiveSerializer<ClientListResult> {
  @override
  final Iterable<Type> types = const [ClientListResult, _$ClientListResult];

  @override
  final String wireName = r'ClientListResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ClientListResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(ClientSummary)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ClientListResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ClientListResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ClientSummary)]),
          ) as BuiltList<ClientSummary>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ClientListResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ClientListResultBuilder();
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


