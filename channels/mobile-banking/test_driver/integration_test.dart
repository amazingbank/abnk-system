import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

/// flutter drive 驱动端——接收设备端截图字节并落盘。
///
/// 截图目录与前缀经环境变量注入（VP1.3.5 iOS / VP1.3.6 Android 分别命名）：
///   ABNK_SHOT_DIR=artifacts/phaseP1/screenshots
///   ABNK_SHOT_PREFIX=ios|android
Future<void> main() async {
  final dir = Platform.environment['ABNK_SHOT_DIR'] ?? 'screenshots';
  final prefix = Platform.environment['ABNK_SHOT_PREFIX'] ?? 'shot';
  await integrationDriver(
    onScreenshot: (String screenshotName, List<int> screenshotBytes,
        [Map<String, Object?>? args]) async {
      final file = File('$dir/$prefix-$screenshotName.png');
      await file.create(recursive: true);
      await file.writeAsBytes(screenshotBytes);
      return true;
    },
  );
}
