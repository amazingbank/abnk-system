// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'identifier_update_payload.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$IdentifierUpdatePayload extends IdentifierUpdatePayload {
  @override
  final Date expiryDate;
  @override
  final String? documentKey;
  @override
  final String? description;

  factory _$IdentifierUpdatePayload(
          [void Function(IdentifierUpdatePayloadBuilder)? updates]) =>
      (IdentifierUpdatePayloadBuilder()..update(updates))._build();

  _$IdentifierUpdatePayload._(
      {required this.expiryDate, this.documentKey, this.description})
      : super._();
  @override
  IdentifierUpdatePayload rebuild(
          void Function(IdentifierUpdatePayloadBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IdentifierUpdatePayloadBuilder toBuilder() =>
      IdentifierUpdatePayloadBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IdentifierUpdatePayload &&
        expiryDate == other.expiryDate &&
        documentKey == other.documentKey &&
        description == other.description;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, expiryDate.hashCode);
    _$hash = $jc(_$hash, documentKey.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'IdentifierUpdatePayload')
          ..add('expiryDate', expiryDate)
          ..add('documentKey', documentKey)
          ..add('description', description))
        .toString();
  }
}

class IdentifierUpdatePayloadBuilder
    implements
        Builder<IdentifierUpdatePayload, IdentifierUpdatePayloadBuilder> {
  _$IdentifierUpdatePayload? _$v;

  Date? _expiryDate;
  Date? get expiryDate => _$this._expiryDate;
  set expiryDate(Date? expiryDate) => _$this._expiryDate = expiryDate;

  String? _documentKey;
  String? get documentKey => _$this._documentKey;
  set documentKey(String? documentKey) => _$this._documentKey = documentKey;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  IdentifierUpdatePayloadBuilder() {
    IdentifierUpdatePayload._defaults(this);
  }

  IdentifierUpdatePayloadBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _expiryDate = $v.expiryDate;
      _documentKey = $v.documentKey;
      _description = $v.description;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IdentifierUpdatePayload other) {
    _$v = other as _$IdentifierUpdatePayload;
  }

  @override
  void update(void Function(IdentifierUpdatePayloadBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  IdentifierUpdatePayload build() => _build();

  _$IdentifierUpdatePayload _build() {
    final _$result = _$v ??
        _$IdentifierUpdatePayload._(
          expiryDate: BuiltValueNullFieldError.checkNotNull(
              expiryDate, r'IdentifierUpdatePayload', 'expiryDate'),
          documentKey: documentKey,
          description: description,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
