//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/account.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'account_summary.g.dart';

/// 账户总览（活期 + 定期两组）
///
/// Properties:
/// * [savingsAccounts] 
/// * [fixedDepositAccounts] 
@BuiltValue()
abstract class AccountSummary implements Built<AccountSummary, AccountSummaryBuilder> {
  @BuiltValueField(wireName: r'savingsAccounts')
  BuiltList<Account> get savingsAccounts;

  @BuiltValueField(wireName: r'fixedDepositAccounts')
  BuiltList<Account> get fixedDepositAccounts;

  AccountSummary._();

  factory AccountSummary([void updates(AccountSummaryBuilder b)]) = _$AccountSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AccountSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AccountSummary> get serializer => _$AccountSummarySerializer();
}

class _$AccountSummarySerializer implements PrimitiveSerializer<AccountSummary> {
  @override
  final Iterable<Type> types = const [AccountSummary, _$AccountSummary];

  @override
  final String wireName = r'AccountSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AccountSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'savingsAccounts';
    yield serializers.serialize(
      object.savingsAccounts,
      specifiedType: const FullType(BuiltList, [FullType(Account)]),
    );
    yield r'fixedDepositAccounts';
    yield serializers.serialize(
      object.fixedDepositAccounts,
      specifiedType: const FullType(BuiltList, [FullType(Account)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AccountSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AccountSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'savingsAccounts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Account)]),
          ) as BuiltList<Account>;
          result.savingsAccounts.replace(valueDes);
          break;
        case r'fixedDepositAccounts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Account)]),
          ) as BuiltList<Account>;
          result.fixedDepositAccounts.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AccountSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AccountSummaryBuilder();
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


