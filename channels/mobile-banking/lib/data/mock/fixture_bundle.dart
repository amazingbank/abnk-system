import 'dart:convert';

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart' show rootBundle;

/// `fixtures/*.json` 的加载与缓存（mock 数据源，P0.3 种子快照导出）。
abstract final class FixtureBundle {
  static final Map<String, Future<Map<String, dynamic>>> _cache = {};

  /// 按文件名（不含目录前缀）加载 fixture，重复调用命中缓存。
  static Future<Map<String, dynamic>> load(String name) => _cache.putIfAbsent(
        name,
        () => rootBundle
            .loadString('fixtures/$name')
            .then((raw) => jsonDecode(raw) as Map<String, dynamic>),
      );

  /// 测试辅助：清空缓存（隔离用例间状态）。
  @visibleForTesting
  static void reset() => _cache.clear();

  /// 测试辅助：以预解析数据直填缓存（绕开 rootBundle——flutter_test 的
  /// 真实异步资产加载回复会跨 FakeAsync 用例挂起，污染 CachingAssetBundle）。
  @visibleForTesting
  static void seedForTests(Map<String, Map<String, dynamic>> fixtures) {
    _cache.addEntries(
      fixtures.entries.map((e) => MapEntry(e.key, Future.value(e.value))),
    );
  }
}
