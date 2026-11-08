//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'loan_application_request.g.dart';

/// 贷款申请请求
///
/// Properties:
/// * [productId] 
/// * [principal] - 申请本金（须在产品 min/max 区间内）
/// * [termMonths] - 期限（月，须与产品期限一致）
/// * [purpose] - 贷款用途（可选）
@BuiltValue()
abstract class LoanApplicationRequest implements Built<LoanApplicationRequest, LoanApplicationRequestBuilder> {
  @BuiltValueField(wireName: r'productId')
  int get productId;

  /// 申请本金（须在产品 min/max 区间内）
  @BuiltValueField(wireName: r'principal')
  num get principal;

  /// 期限（月，须与产品期限一致）
  @BuiltValueField(wireName: r'termMonths')
  int get termMonths;

  /// 贷款用途（可选）
  @BuiltValueField(wireName: r'purpose')
  String? get purpose;

  LoanApplicationRequest._();

  factory LoanApplicationRequest([void updates(LoanApplicationRequestBuilder b)]) = _$LoanApplicationRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoanApplicationRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoanApplicationRequest> get serializer => _$LoanApplicationRequestSerializer();
}

class _$LoanApplicationRequestSerializer implements PrimitiveSerializer<LoanApplicationRequest> {
  @override
  final Iterable<Type> types = const [LoanApplicationRequest, _$LoanApplicationRequest];

  @override
  final String wireName = r'LoanApplicationRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoanApplicationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'productId';
    yield serializers.serialize(
      object.productId,
      specifiedType: const FullType(int),
    );
    yield r'principal';
    yield serializers.serialize(
      object.principal,
      specifiedType: const FullType(num),
    );
    yield r'termMonths';
    yield serializers.serialize(
      object.termMonths,
      specifiedType: const FullType(int),
    );
    if (object.purpose != null) {
      yield r'purpose';
      yield serializers.serialize(
        object.purpose,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    LoanApplicationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoanApplicationRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'productId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.productId = valueDes;
          break;
        case r'principal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.principal = valueDes;
          break;
        case r'termMonths':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.termMonths = valueDes;
          break;
        case r'purpose':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.purpose = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LoanApplicationRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoanApplicationRequestBuilder();
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


