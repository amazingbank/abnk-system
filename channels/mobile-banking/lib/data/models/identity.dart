/// 证照（身份标识）模型——只读展示口径。
library;

enum IdentityStatus { valid, expiringSoon, expired }

/// 客户证照信息（只读；基线不做过期横幅/拦截，POC 增量承接）。
class IdentityInfo {
  const IdentityInfo({
    required this.documentTypeId,
    required this.documentTypeName,
    required this.documentKey,
    required this.status,
    required this.issuanceDate,
    required this.expiryDate,
  });

  factory IdentityInfo.fromJson(Map<String, dynamic> json) => IdentityInfo(
        documentTypeId: json['documentTypeId'] as int,
        documentTypeName: json['documentTypeName'] as String,
        documentKey: json['documentKey'] as String,
        status: switch (json['status'] as String) {
          'VALID' => IdentityStatus.valid,
          'EXPIRING_SOON' => IdentityStatus.expiringSoon,
          _ => IdentityStatus.expired,
        },
        issuanceDate: json['issuanceDate'] as String,
        expiryDate: json['expiryDate'] as String,
      );

  final int documentTypeId;
  final String documentTypeName;
  final String documentKey;
  final IdentityStatus status;
  final String issuanceDate;
  final String expiryDate;

  String get statusLabel => switch (status) {
        IdentityStatus.valid => '有效',
        IdentityStatus.expiringSoon => '临期',
        IdentityStatus.expired => '已过期',
      };
}
