//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fixed_deposit_product.g.dart';

/// 定期存款产品（利率 chart 收敛为单一数值）
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [description] 
/// * [interestRate] - 年利率（%）
/// * [depositPeriod] - 存期（月）
/// * [minDepositAmount] - 起存金额
@BuiltValue()
abstract class FixedDepositProduct implements Built<FixedDepositProduct, FixedDepositProductBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'description')
  String get description;

  /// 年利率（%）
  @BuiltValueField(wireName: r'interestRate')
  num get interestRate;

  /// 存期（月）
  @BuiltValueField(wireName: r'depositPeriod')
  int get depositPeriod;

  /// 起存金额
  @BuiltValueField(wireName: r'minDepositAmount')
  num get minDepositAmount;

  FixedDepositProduct._();

  factory FixedDepositProduct([void updates(FixedDepositProductBuilder b)]) = _$FixedDepositProduct;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FixedDepositProductBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FixedDepositProduct> get serializer => _$FixedDepositProductSerializer();
}

class _$FixedDepositProductSerializer implements PrimitiveSerializer<FixedDepositProduct> {
  @override
  final Iterable<Type> types = const [FixedDepositProduct, _$FixedDepositProduct];

  @override
  final String wireName = r'FixedDepositProduct';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FixedDepositProduct object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'interestRate';
    yield serializers.serialize(
      object.interestRate,
      specifiedType: const FullType(num),
    );
    yield r'depositPeriod';
    yield serializers.serialize(
      object.depositPeriod,
      specifiedType: const FullType(int),
    );
    yield r'minDepositAmount';
    yield serializers.serialize(
      object.minDepositAmount,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FixedDepositProduct object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FixedDepositProductBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'interestRate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.interestRate = valueDes;
          break;
        case r'depositPeriod':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.depositPeriod = valueDes;
          break;
        case r'minDepositAmount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.minDepositAmount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FixedDepositProduct deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FixedDepositProductBuilder();
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


