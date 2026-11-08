//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/loan_summary.dart';
import 'package:openapi/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'loan_ops_item.g.dart';

/// 贷款运营列表行（LoanSummary + 客户投影）
///
/// Properties:
/// * [loanId] 
/// * [externalId] 
/// * [productName] 
/// * [principal] 
/// * [interestRate] 
/// * [termMonths] 
/// * [status] 
/// * [inArrears] 
/// * [overdueDays] - 逾期天数（无逾期为 0）
/// * [overdueSinceDate] - 逾期起始日（无逾期为 null）
/// * [totalOverdue] - 逾期总额（无逾期为 0）
/// * [delinquencyClassification] - 逾期分档（ABNK_POC_OD 等 P0.3 分档口径；无逾期为 null）
/// * [clientId] 
/// * [clientName] 
@BuiltValue()
abstract class LoanOpsItem implements LoanSummary, Built<LoanOpsItem, LoanOpsItemBuilder> {
  @BuiltValueField(wireName: r'clientId')
  int get clientId;

  @BuiltValueField(wireName: r'clientName')
  String get clientName;

  LoanOpsItem._();

  factory LoanOpsItem([void updates(LoanOpsItemBuilder b)]) = _$LoanOpsItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoanOpsItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoanOpsItem> get serializer => _$LoanOpsItemSerializer();
}

class _$LoanOpsItemSerializer implements PrimitiveSerializer<LoanOpsItem> {
  @override
  final Iterable<Type> types = const [LoanOpsItem, _$LoanOpsItem];

  @override
  final String wireName = r'LoanOpsItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoanOpsItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'interestRate';
    yield serializers.serialize(
      object.interestRate,
      specifiedType: const FullType(num),
    );
    yield r'clientId';
    yield serializers.serialize(
      object.clientId,
      specifiedType: const FullType(int),
    );
    yield r'clientName';
    yield serializers.serialize(
      object.clientName,
      specifiedType: const FullType(String),
    );
    yield r'externalId';
    yield serializers.serialize(
      object.externalId,
      specifiedType: const FullType(String),
    );
    yield r'productName';
    yield serializers.serialize(
      object.productName,
      specifiedType: const FullType(String),
    );
    yield r'principal';
    yield serializers.serialize(
      object.principal,
      specifiedType: const FullType(num),
    );
    yield r'totalOverdue';
    yield serializers.serialize(
      object.totalOverdue,
      specifiedType: const FullType(num),
    );
    yield r'termMonths';
    yield serializers.serialize(
      object.termMonths,
      specifiedType: const FullType(int),
    );
    yield r'overdueDays';
    yield serializers.serialize(
      object.overdueDays,
      specifiedType: const FullType(int),
    );
    if (object.delinquencyClassification != null) {
      yield r'delinquencyClassification';
      yield serializers.serialize(
        object.delinquencyClassification,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'loanId';
    yield serializers.serialize(
      object.loanId,
      specifiedType: const FullType(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'inArrears';
    yield serializers.serialize(
      object.inArrears,
      specifiedType: const FullType(bool),
    );
    if (object.overdueSinceDate != null) {
      yield r'overdueSinceDate';
      yield serializers.serialize(
        object.overdueSinceDate,
        specifiedType: const FullType.nullable(Date),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    LoanOpsItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoanOpsItemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'interestRate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.interestRate = valueDes;
          break;
        case r'clientId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.clientId = valueDes;
          break;
        case r'clientName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.clientName = valueDes;
          break;
        case r'externalId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.externalId = valueDes;
          break;
        case r'productName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.productName = valueDes;
          break;
        case r'principal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.principal = valueDes;
          break;
        case r'totalOverdue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.totalOverdue = valueDes;
          break;
        case r'termMonths':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.termMonths = valueDes;
          break;
        case r'overdueDays':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.overdueDays = valueDes;
          break;
        case r'delinquencyClassification':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.delinquencyClassification = valueDes;
          break;
        case r'loanId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.loanId = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'inArrears':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.inArrears = valueDes;
          break;
        case r'overdueSinceDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.overdueSinceDate = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LoanOpsItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoanOpsItemBuilder();
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


