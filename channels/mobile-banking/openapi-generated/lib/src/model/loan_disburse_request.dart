//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'loan_disburse_request.g.dart';

/// 放款载荷（command=disburse）
///
/// Properties:
/// * [actualDisbursementDate] 
/// * [note] 
@BuiltValue()
abstract class LoanDisburseRequest implements Built<LoanDisburseRequest, LoanDisburseRequestBuilder> {
  @BuiltValueField(wireName: r'actualDisbursementDate')
  Date get actualDisbursementDate;

  @BuiltValueField(wireName: r'note')
  String? get note;

  LoanDisburseRequest._();

  factory LoanDisburseRequest([void updates(LoanDisburseRequestBuilder b)]) = _$LoanDisburseRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoanDisburseRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoanDisburseRequest> get serializer => _$LoanDisburseRequestSerializer();
}

class _$LoanDisburseRequestSerializer implements PrimitiveSerializer<LoanDisburseRequest> {
  @override
  final Iterable<Type> types = const [LoanDisburseRequest, _$LoanDisburseRequest];

  @override
  final String wireName = r'LoanDisburseRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoanDisburseRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'actualDisbursementDate';
    yield serializers.serialize(
      object.actualDisbursementDate,
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
    LoanDisburseRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoanDisburseRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'actualDisbursementDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.actualDisbursementDate = valueDes;
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
  LoanDisburseRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoanDisburseRequestBuilder();
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


