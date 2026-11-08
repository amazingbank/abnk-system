//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fixed_deposit_summary.g.dart';

/// 定期账户概要（内部面）
///
/// Properties:
/// * [id] 
/// * [accountNo] 
/// * [productName] 
/// * [accountBalance] 
/// * [interestRate] 
/// * [maturityDate] 
/// * [status] 
@BuiltValue()
abstract class FixedDepositSummary implements Built<FixedDepositSummary, FixedDepositSummaryBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'accountNo')
  String get accountNo;

  @BuiltValueField(wireName: r'productName')
  String get productName;

  @BuiltValueField(wireName: r'accountBalance')
  num get accountBalance;

  @BuiltValueField(wireName: r'interestRate')
  num get interestRate;

  @BuiltValueField(wireName: r'maturityDate')
  Date get maturityDate;

  @BuiltValueField(wireName: r'status')
  String get status;

  FixedDepositSummary._();

  factory FixedDepositSummary([void updates(FixedDepositSummaryBuilder b)]) = _$FixedDepositSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FixedDepositSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FixedDepositSummary> get serializer => _$FixedDepositSummarySerializer();
}

class _$FixedDepositSummarySerializer implements PrimitiveSerializer<FixedDepositSummary> {
  @override
  final Iterable<Type> types = const [FixedDepositSummary, _$FixedDepositSummary];

  @override
  final String wireName = r'FixedDepositSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FixedDepositSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'accountNo';
    yield serializers.serialize(
      object.accountNo,
      specifiedType: const FullType(String),
    );
    yield r'productName';
    yield serializers.serialize(
      object.productName,
      specifiedType: const FullType(String),
    );
    yield r'accountBalance';
    yield serializers.serialize(
      object.accountBalance,
      specifiedType: const FullType(num),
    );
    yield r'interestRate';
    yield serializers.serialize(
      object.interestRate,
      specifiedType: const FullType(num),
    );
    yield r'maturityDate';
    yield serializers.serialize(
      object.maturityDate,
      specifiedType: const FullType(Date),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FixedDepositSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FixedDepositSummaryBuilder result,
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
        case r'accountNo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accountNo = valueDes;
          break;
        case r'productName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.productName = valueDes;
          break;
        case r'accountBalance':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.accountBalance = valueDes;
          break;
        case r'interestRate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.interestRate = valueDes;
          break;
        case r'maturityDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.maturityDate = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FixedDepositSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FixedDepositSummaryBuilder();
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


