// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AccountAccountTypeEnum _$accountAccountTypeEnum_SAVINGS =
    const AccountAccountTypeEnum._('SAVINGS');
const AccountAccountTypeEnum _$accountAccountTypeEnum_FIXED_DEPOSIT =
    const AccountAccountTypeEnum._('FIXED_DEPOSIT');

AccountAccountTypeEnum _$accountAccountTypeEnumValueOf(String name) {
  switch (name) {
    case 'SAVINGS':
      return _$accountAccountTypeEnum_SAVINGS;
    case 'FIXED_DEPOSIT':
      return _$accountAccountTypeEnum_FIXED_DEPOSIT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AccountAccountTypeEnum> _$accountAccountTypeEnumValues =
    BuiltSet<AccountAccountTypeEnum>(const <AccountAccountTypeEnum>[
  _$accountAccountTypeEnum_SAVINGS,
  _$accountAccountTypeEnum_FIXED_DEPOSIT,
]);

Serializer<AccountAccountTypeEnum> _$accountAccountTypeEnumSerializer =
    _$AccountAccountTypeEnumSerializer();

class _$AccountAccountTypeEnumSerializer
    implements PrimitiveSerializer<AccountAccountTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SAVINGS': 'SAVINGS',
    'FIXED_DEPOSIT': 'FIXED_DEPOSIT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SAVINGS': 'SAVINGS',
    'FIXED_DEPOSIT': 'FIXED_DEPOSIT',
  };

  @override
  final Iterable<Type> types = const <Type>[AccountAccountTypeEnum];
  @override
  final String wireName = 'AccountAccountTypeEnum';

  @override
  Object serialize(Serializers serializers, AccountAccountTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AccountAccountTypeEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AccountAccountTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$Account extends Account {
  @override
  final int id;
  @override
  final String accountNo;
  @override
  final String productName;
  @override
  final AccountAccountTypeEnum accountType;
  @override
  final String currency;
  @override
  final num accountBalance;
  @override
  final num availableBalance;
  @override
  final String status;
  @override
  final num? interestRate;
  @override
  final Date? maturityDate;

  factory _$Account([void Function(AccountBuilder)? updates]) =>
      (AccountBuilder()..update(updates))._build();

  _$Account._(
      {required this.id,
      required this.accountNo,
      required this.productName,
      required this.accountType,
      required this.currency,
      required this.accountBalance,
      required this.availableBalance,
      required this.status,
      this.interestRate,
      this.maturityDate})
      : super._();
  @override
  Account rebuild(void Function(AccountBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountBuilder toBuilder() => AccountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Account &&
        id == other.id &&
        accountNo == other.accountNo &&
        productName == other.productName &&
        accountType == other.accountType &&
        currency == other.currency &&
        accountBalance == other.accountBalance &&
        availableBalance == other.availableBalance &&
        status == other.status &&
        interestRate == other.interestRate &&
        maturityDate == other.maturityDate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, accountNo.hashCode);
    _$hash = $jc(_$hash, productName.hashCode);
    _$hash = $jc(_$hash, accountType.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, accountBalance.hashCode);
    _$hash = $jc(_$hash, availableBalance.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, interestRate.hashCode);
    _$hash = $jc(_$hash, maturityDate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Account')
          ..add('id', id)
          ..add('accountNo', accountNo)
          ..add('productName', productName)
          ..add('accountType', accountType)
          ..add('currency', currency)
          ..add('accountBalance', accountBalance)
          ..add('availableBalance', availableBalance)
          ..add('status', status)
          ..add('interestRate', interestRate)
          ..add('maturityDate', maturityDate))
        .toString();
  }
}

class AccountBuilder implements Builder<Account, AccountBuilder> {
  _$Account? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _accountNo;
  String? get accountNo => _$this._accountNo;
  set accountNo(String? accountNo) => _$this._accountNo = accountNo;

  String? _productName;
  String? get productName => _$this._productName;
  set productName(String? productName) => _$this._productName = productName;

  AccountAccountTypeEnum? _accountType;
  AccountAccountTypeEnum? get accountType => _$this._accountType;
  set accountType(AccountAccountTypeEnum? accountType) =>
      _$this._accountType = accountType;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  num? _accountBalance;
  num? get accountBalance => _$this._accountBalance;
  set accountBalance(num? accountBalance) =>
      _$this._accountBalance = accountBalance;

  num? _availableBalance;
  num? get availableBalance => _$this._availableBalance;
  set availableBalance(num? availableBalance) =>
      _$this._availableBalance = availableBalance;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  num? _interestRate;
  num? get interestRate => _$this._interestRate;
  set interestRate(num? interestRate) => _$this._interestRate = interestRate;

  Date? _maturityDate;
  Date? get maturityDate => _$this._maturityDate;
  set maturityDate(Date? maturityDate) => _$this._maturityDate = maturityDate;

  AccountBuilder() {
    Account._defaults(this);
  }

  AccountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _accountNo = $v.accountNo;
      _productName = $v.productName;
      _accountType = $v.accountType;
      _currency = $v.currency;
      _accountBalance = $v.accountBalance;
      _availableBalance = $v.availableBalance;
      _status = $v.status;
      _interestRate = $v.interestRate;
      _maturityDate = $v.maturityDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Account other) {
    _$v = other as _$Account;
  }

  @override
  void update(void Function(AccountBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Account build() => _build();

  _$Account _build() {
    final _$result = _$v ??
        _$Account._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'Account', 'id'),
          accountNo: BuiltValueNullFieldError.checkNotNull(
              accountNo, r'Account', 'accountNo'),
          productName: BuiltValueNullFieldError.checkNotNull(
              productName, r'Account', 'productName'),
          accountType: BuiltValueNullFieldError.checkNotNull(
              accountType, r'Account', 'accountType'),
          currency: BuiltValueNullFieldError.checkNotNull(
              currency, r'Account', 'currency'),
          accountBalance: BuiltValueNullFieldError.checkNotNull(
              accountBalance, r'Account', 'accountBalance'),
          availableBalance: BuiltValueNullFieldError.checkNotNull(
              availableBalance, r'Account', 'availableBalance'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'Account', 'status'),
          interestRate: interestRate,
          maturityDate: maturityDate,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
