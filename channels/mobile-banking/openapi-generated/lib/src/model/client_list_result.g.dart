// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_list_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ClientListResult extends ClientListResult {
  @override
  final int total;
  @override
  final BuiltList<ClientSummary> items;

  factory _$ClientListResult(
          [void Function(ClientListResultBuilder)? updates]) =>
      (ClientListResultBuilder()..update(updates))._build();

  _$ClientListResult._({required this.total, required this.items}) : super._();
  @override
  ClientListResult rebuild(void Function(ClientListResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ClientListResultBuilder toBuilder() =>
      ClientListResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ClientListResult &&
        total == other.total &&
        items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ClientListResult')
          ..add('total', total)
          ..add('items', items))
        .toString();
  }
}

class ClientListResultBuilder
    implements Builder<ClientListResult, ClientListResultBuilder> {
  _$ClientListResult? _$v;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  ListBuilder<ClientSummary>? _items;
  ListBuilder<ClientSummary> get items =>
      _$this._items ??= ListBuilder<ClientSummary>();
  set items(ListBuilder<ClientSummary>? items) => _$this._items = items;

  ClientListResultBuilder() {
    ClientListResult._defaults(this);
  }

  ClientListResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _total = $v.total;
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ClientListResult other) {
    _$v = other as _$ClientListResult;
  }

  @override
  void update(void Function(ClientListResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ClientListResult build() => _build();

  _$ClientListResult _build() {
    _$ClientListResult _$result;
    try {
      _$result = _$v ??
          _$ClientListResult._(
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'ClientListResult', 'total'),
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ClientListResult', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
