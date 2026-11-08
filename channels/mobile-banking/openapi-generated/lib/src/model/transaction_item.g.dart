// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TransactionItem extends TransactionItem {
  @override
  final int id;
  @override
  final Date date;
  @override
  final String transactionType;
  @override
  final num amount;
  @override
  final num runningBalance;
  @override
  final String? note;

  factory _$TransactionItem([void Function(TransactionItemBuilder)? updates]) =>
      (TransactionItemBuilder()..update(updates))._build();

  _$TransactionItem._(
      {required this.id,
      required this.date,
      required this.transactionType,
      required this.amount,
      required this.runningBalance,
      this.note})
      : super._();
  @override
  TransactionItem rebuild(void Function(TransactionItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TransactionItemBuilder toBuilder() => TransactionItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TransactionItem &&
        id == other.id &&
        date == other.date &&
        transactionType == other.transactionType &&
        amount == other.amount &&
        runningBalance == other.runningBalance &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, transactionType.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, runningBalance.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TransactionItem')
          ..add('id', id)
          ..add('date', date)
          ..add('transactionType', transactionType)
          ..add('amount', amount)
          ..add('runningBalance', runningBalance)
          ..add('note', note))
        .toString();
  }
}

class TransactionItemBuilder
    implements Builder<TransactionItem, TransactionItemBuilder> {
  _$TransactionItem? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  Date? _date;
  Date? get date => _$this._date;
  set date(Date? date) => _$this._date = date;

  String? _transactionType;
  String? get transactionType => _$this._transactionType;
  set transactionType(String? transactionType) =>
      _$this._transactionType = transactionType;

  num? _amount;
  num? get amount => _$this._amount;
  set amount(num? amount) => _$this._amount = amount;

  num? _runningBalance;
  num? get runningBalance => _$this._runningBalance;
  set runningBalance(num? runningBalance) =>
      _$this._runningBalance = runningBalance;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  TransactionItemBuilder() {
    TransactionItem._defaults(this);
  }

  TransactionItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _date = $v.date;
      _transactionType = $v.transactionType;
      _amount = $v.amount;
      _runningBalance = $v.runningBalance;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TransactionItem other) {
    _$v = other as _$TransactionItem;
  }

  @override
  void update(void Function(TransactionItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TransactionItem build() => _build();

  _$TransactionItem _build() {
    final _$result = _$v ??
        _$TransactionItem._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'TransactionItem', 'id'),
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'TransactionItem', 'date'),
          transactionType: BuiltValueNullFieldError.checkNotNull(
              transactionType, r'TransactionItem', 'transactionType'),
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'TransactionItem', 'amount'),
          runningBalance: BuiltValueNullFieldError.checkNotNull(
              runningBalance, r'TransactionItem', 'runningBalance'),
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
