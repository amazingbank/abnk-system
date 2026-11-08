//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'loan_application_result.g.dart';

/// 贷款申请受理结果
///
/// Properties:
/// * [loanId] 
/// * [status] - 初始状态（Submitted and pending approval）
@BuiltValue()
abstract class LoanApplicationResult implements Built<LoanApplicationResult, LoanApplicationResultBuilder> {
  @BuiltValueField(wireName: r'loanId')
  int get loanId;

  /// 初始状态（Submitted and pending approval）
  @BuiltValueField(wireName: r'status')
  String get status;

  LoanApplicationResult._();

  factory LoanApplicationResult([void updates(LoanApplicationResultBuilder b)]) = _$LoanApplicationResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoanApplicationResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoanApplicationResult> get serializer => _$LoanApplicationResultSerializer();
}

class _$LoanApplicationResultSerializer implements PrimitiveSerializer<LoanApplicationResult> {
  @override
  final Iterable<Type> types = const [LoanApplicationResult, _$LoanApplicationResult];

  @override
  final String wireName = r'LoanApplicationResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoanApplicationResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    LoanApplicationResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoanApplicationResultBuilder result,
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
  LoanApplicationResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoanApplicationResultBuilder();
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


