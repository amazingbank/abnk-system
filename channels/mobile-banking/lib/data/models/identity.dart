/// 证照（身份标识）模型——只读展示口径。
///
/// 证照状态展示文案经顶层函数 [identityStatusLabel] 提供（Part03 任务
/// 3.4：label 决策上移 UI 层并接收 l10n，models 保持零 BuildContext 依赖）。
///
/// Identity model — read-only display. The status display label is provided
/// by the top-level [identityStatusLabel] (Part03 task 3.4: the label
/// decision moved up to the UI layer and takes the l10n, while models stay
/// free of any BuildContext dependency).
library;

import '../../l10n/app_localizations.dart';

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
}

/// 证照状态 → 展示文案（Part03 任务 3.4：接收 l10n）。
///
/// Identity status → display label (Part03 task 3.4: takes the l10n).
String identityStatusLabel(AppLocalizations l10n, IdentityStatus status) =>
    switch (status) {
      IdentityStatus.valid => l10n.identityStatusValid,
      IdentityStatus.expiringSoon => l10n.identityStatusExpiringSoon,
      IdentityStatus.expired => l10n.identityStatusExpired,
    };
