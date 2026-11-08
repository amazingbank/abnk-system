// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_product.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const LoanProductTermPeriodFrequencyTypeEnum
    _$loanProductTermPeriodFrequencyTypeEnum_MONTHS =
    const LoanProductTermPeriodFrequencyTypeEnum._('MONTHS');

LoanProductTermPeriodFrequencyTypeEnum
    _$loanProductTermPeriodFrequencyTypeEnumValueOf(String name) {
  switch (name) {
    case 'MONTHS':
      return _$loanProductTermPeriodFrequencyTypeEnum_MONTHS;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<LoanProductTermPeriodFrequencyTypeEnum>
    _$loanProductTermPeriodFrequencyTypeEnumValues = BuiltSet<
        LoanProductTermPeriodFrequencyTypeEnum>(const <LoanProductTermPeriodFrequencyTypeEnum>[
  _$loanProductTermPeriodFrequencyTypeEnum_MONTHS,
]);

const LoanProductRepaymentMethodEnum
    _$loanProductRepaymentMethodEnum_EQUAL_INSTALLMENTS =
    const LoanProductRepaymentMethodEnum._('EQUAL_INSTALLMENTS');

LoanProductRepaymentMethodEnum _$loanProductRepaymentMethodEnumValueOf(
    String name) {
  switch (name) {
    case 'EQUAL_INSTALLMENTS':
      return _$loanProductRepaymentMethodEnum_EQUAL_INSTALLMENTS;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<LoanProductRepaymentMethodEnum>
    _$loanProductRepaymentMethodEnumValues = BuiltSet<
        LoanProductRepaymentMethodEnum>(const <LoanProductRepaymentMethodEnum>[
  _$loanProductRepaymentMethodEnum_EQUAL_INSTALLMENTS,
]);

Serializer<LoanProductTermPeriodFrequencyTypeEnum>
    _$loanProductTermPeriodFrequencyTypeEnumSerializer =
    _$LoanProductTermPeriodFrequencyTypeEnumSerializer();
Serializer<LoanProductRepaymentMethodEnum>
    _$loanProductRepaymentMethodEnumSerializer =
    _$LoanProductRepaymentMethodEnumSerializer();

class _$LoanProductTermPeriodFrequencyTypeEnumSerializer
    implements PrimitiveSerializer<LoanProductTermPeriodFrequencyTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'MONTHS': 'MONTHS',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'MONTHS': 'MONTHS',
  };

  @override
  final Iterable<Type> types = const <Type>[
    LoanProductTermPeriodFrequencyTypeEnum
  ];
  @override
  final String wireName = 'LoanProductTermPeriodFrequencyTypeEnum';

  @override
  Object serialize(Serializers serializers,
          LoanProductTermPeriodFrequencyTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  LoanProductTermPeriodFrequencyTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      LoanProductTermPeriodFrequencyTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$LoanProductRepaymentMethodEnumSerializer
    implements PrimitiveSerializer<LoanProductRepaymentMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'EQUAL_INSTALLMENTS': 'EQUAL_INSTALLMENTS',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'EQUAL_INSTALLMENTS': 'EQUAL_INSTALLMENTS',
  };

  @override
  final Iterable<Type> types = const <Type>[LoanProductRepaymentMethodEnum];
  @override
  final String wireName = 'LoanProductRepaymentMethodEnum';

  @override
  Object serialize(
          Serializers serializers, LoanProductRepaymentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  LoanProductRepaymentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      LoanProductRepaymentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$LoanProduct extends LoanProduct {
  @override
  final int id;
  @override
  final String name;
  @override
  final String description;
  @override
  final num interestRate;
  @override
  final int termFrequency;
  @override
  final LoanProductTermPeriodFrequencyTypeEnum termPeriodFrequencyType;
  @override
  final num minPrincipalAmount;
  @override
  final num maxPrincipalAmount;
  @override
  final LoanProductRepaymentMethodEnum repaymentMethod;

  factory _$LoanProduct([void Function(LoanProductBuilder)? updates]) =>
      (LoanProductBuilder()..update(updates))._build();

  _$LoanProduct._(
      {required this.id,
      required this.name,
      required this.description,
      required this.interestRate,
      required this.termFrequency,
      required this.termPeriodFrequencyType,
      required this.minPrincipalAmount,
      required this.maxPrincipalAmount,
      required this.repaymentMethod})
      : super._();
  @override
  LoanProduct rebuild(void Function(LoanProductBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoanProductBuilder toBuilder() => LoanProductBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoanProduct &&
        id == other.id &&
        name == other.name &&
        description == other.description &&
        interestRate == other.interestRate &&
        termFrequency == other.termFrequency &&
        termPeriodFrequencyType == other.termPeriodFrequencyType &&
        minPrincipalAmount == other.minPrincipalAmount &&
        maxPrincipalAmount == other.maxPrincipalAmount &&
        repaymentMethod == other.repaymentMethod;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, interestRate.hashCode);
    _$hash = $jc(_$hash, termFrequency.hashCode);
    _$hash = $jc(_$hash, termPeriodFrequencyType.hashCode);
    _$hash = $jc(_$hash, minPrincipalAmount.hashCode);
    _$hash = $jc(_$hash, maxPrincipalAmount.hashCode);
    _$hash = $jc(_$hash, repaymentMethod.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoanProduct')
          ..add('id', id)
          ..add('name', name)
          ..add('description', description)
          ..add('interestRate', interestRate)
          ..add('termFrequency', termFrequency)
          ..add('termPeriodFrequencyType', termPeriodFrequencyType)
          ..add('minPrincipalAmount', minPrincipalAmount)
          ..add('maxPrincipalAmount', maxPrincipalAmount)
          ..add('repaymentMethod', repaymentMethod))
        .toString();
  }
}

class LoanProductBuilder implements Builder<LoanProduct, LoanProductBuilder> {
  _$LoanProduct? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  num? _interestRate;
  num? get interestRate => _$this._interestRate;
  set interestRate(num? interestRate) => _$this._interestRate = interestRate;

  int? _termFrequency;
  int? get termFrequency => _$this._termFrequency;
  set termFrequency(int? termFrequency) =>
      _$this._termFrequency = termFrequency;

  LoanProductTermPeriodFrequencyTypeEnum? _termPeriodFrequencyType;
  LoanProductTermPeriodFrequencyTypeEnum? get termPeriodFrequencyType =>
      _$this._termPeriodFrequencyType;
  set termPeriodFrequencyType(
          LoanProductTermPeriodFrequencyTypeEnum? termPeriodFrequencyType) =>
      _$this._termPeriodFrequencyType = termPeriodFrequencyType;

  num? _minPrincipalAmount;
  num? get minPrincipalAmount => _$this._minPrincipalAmount;
  set minPrincipalAmount(num? minPrincipalAmount) =>
      _$this._minPrincipalAmount = minPrincipalAmount;

  num? _maxPrincipalAmount;
  num? get maxPrincipalAmount => _$this._maxPrincipalAmount;
  set maxPrincipalAmount(num? maxPrincipalAmount) =>
      _$this._maxPrincipalAmount = maxPrincipalAmount;

  LoanProductRepaymentMethodEnum? _repaymentMethod;
  LoanProductRepaymentMethodEnum? get repaymentMethod =>
      _$this._repaymentMethod;
  set repaymentMethod(LoanProductRepaymentMethodEnum? repaymentMethod) =>
      _$this._repaymentMethod = repaymentMethod;

  LoanProductBuilder() {
    LoanProduct._defaults(this);
  }

  LoanProductBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _description = $v.description;
      _interestRate = $v.interestRate;
      _termFrequency = $v.termFrequency;
      _termPeriodFrequencyType = $v.termPeriodFrequencyType;
      _minPrincipalAmount = $v.minPrincipalAmount;
      _maxPrincipalAmount = $v.maxPrincipalAmount;
      _repaymentMethod = $v.repaymentMethod;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoanProduct other) {
    _$v = other as _$LoanProduct;
  }

  @override
  void update(void Function(LoanProductBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoanProduct build() => _build();

  _$LoanProduct _build() {
    final _$result = _$v ??
        _$LoanProduct._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'LoanProduct', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'LoanProduct', 'name'),
          description: BuiltValueNullFieldError.checkNotNull(
              description, r'LoanProduct', 'description'),
          interestRate: BuiltValueNullFieldError.checkNotNull(
              interestRate, r'LoanProduct', 'interestRate'),
          termFrequency: BuiltValueNullFieldError.checkNotNull(
              termFrequency, r'LoanProduct', 'termFrequency'),
          termPeriodFrequencyType: BuiltValueNullFieldError.checkNotNull(
              termPeriodFrequencyType,
              r'LoanProduct',
              'termPeriodFrequencyType'),
          minPrincipalAmount: BuiltValueNullFieldError.checkNotNull(
              minPrincipalAmount, r'LoanProduct', 'minPrincipalAmount'),
          maxPrincipalAmount: BuiltValueNullFieldError.checkNotNull(
              maxPrincipalAmount, r'LoanProduct', 'maxPrincipalAmount'),
          repaymentMethod: BuiltValueNullFieldError.checkNotNull(
              repaymentMethod, r'LoanProduct', 'repaymentMethod'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
