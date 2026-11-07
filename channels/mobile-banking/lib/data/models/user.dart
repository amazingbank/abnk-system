/// 会话（登录态）与当前客户资料模型。
library;

/// 登录会话——mock 阶段仅承载身份标识；P2 接线后承载 JWT。
class Session {
  const Session({
    required this.username,
    required this.displayName,
    required this.clientId,
  });

  final String username;
  final String displayName;
  final int clientId;
}

/// 当前客户资料（脱敏口径：证件号/手机号在网关层收敛，客户端只收尾号）。
class UserProfile {
  const UserProfile({
    required this.clientId,
    required this.externalId,
    required this.firstname,
    required this.lastname,
    required this.displayName,
    required this.mobileNo,
    required this.emailAddress,
    required this.officeName,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        clientId: json['clientId'] as int,
        externalId: json['externalId'] as String,
        firstname: json['firstname'] as String,
        lastname: json['lastname'] as String,
        displayName: json['displayName'] as String,
        mobileNo: json['mobileNo'] as String,
        emailAddress: json['emailAddress'] as String,
        officeName: json['officeName'] as String,
      );

  final int clientId;
  final String externalId;
  final String firstname;
  final String lastname;
  final String displayName;
  final String mobileNo;
  final String emailAddress;
  final String officeName;
}
