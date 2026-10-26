# abnk-system/tests — 跨模块测试资产

回归资产的家。模块内单测随模块走（如 custom 各模块的 `src/test/`），本目录放**跨模块 / 端到端**测试。

| 子目录 | 内容 | 状态 |
|---|---|---|
| `smoke/` | 12 步端到端冒烟（Phase 1 验证资产，施工图 `phase-1-validation.md`；Phase 2 起增加分录断言） | ✅ 活跃 |
| `e2e/` | 官方 E2E 子集编排 + 自建场景；UI 层 Phase 3 接入 Playwright | 占位（Phase 3） |
| `tenant-isolation/` | 双租户用例（红线 R4 门禁，ADR-004） | 占位（Phase 4 正式化） |

## 运行

```bash
cd tests/smoke && python3 smoke_test.py    # 前置：deploy/compose 起好 + Fineract devRun
# 报告落 ../../artifacts/phase1/report-<ts>.json（幂等，可重复运行）
```
