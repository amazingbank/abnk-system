//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'transaction_item.g.dart';

/// 单笔交易明细（P0.2 VP0.2.4 实测字段口径：runningBalance 保留）
///
/// Properties:
/// * [id] 
/// * [date] 
/// * [transactionType] - 交易类型（Deposit / Withdrawal / InterestPosting 等 Fineract 枚举值）
/// * [amount] 
/// * [runningBalance] - 该笔交易入账后的账户余额
/// * [note] 
@BuiltValue()
abstract class TransactionItem implements Built<TransactionItem, TransactionItemBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'date')
  Date get date;

  /// 交易类型（Deposit / Withdrawal / InterestPosting 等 Fineract 枚举值）
  @BuiltValueField(wireName: r'transactionType')
  String get transactionType;

  @BuiltValueField(wireName: r'amount')
  num get amount;

  /// 该笔交易入账后的账户余额
  @BuiltValueField(wireName: r'runningBalance')
  num get runningBalance;

  @BuiltValueField(wireName: r'note')
  String? get note;

  TransactionItem._();

  factory TransactionItem([void updates(TransactionItemBuilder b)]) = _$TransactionItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TransactionItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TransactionItem> get serializer => _$TransactionItemSerializer();
}

class _$TransactionItemSerializer implements PrimitiveSerializer<TransactionItem> {
  @override
  final Iterable<Type> types = const [TransactionItem, _$TransactionItem];

  @override
  final String wireName = r'TransactionItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TransactionItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(Date),
    );
    yield r'transactionType';
    yield serializers.serialize(
      object.transactionType,
      specifiedType: const FullType(String),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(num),
    );
    yield r'runningBalance';
    yield serializers.serialize(
      object.runningBalance,
      specifiedType: const FullType(num),
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
    TransactionItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TransactionItemBuilder result,
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
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.date = valueDes;
          break;
        case r'transactionType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.transactionType = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.amount = valueDes;
          break;
        case r'runningBalance':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.runningBalance = valueDes;
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
  TransactionItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TransactionItemBuilder();
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


