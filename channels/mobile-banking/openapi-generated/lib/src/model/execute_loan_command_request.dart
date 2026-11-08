//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/loan_approve_request.dart';
import 'package:openapi/src/model/date.dart';
import 'package:openapi/src/model/loan_disburse_request.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/one_of.dart';

part 'execute_loan_command_request.g.dart';

/// ExecuteLoanCommandRequest
///
/// Properties:
/// * [approvedOnDate] 
/// * [note] 
/// * [actualDisbursementDate] 
@BuiltValue()
abstract class ExecuteLoanCommandRequest implements Built<ExecuteLoanCommandRequest, ExecuteLoanCommandRequestBuilder> {
  /// One Of [LoanApproveRequest], [LoanDisburseRequest]
  OneOf get oneOf;

  ExecuteLoanCommandRequest._();

  factory ExecuteLoanCommandRequest([void updates(ExecuteLoanCommandRequestBuilder b)]) = _$ExecuteLoanCommandRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ExecuteLoanCommandRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ExecuteLoanCommandRequest> get serializer => _$ExecuteLoanCommandRequestSerializer();
}

class _$ExecuteLoanCommandRequestSerializer implements PrimitiveSerializer<ExecuteLoanCommandRequest> {
  @override
  final Iterable<Type> types = const [ExecuteLoanCommandRequest, _$ExecuteLoanCommandRequest];

  @override
  final String wireName = r'ExecuteLoanCommandRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ExecuteLoanCommandRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
  }

  @override
  Object serialize(
    Serializers serializers,
    ExecuteLoanCommandRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final oneOf = object.oneOf;
    return serializers.serialize(oneOf.value, specifiedType: FullType(oneOf.valueType))!;
  }

  @override
  ExecuteLoanCommandRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExecuteLoanCommandRequestBuilder();
    Object? oneOfDataSrc;
    final targetType = const FullType(OneOf, [FullType(LoanApproveRequest), FullType(LoanDisburseRequest), ]);
    oneOfDataSrc = serialized;
    result.oneOf = serializers.deserialize(oneOfDataSrc, specifiedType: targetType) as OneOf;
    return result.build();
  }
}


