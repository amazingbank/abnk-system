//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'loan_product.g.dart';

/// 消费贷产品（对客收敛字段——隐藏内部配置）
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [description] 
/// * [interestRate] - 年利率（%）
/// * [termFrequency] - 期限数值（默认 12）
/// * [termPeriodFrequencyType] 
/// * [minPrincipalAmount] 
/// * [maxPrincipalAmount] 
/// * [repaymentMethod] - 还款方式（等额本息）
@BuiltValue()
abstract class LoanProduct implements Built<LoanProduct, LoanProductBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'description')
  String get description;

  /// 年利率（%）
  @BuiltValueField(wireName: r'interestRate')
  num get interestRate;

  /// 期限数值（默认 12）
  @BuiltValueField(wireName: r'termFrequency')
  int get termFrequency;

  @BuiltValueField(wireName: r'termPeriodFrequencyType')
  LoanProductTermPeriodFrequencyTypeEnum get termPeriodFrequencyType;
  // enum termPeriodFrequencyTypeEnum {  MONTHS,  };

  @BuiltValueField(wireName: r'minPrincipalAmount')
  num get minPrincipalAmount;

  @BuiltValueField(wireName: r'maxPrincipalAmount')
  num get maxPrincipalAmount;

  /// 还款方式（等额本息）
  @BuiltValueField(wireName: r'repaymentMethod')
  LoanProductRepaymentMethodEnum get repaymentMethod;
  // enum repaymentMethodEnum {  EQUAL_INSTALLMENTS,  };

  LoanProduct._();

  factory LoanProduct([void updates(LoanProductBuilder b)]) = _$LoanProduct;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoanProductBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoanProduct> get serializer => _$LoanProductSerializer();
}

class _$LoanProductSerializer implements PrimitiveSerializer<LoanProduct> {
  @override
  final Iterable<Type> types = const [LoanProduct, _$LoanProduct];

  @override
  final String wireName = r'LoanProduct';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoanProduct object, {
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
    yield r'termFrequency';
    yield serializers.serialize(
      object.termFrequency,
      specifiedType: const FullType(int),
    );
    yield r'termPeriodFrequencyType';
    yield serializers.serialize(
      object.termPeriodFrequencyType,
      specifiedType: const FullType(LoanProductTermPeriodFrequencyTypeEnum),
    );
    yield r'minPrincipalAmount';
    yield serializers.serialize(
      object.minPrincipalAmount,
      specifiedType: const FullType(num),
    );
    yield r'maxPrincipalAmount';
    yield serializers.serialize(
      object.maxPrincipalAmount,
      specifiedType: const FullType(num),
    );
    yield r'repaymentMethod';
    yield serializers.serialize(
      object.repaymentMethod,
      specifiedType: const FullType(LoanProductRepaymentMethodEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LoanProduct object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoanProductBuilder result,
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
        case r'termFrequency':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.termFrequency = valueDes;
          break;
        case r'termPeriodFrequencyType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LoanProductTermPeriodFrequencyTypeEnum),
          ) as LoanProductTermPeriodFrequencyTypeEnum;
          result.termPeriodFrequencyType = valueDes;
          break;
        case r'minPrincipalAmount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.minPrincipalAmount = valueDes;
          break;
        case r'maxPrincipalAmount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.maxPrincipalAmount = valueDes;
          break;
        case r'repaymentMethod':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LoanProductRepaymentMethodEnum),
          ) as LoanProductRepaymentMethodEnum;
          result.repaymentMethod = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LoanProduct deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoanProductBuilder();
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


class LoanProductTermPeriodFrequencyTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'MONTHS')
  static const LoanProductTermPeriodFrequencyTypeEnum MONTHS = _$loanProductTermPeriodFrequencyTypeEnum_MONTHS;

  static Serializer<LoanProductTermPeriodFrequencyTypeEnum> get serializer => _$loanProductTermPeriodFrequencyTypeEnumSerializer;

  const LoanProductTermPeriodFrequencyTypeEnum._(String name): super(name);

  static BuiltSet<LoanProductTermPeriodFrequencyTypeEnum> get values => _$loanProductTermPeriodFrequencyTypeEnumValues;
  static LoanProductTermPeriodFrequencyTypeEnum valueOf(String name) => _$loanProductTermPeriodFrequencyTypeEnumValueOf(name);
}

/// 还款方式（等额本息）
class LoanProductRepaymentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'EQUAL_INSTALLMENTS')
  static const LoanProductRepaymentMethodEnum EQUAL_INSTALLMENTS = _$loanProductRepaymentMethodEnum_EQUAL_INSTALLMENTS;

  static Serializer<LoanProductRepaymentMethodEnum> get serializer => _$loanProductRepaymentMethodEnumSerializer;

  const LoanProductRepaymentMethodEnum._(String name): super(name);

  static BuiltSet<LoanProductRepaymentMethodEnum> get values => _$loanProductRepaymentMethodEnumValues;
  static LoanProductRepaymentMethodEnum valueOf(String name) => _$loanProductRepaymentMethodEnumValueOf(name);
}

