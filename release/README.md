# abnk-system/release — 发版资产

季度 rebase 流程与发版工程的家。流程规范：`.asdm/.../02-architecture/release-strategy.md`。

## 规划子目录（Phase 2 末建，rebase 首跑时落地）

| 子目录 | 内容 | 阶段 |
|---|---|---|
| `rebase/` | 季度 rebase 检查单 + 冲突预案脚本（diff `custom/` 相关上游变更 → 变更清单过架构评审） | Phase 2 末首跑 |
| `checklists/` | 发版检查单（含 custom 部署**双路径**验证：JAR 丢 `libs/` 与 `:custom:docker:jibDockerBuild`） | Phase 2 末 |
| `versions/` | 版本线记录（YAML manifest）：fineract fork 基线 commit ↔ 本仓产物版本对应关系 | Phase 2 末 |

## 原则

- 版本关系**可机读**（YAML manifest，AI 可自动核对一致性）
- 每次发版产出回归证据，归档 `../artifacts/`
