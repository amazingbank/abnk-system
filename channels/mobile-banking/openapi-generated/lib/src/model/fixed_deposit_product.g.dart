// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fixed_deposit_product.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FixedDepositProduct extends FixedDepositProduct {
  @override
  final int id;
  @override
  final String name;
  @override
  final String description;
  @override
  final num interestRate;
  @override
  final int depositPeriod;
  @override
  final num minDepositAmount;

  factory _$FixedDepositProduct(
          [void Function(FixedDepositProductBuilder)? updates]) =>
      (FixedDepositProductBuilder()..update(updates))._build();

  _$FixedDepositProduct._(
      {required this.id,
      required this.name,
      required this.description,
      required this.interestRate,
      required this.depositPeriod,
      required this.minDepositAmount})
      : super._();
  @override
  FixedDepositProduct rebuild(
          void Function(FixedDepositProductBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FixedDepositProductBuilder toBuilder() =>
      FixedDepositProductBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FixedDepositProduct &&
        id == other.id &&
        name == other.name &&
        description == other.description &&
        interestRate == other.interestRate &&
        depositPeriod == other.depositPeriod &&
        minDepositAmount == other.minDepositAmount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, interestRate.hashCode);
    _$hash = $jc(_$hash, depositPeriod.hashCode);
    _$hash = $jc(_$hash, minDepositAmount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FixedDepositProduct')
          ..add('id', id)
          ..add('name', name)
          ..add('description', description)
          ..add('interestRate', interestRate)
          ..add('depositPeriod', depositPeriod)
          ..add('minDepositAmount', minDepositAmount))
        .toString();
  }
}

class FixedDepositProductBuilder
    implements Builder<FixedDepositProduct, FixedDepositProductBuilder> {
  _$FixedDepositProduct? _$v;

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

  int? _depositPeriod;
  int? get depositPeriod => _$this._depositPeriod;
  set depositPeriod(int? depositPeriod) =>
      _$this._depositPeriod = depositPeriod;

  num? _minDepositAmount;
  num? get minDepositAmount => _$this._minDepositAmount;
  set minDepositAmount(num? minDepositAmount) =>
      _$this._minDepositAmount = minDepositAmount;

  FixedDepositProductBuilder() {
    FixedDepositProduct._defaults(this);
  }

  FixedDepositProductBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _description = $v.description;
      _interestRate = $v.interestRate;
      _depositPeriod = $v.depositPeriod;
      _minDepositAmount = $v.minDepositAmount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FixedDepositProduct other) {
    _$v = other as _$FixedDepositProduct;
  }

  @override
  void update(void Function(FixedDepositProductBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FixedDepositProduct build() => _build();

  _$FixedDepositProduct _build() {
    final _$result = _$v ??
        _$FixedDepositProduct._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'FixedDepositProduct', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'FixedDepositProduct', 'name'),
          description: BuiltValueNullFieldError.checkNotNull(
              description, r'FixedDepositProduct', 'description'),
          interestRate: BuiltValueNullFieldError.checkNotNull(
              interestRate, r'FixedDepositProduct', 'interestRate'),
          depositPeriod: BuiltValueNullFieldError.checkNotNull(
              depositPeriod, r'FixedDepositProduct', 'depositPeriod'),
          minDepositAmount: BuiltValueNullFieldError.checkNotNull(
              minDepositAmount, r'FixedDepositProduct', 'minDepositAmount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
