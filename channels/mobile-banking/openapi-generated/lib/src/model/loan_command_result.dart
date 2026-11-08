//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'loan_command_result.g.dart';

/// 贷款命令执行结果（网关收敛口径）
///
/// Properties:
/// * [loanId] 
/// * [status] - 命令执行后的贷款状态（Approved / Active 等）
/// * [processedOnDate] - 命令生效日（审批日 / 放款日）
@BuiltValue()
abstract class LoanCommandResult implements Built<LoanCommandResult, LoanCommandResultBuilder> {
  @BuiltValueField(wireName: r'loanId')
  int get loanId;

  /// 命令执行后的贷款状态（Approved / Active 等）
  @BuiltValueField(wireName: r'status')
  String get status;

  /// 命令生效日（审批日 / 放款日）
  @BuiltValueField(wireName: r'processedOnDate')
  Date? get processedOnDate;

  LoanCommandResult._();

  factory LoanCommandResult([void updates(LoanCommandResultBuilder b)]) = _$LoanCommandResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoanCommandResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoanCommandResult> get serializer => _$LoanCommandResultSerializer();
}

class _$LoanCommandResultSerializer implements PrimitiveSerializer<LoanCommandResult> {
  @override
  final Iterable<Type> types = const [LoanCommandResult, _$LoanCommandResult];

  @override
  final String wireName = r'LoanCommandResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoanCommandResult object, {
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
    if (object.processedOnDate != null) {
      yield r'processedOnDate';
      yield serializers.serialize(
        object.processedOnDate,
        specifiedType: const FullType(Date),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    LoanCommandResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoanCommandResultBuilder result,
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
        case r'processedOnDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.processedOnDate = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LoanCommandResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoanCommandResultBuilder();
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


