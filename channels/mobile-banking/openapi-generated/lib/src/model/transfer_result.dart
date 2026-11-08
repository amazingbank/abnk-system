//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'transfer_result.g.dart';

/// 转账结果（幂等重放返回同值）
///
/// Properties:
/// * [transactionId] - 转出账户流水号（withdrawal 交易 ID）
/// * [newSourceBalance] - 转出账户新余额
@BuiltValue()
abstract class TransferResult implements Built<TransferResult, TransferResultBuilder> {
  /// 转出账户流水号（withdrawal 交易 ID）
  @BuiltValueField(wireName: r'transactionId')
  int get transactionId;

  /// 转出账户新余额
  @BuiltValueField(wireName: r'newSourceBalance')
  num get newSourceBalance;

  TransferResult._();

  factory TransferResult([void updates(TransferResultBuilder b)]) = _$TransferResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TransferResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TransferResult> get serializer => _$TransferResultSerializer();
}

class _$TransferResultSerializer implements PrimitiveSerializer<TransferResult> {
  @override
  final Iterable<Type> types = const [TransferResult, _$TransferResult];

  @override
  final String wireName = r'TransferResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TransferResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'transactionId';
    yield serializers.serialize(
      object.transactionId,
      specifiedType: const FullType(int),
    );
    yield r'newSourceBalance';
    yield serializers.serialize(
      object.newSourceBalance,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TransferResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TransferResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'transactionId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.transactionId = valueDes;
          break;
        case r'newSourceBalance':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.newSourceBalance = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TransferResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TransferResultBuilder();
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


