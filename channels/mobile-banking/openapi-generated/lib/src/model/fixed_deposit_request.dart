//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fixed_deposit_request.g.dart';

/// 定期开户请求（从源活期账户扣款转入新定期账户）
///
/// Properties:
/// * [productId] - 定期存款产品 ID
/// * [sourceAccountId] - 扣款源活期账户（须为本人账户）
/// * [amount] - 存入金额（须 ≥ 产品起存金额且 ≤ 源账户可用余额）
@BuiltValue()
abstract class FixedDepositRequest implements Built<FixedDepositRequest, FixedDepositRequestBuilder> {
  /// 定期存款产品 ID
  @BuiltValueField(wireName: r'productId')
  int get productId;

  /// 扣款源活期账户（须为本人账户）
  @BuiltValueField(wireName: r'sourceAccountId')
  int get sourceAccountId;

  /// 存入金额（须 ≥ 产品起存金额且 ≤ 源账户可用余额）
  @BuiltValueField(wireName: r'amount')
  num get amount;

  FixedDepositRequest._();

  factory FixedDepositRequest([void updates(FixedDepositRequestBuilder b)]) = _$FixedDepositRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FixedDepositRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FixedDepositRequest> get serializer => _$FixedDepositRequestSerializer();
}

class _$FixedDepositRequestSerializer implements PrimitiveSerializer<FixedDepositRequest> {
  @override
  final Iterable<Type> types = const [FixedDepositRequest, _$FixedDepositRequest];

  @override
  final String wireName = r'FixedDepositRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FixedDepositRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'productId';
    yield serializers.serialize(
      object.productId,
      specifiedType: const FullType(int),
    );
    yield r'sourceAccountId';
    yield serializers.serialize(
      object.sourceAccountId,
      specifiedType: const FullType(int),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FixedDepositRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FixedDepositRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'productId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.productId = valueDes;
          break;
        case r'sourceAccountId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sourceAccountId = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.amount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FixedDepositRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FixedDepositRequestBuilder();
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


