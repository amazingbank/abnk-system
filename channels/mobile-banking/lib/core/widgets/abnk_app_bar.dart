import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// 页面级 AppBar 的统一品牌样式。
AppBar abnkAppBar(String title) => AppBar(
      title: Text(title),
      backgroundColor: AbnkColors.warmwhite,
      foregroundColor: AbnkColors.char,
      elevation: 0,
    );
