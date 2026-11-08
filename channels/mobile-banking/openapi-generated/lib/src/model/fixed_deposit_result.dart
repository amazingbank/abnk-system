//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fixed_deposit_result.g.dart';

/// 定期开户结果
///
/// Properties:
/// * [accountId] - 新建定期账户 ID
/// * [maturityDate] - 到期日（对年对月对日）
@BuiltValue()
abstract class FixedDepositResult implements Built<FixedDepositResult, FixedDepositResultBuilder> {
  /// 新建定期账户 ID
  @BuiltValueField(wireName: r'accountId')
  int get accountId;

  /// 到期日（对年对月对日）
  @BuiltValueField(wireName: r'maturityDate')
  Date get maturityDate;

  FixedDepositResult._();

  factory FixedDepositResult([void updates(FixedDepositResultBuilder b)]) = _$FixedDepositResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FixedDepositResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FixedDepositResult> get serializer => _$FixedDepositResultSerializer();
}

class _$FixedDepositResultSerializer implements PrimitiveSerializer<FixedDepositResult> {
  @override
  final Iterable<Type> types = const [FixedDepositResult, _$FixedDepositResult];

  @override
  final String wireName = r'FixedDepositResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FixedDepositResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'accountId';
    yield serializers.serialize(
      object.accountId,
      specifiedType: const FullType(int),
    );
    yield r'maturityDate';
    yield serializers.serialize(
      object.maturityDate,
      specifiedType: const FullType(Date),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FixedDepositResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FixedDepositResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accountId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.accountId = valueDes;
          break;
        case r'maturityDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.maturityDate = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FixedDepositResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FixedDepositResultBuilder();
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


