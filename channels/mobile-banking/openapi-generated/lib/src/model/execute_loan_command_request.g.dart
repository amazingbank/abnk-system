// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'execute_loan_command_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ExecuteLoanCommandRequest extends ExecuteLoanCommandRequest {
  @override
  final OneOf oneOf;

  factory _$ExecuteLoanCommandRequest(
          [void Function(ExecuteLoanCommandRequestBuilder)? updates]) =>
      (ExecuteLoanCommandRequestBuilder()..update(updates))._build();

  _$ExecuteLoanCommandRequest._({required this.oneOf}) : super._();
  @override
  ExecuteLoanCommandRequest rebuild(
          void Function(ExecuteLoanCommandRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExecuteLoanCommandRequestBuilder toBuilder() =>
      ExecuteLoanCommandRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExecuteLoanCommandRequest && oneOf == other.oneOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, oneOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExecuteLoanCommandRequest')
          ..add('oneOf', oneOf))
        .toString();
  }
}

class ExecuteLoanCommandRequestBuilder
    implements
        Builder<ExecuteLoanCommandRequest, ExecuteLoanCommandRequestBuilder> {
  _$ExecuteLoanCommandRequest? _$v;

  OneOf? _oneOf;
  OneOf? get oneOf => _$this._oneOf;
  set oneOf(OneOf? oneOf) => _$this._oneOf = oneOf;

  ExecuteLoanCommandRequestBuilder() {
    ExecuteLoanCommandRequest._defaults(this);
  }

  ExecuteLoanCommandRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _oneOf = $v.oneOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExecuteLoanCommandRequest other) {
    _$v = other as _$ExecuteLoanCommandRequest;
  }

  @override
  void update(void Function(ExecuteLoanCommandRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExecuteLoanCommandRequest build() => _build();

  _$ExecuteLoanCommandRequest _build() {
    final _$result = _$v ??
        _$ExecuteLoanCommandRequest._(
          oneOf: BuiltValueNullFieldError.checkNotNull(
              oneOf, r'ExecuteLoanCommandRequest', 'oneOf'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
