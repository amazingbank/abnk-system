import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app.dart';
import 'app_scope.dart';
import 'data/mock/mock_account_repository.dart';
import 'data/mock/mock_auth_repository.dart';
import 'data/mock/mock_identity_repository.dart';
import 'data/mock/mock_loan_repository.dart';

void main() {
  // 自托管字体口径（P1.2 锁定）：禁运行时拉取，字体经 assets/fonts/
  // 内置打包进产物（对齐官网 no-CDN 约束）。
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(AbnkApp(state: _defaultState));
}

final AppState _defaultState = AppState(
  auth: MockAuthRepository(),
  identity: MockIdentityRepository(),
  account: MockAccountRepository(),
  loan: MockLoanRepository(),
);
