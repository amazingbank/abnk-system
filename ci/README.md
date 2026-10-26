# abnk-system/ci — 自建质量门禁（GitHub Actions）

补位 Fineract 官方质量门禁对 `custom/abnk` 的豁免（`customization-strategy.md` §5，红线 R6）。平台定案：**GitHub Actions**（2026-10-26）；统一任务入口 **Makefile**（Phase 2 建，`make lint/build/test/smoke/e2e`）。

## 规划子目录

| 子目录 | 内容 |
|---|---|
| `workflows/` | 流水线定义（YAML） |
| `rules/` | spotless / checkstyle **自配**规则集（不依赖官方对 custom 的关闭） |

## 规划 workflow

| workflow | 触发 | 内容 | 阶段 |
|---|---|---|---|
| lint-build-test | 每次提交 | spotless + checkstyle + 编译 + 模块内单测 | Phase 2 首版 |
| smoke | 每日定时 + 手动 | `tests/smoke/` 12 步冒烟 | Phase 2 首版 |
| e2e | 定时 + 手动 | 官方 E2E 子集 + Playwright | Phase 3 |
| compat-matrix | 定时 | multi-arch（amd64/arm64）构建 + 国产库兼容 job（ADR-007） | Phase 4 |

涉及数据改动的提交必带双租户测试用例（红线 R4，`tests/tenant-isolation/`）。
