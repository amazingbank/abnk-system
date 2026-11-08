//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'loan_approve_request.g.dart';

/// 审批通过载荷（command=approve）
///
/// Properties:
/// * [approvedOnDate] 
/// * [note] 
@BuiltValue()
abstract class LoanApproveRequest implements Built<LoanApproveRequest, LoanApproveRequestBuilder> {
  @BuiltValueField(wireName: r'approvedOnDate')
  Date get approvedOnDate;

  @BuiltValueField(wireName: r'note')
  String? get note;

  LoanApproveRequest._();

  factory LoanApproveRequest([void updates(LoanApproveRequestBuilder b)]) = _$LoanApproveRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoanApproveRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoanApproveRequest> get serializer => _$LoanApproveRequestSerializer();
}

class _$LoanApproveRequestSerializer implements PrimitiveSerializer<LoanApproveRequest> {
  @override
  final Iterable<Type> types = const [LoanApproveRequest, _$LoanApproveRequest];

  @override
  final String wireName = r'LoanApproveRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoanApproveRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'approvedOnDate';
    yield serializers.serialize(
      object.approvedOnDate,
      specifiedType: const FullType(Date),
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
    LoanApproveRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoanApproveRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'approvedOnDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.approvedOnDate = valueDes;
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
  LoanApproveRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoanApproveRequestBuilder();
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


