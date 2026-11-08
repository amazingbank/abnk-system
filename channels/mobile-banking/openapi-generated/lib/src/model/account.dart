//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'account.g.dart';

/// 账户（活期 / 定期统一形态；账号尾号脱敏）
///
/// Properties:
/// * [id] 
/// * [accountNo] - 脱敏形态（如 0000**0011）
/// * [productName] 
/// * [accountType] 
/// * [currency] 
/// * [accountBalance] - 账面余额
/// * [availableBalance] - 可用余额（定期账户支取受限，快照可回退为账面余额）
/// * [status] - 账户状态（ACTIVE 等，透传 Fineract 状态值）
/// * [interestRate] - 年利率（%——仅定期账户）
/// * [maturityDate] - 到期日（仅定期账户；对年对月对日口径）
@BuiltValue()
abstract class Account implements Built<Account, AccountBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  /// 脱敏形态（如 0000**0011）
  @BuiltValueField(wireName: r'accountNo')
  String get accountNo;

  @BuiltValueField(wireName: r'productName')
  String get productName;

  @BuiltValueField(wireName: r'accountType')
  AccountAccountTypeEnum get accountType;
  // enum accountTypeEnum {  SAVINGS,  FIXED_DEPOSIT,  };

  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// 账面余额
  @BuiltValueField(wireName: r'accountBalance')
  num get accountBalance;

  /// 可用余额（定期账户支取受限，快照可回退为账面余额）
  @BuiltValueField(wireName: r'availableBalance')
  num get availableBalance;

  /// 账户状态（ACTIVE 等，透传 Fineract 状态值）
  @BuiltValueField(wireName: r'status')
  String get status;

  /// 年利率（%——仅定期账户）
  @BuiltValueField(wireName: r'interestRate')
  num? get interestRate;

  /// 到期日（仅定期账户；对年对月对日口径）
  @BuiltValueField(wireName: r'maturityDate')
  Date? get maturityDate;

  Account._();

  factory Account([void updates(AccountBuilder b)]) = _$Account;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AccountBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Account> get serializer => _$AccountSerializer();
}

class _$AccountSerializer implements PrimitiveSerializer<Account> {
  @override
  final Iterable<Type> types = const [Account, _$Account];

  @override
  final String wireName = r'Account';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Account object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'accountNo';
    yield serializers.serialize(
      object.accountNo,
      specifiedType: const FullType(String),
    );
    yield r'productName';
    yield serializers.serialize(
      object.productName,
      specifiedType: const FullType(String),
    );
    yield r'accountType';
    yield serializers.serialize(
      object.accountType,
      specifiedType: const FullType(AccountAccountTypeEnum),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'accountBalance';
    yield serializers.serialize(
      object.accountBalance,
      specifiedType: const FullType(num),
    );
    yield r'availableBalance';
    yield serializers.serialize(
      object.availableBalance,
      specifiedType: const FullType(num),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    if (object.interestRate != null) {
      yield r'interestRate';
      yield serializers.serialize(
        object.interestRate,
        specifiedType: const FullType(num),
      );
    }
    if (object.maturityDate != null) {
      yield r'maturityDate';
      yield serializers.serialize(
        object.maturityDate,
        specifiedType: const FullType(Date),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Account object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AccountBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'accountNo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accountNo = valueDes;
          break;
        case r'productName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.productName = valueDes;
          break;
        case r'accountType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AccountAccountTypeEnum),
          ) as AccountAccountTypeEnum;
          result.accountType = valueDes;
          break;
        case r'currency':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.currency = valueDes;
          break;
        case r'accountBalance':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.accountBalance = valueDes;
          break;
        case r'availableBalance':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.availableBalance = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'interestRate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.interestRate = valueDes;
          break;
        case r'maturityDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.maturityDate = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Account deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AccountBuilder();
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


class AccountAccountTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SAVINGS')
  static const AccountAccountTypeEnum SAVINGS = _$accountAccountTypeEnum_SAVINGS;
  @BuiltValueEnumConst(wireName: r'FIXED_DEPOSIT')
  static const AccountAccountTypeEnum FIXED_DEPOSIT = _$accountAccountTypeEnum_FIXED_DEPOSIT;

  static Serializer<AccountAccountTypeEnum> get serializer => _$accountAccountTypeEnumSerializer;

  const AccountAccountTypeEnum._(String name): super(name);

  static BuiltSet<AccountAccountTypeEnum> get values => _$accountAccountTypeEnumValues;
  static AccountAccountTypeEnum valueOf(String name) => _$accountAccountTypeEnumValueOf(name);
}

