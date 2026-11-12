import 'dart:convert';

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart' show rootBundle;

import 'data_locale.dart';

/// `fixtures/<locale>/*.json` 的加载与缓存（mock 数据源，P0.3 种子快照导出）。
/// 双语数据集 zh-cn / en-us 由编译期 `--dart-define=ABNK_DATA_LOCALE` 选择
/// （决策 D3：部署期决策，运行时 UI 语言切换不切数据集）。
/// EN: loads and caches `fixtures/<locale>/*.json` (the mock data source,
/// P0.3 seed snapshot export); the bilingual data set (zh-cn / en-us) is
/// chosen at compile time via --dart-define=ABNK_DATA_LOCALE (decision D3: a
/// deploy-time decision — runtime UI language switching never switches the
/// data set).
abstract final class FixtureBundle {
  static final Map<String, Future<Map<String, dynamic>>> _cache = {};

  /// 按文件名（不含目录前缀）加载 fixture，重复调用命中缓存；缓存 key 仅为
  /// 文件名（目录由编译期常量决定，运行期恒定不变）。
  /// EN: loads a fixture by bare file name (no directory prefix) with
  /// caching; the cache key is the file name only (the directory is fixed by
  /// the compile-time constant and never varies at runtime).
  static Future<Map<String, dynamic>> load(String name) => _cache.putIfAbsent(
        name,
        () => rootBundle
            .loadString('fixtures/${fixtureDirFor(dataLocale)}/$name')
            .then((raw) => jsonDecode(raw) as Map<String, dynamic>),
      );

  /// 测试辅助：清空缓存（隔离用例间状态）。
  /// Test helper: clears the cache to isolate state between cases.
  @visibleForTesting
  static void reset() => _cache.clear();

  /// 测试辅助：以预解析数据直填缓存（绕开 rootBundle——flutter_test 的
  /// 真实异步资产加载回复会跨 FakeAsync 用例挂起，污染 CachingAssetBundle）。
  /// Test helper: seeds the cache with pre-parsed data, bypassing rootBundle
  /// (real async asset loading in flutter_test would suspend across FakeAsync
  /// cases and pollute the CachingAssetBundle).
  @visibleForTesting
  static void seedForTests(Map<String, Map<String, dynamic>> fixtures) {
    _cache.addEntries(
      fixtures.entries.map((e) => MapEntry(e.key, Future.value(e.value))),
    );
  }
}
