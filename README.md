# abnk-system — Amazing Bank 工程单体仓（Monorepo）

ABNK 的**全部工程交付物与中间产出物**都放本仓库，单一事实源、统一版本线。**目录即架构**：顶层目录直接映射 L0–L5 分层（`overview.md`），依赖方向单向 `L0 ← L1 ← L2 ← L3 ← L4/L5`，上层永不反向。

```
amazingbank-ws/                      # 工作区（非 git 仓库）
├── abnk-system/    ← 本仓库          # 交付物 + 中间产出物（monorepo）
├── fineract/                         # Fineract fork（独立仓库，git@github.com:amazingbank/fineract）
├── .asdm/                            # 工作区元数据：工具集 + 规划文档（独立仓库）
└── logs/                             # 运行时日志（自动生成，不入库）
```

## 为什么 fineract 不是本仓的子目录

Fineract fork 必须与上游 `develop` 保持**季度级 rebase**（ADR-001/002）。它作为独立仓库 + 独立版本线，rebase 面最小；若并入本仓，monorepo 的每次演进都会与上游合并冲突纠缠。**本仓 ↔ fineract 仓的唯一契约面**：API（603 端点）与 `custom/` 扩展点（见 `custom/README.md`）。

## 目录结构

| 目录 | 层 | 用途 | 引入阶段 | 状态 |
|---|---|---|---|---|
| `deploy/` | — | 环境编排（`compose/` 本地 · `k8s/` 生产规划） | Phase 0 | ✅ 活跃 |
| `scripts/` | — | 工程脚本 + API 封装库 | Phase 1 | ✅ 活跃 |
| `artifacts/` | — | 中间产出物（按阶段归档） | Phase 1 | ✅ 活跃 |
| `tests/` | — | 跨模块测试资产（smoke / e2e / tenant-isolation） | Phase 1 | ✅ 冒烟活跃 |
| `custom/` | L2 | 定制模块源（同步到 fineract 仓编译） | Phase 2 | 骨架 |
| `data/` | L1 | 本地化数据资产（COA / 日历 / seed，YAML + Schema） | Phase 2 | 占位 |
| `channels/` | L3 | 渠道层：网关 + 全部渠道前端（ADR-008） | 2–5 | website ✅ |
| `services/` | L4 | 外围服务（通知 / 支付适配等，事件总线消费方） | Phase 4 | 占位 |
| `ci/` | — | 质量门禁（GitHub Actions；宪法红线 R6 补位） | Phase 2 | 占位 |
| `release/` | — | 发版资产（rebase 检查单 / 版本线） | Phase 2 末 | 占位 |
| `observability/` | — | 监控 as-code（dashboards / alerts / runbooks） | Phase 3 | 占位 |
| `docs/` | — | 工程操作文档（设计文档在 `.asdm`，只链接不复制） | Phase 2 | 占位 |

技术栈定案（2026-10-26）：ADR-007（信创兼容：主线开源 + 兼容层）、ADR-008（渠道层：SCG 网关 + React 前端 + 混合移动端）。

## 入库纪律

- **交付物**（代码/脚本/配置）：一律入库
- **中间产出物**：可复现、可 diff 的小文件（JSON 快照/报告）入库到 `artifacts/`；大文件与本地路径相关产物由 `.gitignore` 排除
- 产物目录按阶段命名：`artifacts/phase1/`、`artifacts/phase2/`...
- **数据不入库**：数据库内容只存快照（导出 JSON），不存 dump；`data/` 放的是**施加到系统的定义**（YAML 源），不是数据

## 与其他仓库的分工

| 关注点 | 仓库 |
|---|---|
| 怎么起、怎么连、怎么排障（环境单一事实源） | `.asdm/toolsets/abnk-harness-toolset/config.json` |
| 设计文档、决策记录 | `.asdm/workspace/docs/planning/abnk-design/` |
| 核心引擎代码（fork，需 rebase 上游） | `fineract/` |
| **其余一切工程产物** | **本仓库** |

## 快速开始

```bash
# 1) 起基础设施
cd deploy/compose && docker compose up -d
# 2) 起 Fineract（宿主 devRun，见 .asdm 的环境基线文档）
# 3) 跑 12 步端到端冒烟
cd ../tests/smoke && python3 smoke_test.py
```
