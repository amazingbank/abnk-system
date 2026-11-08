//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/loan_summary.dart';
import 'package:openapi/src/model/client_identifier.dart';
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/fixed_deposit_summary.dart';
import 'package:openapi/src/model/savings_account_summary.dart';
import 'package:openapi/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'client_detail.g.dart';

/// 客户详情（详情页全量形态：基本信息 + 证照 + 账户 + 贷款）
///
/// Properties:
/// * [clientId] 
/// * [externalId] 
/// * [displayName] 
/// * [mobileNo] 
/// * [officeName] 
/// * [status] 
/// * [identifierStatus] 
/// * [identifierExpiryDate] 
/// * [firstname] 
/// * [lastname] 
/// * [emailAddress] 
/// * [identifier] - 首证照（无证照为 null）
/// * [savingsAccounts] 
/// * [fixedDepositAccounts] 
/// * [loan] - 贷款概要（无贷款为 null）
@BuiltValue()
abstract class ClientDetail implements Built<ClientDetail, ClientDetailBuilder> {
  @BuiltValueField(wireName: r'clientId')
  int get clientId;

  @BuiltValueField(wireName: r'externalId')
  String get externalId;

  @BuiltValueField(wireName: r'displayName')
  String get displayName;

  @BuiltValueField(wireName: r'mobileNo')
  String get mobileNo;

  @BuiltValueField(wireName: r'officeName')
  String get officeName;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'identifierStatus')
  ClientDetailIdentifierStatusEnum? get identifierStatus;
  // enum identifierStatusEnum {  VALID,  EXPIRED,  ,  };

  @BuiltValueField(wireName: r'identifierExpiryDate')
  Date? get identifierExpiryDate;

  @BuiltValueField(wireName: r'firstname')
  String get firstname;

  @BuiltValueField(wireName: r'lastname')
  String get lastname;

  @BuiltValueField(wireName: r'emailAddress')
  String get emailAddress;

  /// 首证照（无证照为 null）
  @BuiltValueField(wireName: r'identifier')
  ClientIdentifier? get identifier;

  @BuiltValueField(wireName: r'savingsAccounts')
  BuiltList<SavingsAccountSummary> get savingsAccounts;

  @BuiltValueField(wireName: r'fixedDepositAccounts')
  BuiltList<FixedDepositSummary> get fixedDepositAccounts;

  /// 贷款概要（无贷款为 null）
  @BuiltValueField(wireName: r'loan')
  LoanSummary? get loan;

  ClientDetail._();

  factory ClientDetail([void updates(ClientDetailBuilder b)]) = _$ClientDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ClientDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ClientDetail> get serializer => _$ClientDetailSerializer();
}

class _$ClientDetailSerializer implements PrimitiveSerializer<ClientDetail> {
  @override
  final Iterable<Type> types = const [ClientDetail, _$ClientDetail];

  @override
  final String wireName = r'ClientDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ClientDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'clientId';
    yield serializers.serialize(
      object.clientId,
      specifiedType: const FullType(int),
    );
    yield r'externalId';
    yield serializers.serialize(
      object.externalId,
      specifiedType: const FullType(String),
    );
    yield r'displayName';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'mobileNo';
    yield serializers.serialize(
      object.mobileNo,
      specifiedType: const FullType(String),
    );
    yield r'officeName';
    yield serializers.serialize(
      object.officeName,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    if (object.identifierStatus != null) {
      yield r'identifierStatus';
      yield serializers.serialize(
        object.identifierStatus,
        specifiedType: const FullType.nullable(ClientDetailIdentifierStatusEnum),
      );
    }
    if (object.identifierExpiryDate != null) {
      yield r'identifierExpiryDate';
      yield serializers.serialize(
        object.identifierExpiryDate,
        specifiedType: const FullType.nullable(Date),
      );
    }
    yield r'firstname';
    yield serializers.serialize(
      object.firstname,
      specifiedType: const FullType(String),
    );
    yield r'lastname';
    yield serializers.serialize(
      object.lastname,
      specifiedType: const FullType(String),
    );
    yield r'emailAddress';
    yield serializers.serialize(
      object.emailAddress,
      specifiedType: const FullType(String),
    );
    if (object.identifier != null) {
      yield r'identifier';
      yield serializers.serialize(
        object.identifier,
        specifiedType: const FullType.nullable(ClientIdentifier),
      );
    }
    yield r'savingsAccounts';
    yield serializers.serialize(
      object.savingsAccounts,
      specifiedType: const FullType(BuiltList, [FullType(SavingsAccountSummary)]),
    );
    yield r'fixedDepositAccounts';
    yield serializers.serialize(
      object.fixedDepositAccounts,
      specifiedType: const FullType(BuiltList, [FullType(FixedDepositSummary)]),
    );
    if (object.loan != null) {
      yield r'loan';
      yield serializers.serialize(
        object.loan,
        specifiedType: const FullType.nullable(LoanSummary),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ClientDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ClientDetailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'clientId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.clientId = valueDes;
          break;
        case r'externalId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.externalId = valueDes;
          break;
        case r'displayName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'mobileNo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mobileNo = valueDes;
          break;
        case r'officeName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.officeName = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'identifierStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ClientDetailIdentifierStatusEnum),
          ) as ClientDetailIdentifierStatusEnum?;
          if (valueDes == null) continue;
          result.identifierStatus = valueDes;
          break;
        case r'identifierExpiryDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.identifierExpiryDate = valueDes;
          break;
        case r'firstname':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.firstname = valueDes;
          break;
        case r'lastname':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.lastname = valueDes;
          break;
        case r'emailAddress':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.emailAddress = valueDes;
          break;
        case r'identifier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ClientIdentifier),
          ) as ClientIdentifier?;
          if (valueDes == null) continue;
          result.identifier.replace(valueDes);
          break;
        case r'savingsAccounts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SavingsAccountSummary)]),
          ) as BuiltList<SavingsAccountSummary>;
          result.savingsAccounts.replace(valueDes);
          break;
        case r'fixedDepositAccounts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(FixedDepositSummary)]),
          ) as BuiltList<FixedDepositSummary>;
          result.fixedDepositAccounts.replace(valueDes);
          break;
        case r'loan':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(LoanSummary),
          ) as LoanSummary?;
          if (valueDes == null) continue;
          result.loan = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ClientDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ClientDetailBuilder();
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


class ClientDetailIdentifierStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VALID')
  static const ClientDetailIdentifierStatusEnum VALID = _$clientDetailIdentifierStatusEnum_VALID;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const ClientDetailIdentifierStatusEnum EXPIRED = _$clientDetailIdentifierStatusEnum_EXPIRED;

  static Serializer<ClientDetailIdentifierStatusEnum> get serializer => _$clientDetailIdentifierStatusEnumSerializer;

  const ClientDetailIdentifierStatusEnum._(String name): super(name);

  static BuiltSet<ClientDetailIdentifierStatusEnum> get values => _$clientDetailIdentifierStatusEnumValues;
  static ClientDetailIdentifierStatusEnum valueOf(String name) => _$clientDetailIdentifierStatusEnumValueOf(name);
}

