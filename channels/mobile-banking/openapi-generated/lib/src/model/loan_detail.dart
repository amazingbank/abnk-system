//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'loan_detail.g.dart';

/// 贷款详情（对客收敛口径）
///
/// Properties:
/// * [loanId] 
/// * [productName] 
/// * [principal] 
/// * [interestRate] 
/// * [termMonths] 
/// * [status] - 贷款状态（Submitted and pending approval / Approved / Active 等 Fineract 状态值）
/// * [submittedOnDate] 
/// * [disbursedOnDate] - 放款日（未放款为 null）
/// * [totalOutstanding] - 未偿总额（未放款为 null）
@BuiltValue()
abstract class LoanDetail implements Built<LoanDetail, LoanDetailBuilder> {
  @BuiltValueField(wireName: r'loanId')
  int get loanId;

  @BuiltValueField(wireName: r'productName')
  String get productName;

  @BuiltValueField(wireName: r'principal')
  num get principal;

  @BuiltValueField(wireName: r'interestRate')
  num get interestRate;

  @BuiltValueField(wireName: r'termMonths')
  int get termMonths;

  /// 贷款状态（Submitted and pending approval / Approved / Active 等 Fineract 状态值）
  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'submittedOnDate')
  Date get submittedOnDate;

  /// 放款日（未放款为 null）
  @BuiltValueField(wireName: r'disbursedOnDate')
  Date? get disbursedOnDate;

  /// 未偿总额（未放款为 null）
  @BuiltValueField(wireName: r'totalOutstanding')
  num? get totalOutstanding;

  LoanDetail._();

  factory LoanDetail([void updates(LoanDetailBuilder b)]) = _$LoanDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoanDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoanDetail> get serializer => _$LoanDetailSerializer();
}

class _$LoanDetailSerializer implements PrimitiveSerializer<LoanDetail> {
  @override
  final Iterable<Type> types = const [LoanDetail, _$LoanDetail];

  @override
  final String wireName = r'LoanDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoanDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'loanId';
    yield serializers.serialize(
      object.loanId,
      specifiedType: const FullType(int),
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
    yield r'submittedOnDate';
    yield serializers.serialize(
      object.submittedOnDate,
      specifiedType: const FullType(Date),
    );
    if (object.disbursedOnDate != null) {
      yield r'disbursedOnDate';
      yield serializers.serialize(
        object.disbursedOnDate,
        specifiedType: const FullType(Date),
      );
    }
    if (object.totalOutstanding != null) {
      yield r'totalOutstanding';
      yield serializers.serialize(
        object.totalOutstanding,
        specifiedType: const FullType(num),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    LoanDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoanDetailBuilder result,
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
        case r'submittedOnDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.submittedOnDate = valueDes;
          break;
        case r'disbursedOnDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.disbursedOnDate = valueDes;
          break;
        case r'totalOutstanding':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.totalOutstanding = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LoanDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoanDetailBuilder();
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


