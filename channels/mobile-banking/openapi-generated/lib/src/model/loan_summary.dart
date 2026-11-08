//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'loan_summary.g.dart';

/// 贷款概要（含逾期分档——P0.3 客户 C 口径）
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
@BuiltValue(instantiable: false)
abstract class LoanSummary  {
  @BuiltValueField(wireName: r'loanId')
  int get loanId;

  @BuiltValueField(wireName: r'externalId')
  String get externalId;

  @BuiltValueField(wireName: r'productName')
  String get productName;

  @BuiltValueField(wireName: r'principal')
  num get principal;

  @BuiltValueField(wireName: r'interestRate')
  num get interestRate;

  @BuiltValueField(wireName: r'termMonths')
  int get termMonths;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'inArrears')
  bool get inArrears;

  /// 逾期天数（无逾期为 0）
  @BuiltValueField(wireName: r'overdueDays')
  int get overdueDays;

  /// 逾期起始日（无逾期为 null）
  @BuiltValueField(wireName: r'overdueSinceDate')
  Date? get overdueSinceDate;

  /// 逾期总额（无逾期为 0）
  @BuiltValueField(wireName: r'totalOverdue')
  num get totalOverdue;

  /// 逾期分档（ABNK_POC_OD 等 P0.3 分档口径；无逾期为 null）
  @BuiltValueField(wireName: r'delinquencyClassification')
  String? get delinquencyClassification;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoanSummary> get serializer => _$LoanSummarySerializer();
}

class _$LoanSummarySerializer implements PrimitiveSerializer<LoanSummary> {
  @override
  final Iterable<Type> types = const [LoanSummary];

  @override
  final String wireName = r'LoanSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoanSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'loanId';
    yield serializers.serialize(
      object.loanId,
      specifiedType: const FullType(int),
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
    yield r'interestRate';
    yield serializers.serialize(
      object.interestRate,
      specifiedType: const FullType(num),
    );
    yield r'termMonths';
    yield serializers.serialize(
      object.termMonths,
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
    yield r'overdueDays';
    yield serializers.serialize(
      object.overdueDays,
      specifiedType: const FullType(int),
    );
    if (object.overdueSinceDate != null) {
      yield r'overdueSinceDate';
      yield serializers.serialize(
        object.overdueSinceDate,
        specifiedType: const FullType.nullable(Date),
      );
    }
    yield r'totalOverdue';
    yield serializers.serialize(
      object.totalOverdue,
      specifiedType: const FullType(num),
    );
    if (object.delinquencyClassification != null) {
      yield r'delinquencyClassification';
      yield serializers.serialize(
        object.delinquencyClassification,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    LoanSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  @override
  LoanSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.deserialize(serialized, specifiedType: FullType($LoanSummary)) as $LoanSummary;
  }
}


/// a concrete implementation of [LoanSummary], since [LoanSummary] is not instantiable
@BuiltValue(instantiable: true)
abstract class $LoanSummary implements LoanSummary, Built<$LoanSummary, $LoanSummaryBuilder> {
  $LoanSummary._();

  factory $LoanSummary([void Function($LoanSummaryBuilder)? updates]) = _$$LoanSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($LoanSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<$LoanSummary> get serializer => _$$LoanSummarySerializer();
}

class _$$LoanSummarySerializer implements PrimitiveSerializer<$LoanSummary> {
  @override
  final Iterable<Type> types = const [$LoanSummary, _$$LoanSummary];

  @override
  final String wireName = r'$LoanSummary';

  @override
  Object serialize(
    Serializers serializers,
    $LoanSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.serialize(object, specifiedType: FullType(LoanSummary))!;
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoanSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'loanId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.loanId = valueDes;
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
        case r'interestRate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.interestRate = valueDes;
          break;
        case r'termMonths':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.termMonths = valueDes;
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
        case r'overdueDays':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.overdueDays = valueDes;
          break;
        case r'overdueSinceDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.overdueSinceDate = valueDes;
          break;
        case r'totalOverdue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.totalOverdue = valueDes;
          break;
        case r'delinquencyClassification':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.delinquencyClassification = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  $LoanSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = $LoanSummaryBuilder();
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

