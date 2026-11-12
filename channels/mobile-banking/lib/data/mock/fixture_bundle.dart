import 'dart:convert';

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart' show rootBundle;

import 'data_locale.dart';

/// `fixtures/<locale>/*.json` 的加载与缓存（mock 数据源，P0.3 种子快照导出）。
///
/// Phase 7 D3 修订（2026-11-12 用户拍板）：数据集目录运行时可切换——
/// 初始目录 = 编译期 `dataLocale` 常量（部署 `--dart-define` 注入，缺省
/// zh-cn，生产 ARG 缺省 en-us）；用户手动切换 UI 语言时经 [activate]
/// 换目录并清缓存（内存态重置由各 repository 的 reset 实现）。
/// EN: loads and caches `fixtures/<locale>/*.json` (the mock data source,
/// P0.3 seed snapshot export). Phase 7 revision of decision D3 (user's call,
/// 2026-11-12): the data-set directory is now switchable at runtime — the
/// initial one comes from the compile-time `dataLocale` constant (injected
/// via the deployment `--dart-define`); a manual UI-language switch swaps the
/// directory through [activate] and drops the cache (in-memory state resets
/// live in each repository's reset).
abstract final class FixtureBundle {
  static final Map<String, Future<Map<String, dynamic>>> _cache = {};

  // 当前数据集目录（运行时可变——初始 = 编译期注入，activate 切换）。
  // The active data-set directory (mutable at runtime — initialized from
  // the compile-time injection, swapped by activate).
  static String _dir = fixtureDirFor(dataLocale);

  /// 当前数据集目录（诊断用途）。
  /// The active data-set directory (diagnostics).
  static String get activeDir => _dir;

  /// 激活数据集目录（D3 修订）：目录变化时清缓存；同目录幂等无操作。
  ///Activates a data-set directory (D3 revision): clears the cache when the
  /// directory changes; an identical directory is an idempotent no-op.
  static void activate(String locale) {
    final next = fixtureDirFor(locale);
    if (next == _dir) return;
    _dir = next;
    _cache.clear();
  }

  /// 按文件名（不含目录前缀）加载 fixture，重复调用命中缓存；缓存 key
  /// 为文件名（目录运行期由 activate 集中切换，切换即整缓清空）。
  /// EN: loads a fixture by bare file name (no directory prefix) with
  /// caching; the cache key is the file name (the directory is switched
  /// centrally via activate, which clears the whole cache).
  static Future<Map<String, dynamic>> load(String name) => _cache.putIfAbsent(
        name,
        () => rootBundle
            .loadString('fixtures/$_dir/$name')
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
