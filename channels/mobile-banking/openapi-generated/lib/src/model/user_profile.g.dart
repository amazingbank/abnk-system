// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserProfile extends UserProfile {
  @override
  final int clientId;
  @override
  final String externalId;
  @override
  final String firstname;
  @override
  final String lastname;
  @override
  final String displayName;
  @override
  final String mobileNo;
  @override
  final String emailAddress;
  @override
  final String officeName;

  factory _$UserProfile([void Function(UserProfileBuilder)? updates]) =>
      (UserProfileBuilder()..update(updates))._build();

  _$UserProfile._(
      {required this.clientId,
      required this.externalId,
      required this.firstname,
      required this.lastname,
      required this.displayName,
      required this.mobileNo,
      required this.emailAddress,
      required this.officeName})
      : super._();
  @override
  UserProfile rebuild(void Function(UserProfileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserProfileBuilder toBuilder() => UserProfileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserProfile &&
        clientId == other.clientId &&
        externalId == other.externalId &&
        firstname == other.firstname &&
        lastname == other.lastname &&
        displayName == other.displayName &&
        mobileNo == other.mobileNo &&
        emailAddress == other.emailAddress &&
        officeName == other.officeName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, clientId.hashCode);
    _$hash = $jc(_$hash, externalId.hashCode);
    _$hash = $jc(_$hash, firstname.hashCode);
    _$hash = $jc(_$hash, lastname.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, mobileNo.hashCode);
    _$hash = $jc(_$hash, emailAddress.hashCode);
    _$hash = $jc(_$hash, officeName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserProfile')
          ..add('clientId', clientId)
          ..add('externalId', externalId)
          ..add('firstname', firstname)
          ..add('lastname', lastname)
          ..add('displayName', displayName)
          ..add('mobileNo', mobileNo)
          ..add('emailAddress', emailAddress)
          ..add('officeName', officeName))
        .toString();
  }
}

class UserProfileBuilder implements Builder<UserProfile, UserProfileBuilder> {
  _$UserProfile? _$v;

  int? _clientId;
  int? get clientId => _$this._clientId;
  set clientId(int? clientId) => _$this._clientId = clientId;

  String? _externalId;
  String? get externalId => _$this._externalId;
  set externalId(String? externalId) => _$this._externalId = externalId;

  String? _firstname;
  String? get firstname => _$this._firstname;
  set firstname(String? firstname) => _$this._firstname = firstname;

  String? _lastname;
  String? get lastname => _$this._lastname;
  set lastname(String? lastname) => _$this._lastname = lastname;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _mobileNo;
  String? get mobileNo => _$this._mobileNo;
  set mobileNo(String? mobileNo) => _$this._mobileNo = mobileNo;

  String? _emailAddress;
  String? get emailAddress => _$this._emailAddress;
  set emailAddress(String? emailAddress) => _$this._emailAddress = emailAddress;

  String? _officeName;
  String? get officeName => _$this._officeName;
  set officeName(String? officeName) => _$this._officeName = officeName;

  UserProfileBuilder() {
    UserProfile._defaults(this);
  }

  UserProfileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _clientId = $v.clientId;
      _externalId = $v.externalId;
      _firstname = $v.firstname;
      _lastname = $v.lastname;
      _displayName = $v.displayName;
      _mobileNo = $v.mobileNo;
      _emailAddress = $v.emailAddress;
      _officeName = $v.officeName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserProfile other) {
    _$v = other as _$UserProfile;
  }

  @override
  void update(void Function(UserProfileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserProfile build() => _build();

  _$UserProfile _build() {
    final _$result = _$v ??
        _$UserProfile._(
          clientId: BuiltValueNullFieldError.checkNotNull(
              clientId, r'UserProfile', 'clientId'),
          externalId: BuiltValueNullFieldError.checkNotNull(
              externalId, r'UserProfile', 'externalId'),
          firstname: BuiltValueNullFieldError.checkNotNull(
              firstname, r'UserProfile', 'firstname'),
          lastname: BuiltValueNullFieldError.checkNotNull(
              lastname, r'UserProfile', 'lastname'),
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'UserProfile', 'displayName'),
          mobileNo: BuiltValueNullFieldError.checkNotNull(
              mobileNo, r'UserProfile', 'mobileNo'),
          emailAddress: BuiltValueNullFieldError.checkNotNull(
              emailAddress, r'UserProfile', 'emailAddress'),
          officeName: BuiltValueNullFieldError.checkNotNull(
              officeName, r'UserProfile', 'officeName'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
