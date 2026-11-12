/// mock 数据集语言（决策 D3：部署期决策——运行时 UI 语言切换不切数据集）。
/// 编译期常量：`--dart-define=ABNK_DATA_LOCALE=<zh-cn|en-us>` 于构建期烙入
/// 产物，缺省 zh-cn；部署侧变量与 backoffice 共用同一来源（deploy env
/// `ABNK_DATA_LOCALE` → Dockerfile `ARG` → `--dart-define` 注入链）。
/// EN: the mock data-set locale (decision D3: a deploy-time decision —
/// runtime UI language switching never switches the data set). A compile-time
/// constant baked into the build via --dart-define=ABNK_DATA_LOCALE (defaults
/// to zh-cn); shares the same deployment variable with the backoffice (deploy
/// env ABNK_DATA_LOCALE → Dockerfile ARG → the --dart-define chain).
const String dataLocale = String.fromEnvironment(
  'ABNK_DATA_LOCALE',
  defaultValue: 'zh-cn',
);

/// zh-cn 转账兜底 note 可读原文：本人账户转账。
/// The readable zh-cn transfer fallback note: self transfer between own
/// accounts.
const String _transferNoteZh = '\u672c\u4eba\u8d26\u6237\u8f6c\u8d26';

/// zh-cn 定期开户兜底 note 可读原文：定期开户。
/// The readable zh-cn fixed-deposit fallback note: account opening.
const String _fixedDepositOpenNoteZh = '\u5b9a\u671f\u5f00\u6237';

/// 按语言返回 fixtures 数据集目录名（载入路径 `fixtures/<返回值>/`）。
/// 纯函数——不依赖编译期常量，供测试直证两态；未知语言落回 zh-cn。
/// EN: resolves the fixtures data-set directory name for the given locale
/// (load path `fixtures/<result>/`). A pure function independent of the
/// compile-time constant so tests can assert both states directly; unknown
/// codes fall back to zh-cn.
///
/// 注：不标 @visibleForTesting——三个函数被 fixture_bundle /
/// mock_account_repository 生产侧跨库调用，标注会触发
/// invalid_use_of_visible_for_testing lint（V4.2.1 实测），与「No issues
/// found」编译硬门冲突；公开纯函数可测性不受影响。
/// EN: deliberately not annotated @visibleForTesting — these functions are
/// called from production code across libraries (fixture_bundle /
/// mock_account_repository), and the annotation would trip the
/// invalid_use_of_visible_for_testing lint (observed in V4.2.1), conflicting
/// with the "No issues found" compile gate; staying public keeps them just
/// as testable.
String fixtureDirFor(String locale) =>
    locale == 'en-us' ? 'en-us' : 'zh-cn';

/// UI 语言码（zh/en）→ 数据集码（zh-cn/en-us）映射（Phase 7 D3 修订：
/// 用户手动切换 UI 语言时数据集随切）。
/// Maps a UI locale code (zh/en) to a data-set code (zh-cn/en-us) — the
/// Phase 7 D3 revision: a manual UI-language switch swaps the data set too.
String dataLocaleCodeFor(String uiLanguageCode) =>
    uiLanguageCode.toLowerCase().startsWith('zh') ? 'zh-cn' : 'en-us';

/// 转账无备注时的明细兜底 note（数据文案，决策 D2/D3——随数据集语言走，
/// 不查 UI 词条）。en 为语义重写：本人账户转账 → Self transfer。
/// EN: the fallback transaction note used when a transfer carries no user
/// note (data copy per D2/D3 — follows the data-set locale, never the UI
/// catalog); the en value is a semantic rewrite, not word-for-word.
String transferNoteFor(String locale) =>
    locale == 'en-us' ? 'Self transfer' : _transferNoteZh;

/// 定期开户扣款流水的兜底 note（数据文案，决策 D2/D3——随数据集语言走）。
/// en 为语义重写：定期开户 → Fixed deposit opening。
/// EN: the fallback note for the withdrawal that funds a fixed-deposit
/// opening (data copy per D2/D3 — follows the data-set locale); the en value
/// is a semantic rewrite.
String fixedDepositOpenNoteFor(String locale) =>
    locale == 'en-us' ? 'Fixed deposit opening' : _fixedDepositOpenNoteZh;
