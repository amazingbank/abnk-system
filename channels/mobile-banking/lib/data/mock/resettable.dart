/// 可重置的 mock repository 契约（Part03 Phase 7 D3 修订）。
///
/// 用户手动切换 UI 语言时，数据集随切（[FixtureBundle.activate] 换目录），
/// 各 mock repository 的内存态（账本/流水/会话缓存）必须一并清空回种子
/// 态——实现类把自身缓存归零即可，重新访问时按新数据集目录重新装载。
/// A resettable mock-repository contract (Part03 Phase 7, D3 revision): on a
/// manual UI-language switch the data set follows (via
/// [FixtureBundle.activate]); every mock repository must also drop its
/// in-memory state (ledgers, transaction lists, session caches) back to the
/// seed — implementers just clear their caches, and the next access reloads
/// from the newly activated data-set directory.
abstract interface class Resettable {
  /// 清空全部内存缓存（不返回错误；幂等，可安全重复调用）。
  /// Clears all in-memory caches (never throws; idempotent and safe to
  /// re-invoke).
  void reset();
}
