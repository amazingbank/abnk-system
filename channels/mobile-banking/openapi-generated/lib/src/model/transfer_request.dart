//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'transfer_request.g.dart';

/// 本人账户间转账请求。路径参数 `id` 为转出账户；`externalId` 为客户端幂等键 （重放返回首次结果——P2.4 幂等语义）。 
///
/// Properties:
/// * [toAccountId] - 转入账户（须为本人账户，否则 403）
/// * [amount] - 转账金额（须大于 0）
/// * [externalId] - 幂等键（客户端生成，如 UUID；网关派生 `<key>-w`/`<key>-d` 落账）
/// * [note] - 附言（可选）
@BuiltValue()
abstract class TransferRequest implements Built<TransferRequest, TransferRequestBuilder> {
  /// 转入账户（须为本人账户，否则 403）
  @BuiltValueField(wireName: r'toAccountId')
  int get toAccountId;

  /// 转账金额（须大于 0）
  @BuiltValueField(wireName: r'amount')
  num get amount;

  /// 幂等键（客户端生成，如 UUID；网关派生 `<key>-w`/`<key>-d` 落账）
  @BuiltValueField(wireName: r'externalId')
  String get externalId;

  /// 附言（可选）
  @BuiltValueField(wireName: r'note')
  String? get note;

  TransferRequest._();

  factory TransferRequest([void updates(TransferRequestBuilder b)]) = _$TransferRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TransferRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TransferRequest> get serializer => _$TransferRequestSerializer();
}

class _$TransferRequestSerializer implements PrimitiveSerializer<TransferRequest> {
  @override
  final Iterable<Type> types = const [TransferRequest, _$TransferRequest];

  @override
  final String wireName = r'TransferRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TransferRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'toAccountId';
    yield serializers.serialize(
      object.toAccountId,
      specifiedType: const FullType(int),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(num),
    );
    yield r'externalId';
    yield serializers.serialize(
      object.externalId,
      specifiedType: const FullType(String),
    );
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    TransferRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TransferRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'toAccountId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.toAccountId = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.amount = valueDes;
          break;
        case r'externalId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.externalId = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TransferRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TransferRequestBuilder();
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


