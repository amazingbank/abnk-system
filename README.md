# abnk-system — Amazing Bank 工程单体仓（Monorepo）

ABNK 的**全部工程交付物与中间产出物**都放本仓库，单一事实源、统一版本线。

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

| 目录 | 用途 | 引入阶段 | 状态 |
|---|---|---|---|
| `deploy/` | 基础设施编排（中间件容器运行配置） | Phase 0 | ✅ 活跃 |
| `scripts/` | 工程脚本：API 封装库 + Phase 1 端到端冒烟 | Phase 1 | ✅ **当前活跃** |
| `artifacts/` | 中间产出物：数据快照、行为基线报告（可复现的小文件入库） | Phase 1 | ✅ 活跃 |
| `custom/` | `custom/abnk` 定制模块的**源**（与 fineract 仓的同步机制见其 README） | Phase 2 | 占位 |
| `frontend/` | 三套前端（管理后台→柜面→网银/手机，ADR-005） | Phase 3 | 占位 |
| `services/` | 外围服务（支付适配/通知/风控订阅，`event-bus` 落点） | Phase 4 | 占位 |

## 入库纪律

- **交付物**（代码/脚本/配置）：一律入库
- **中间产出物**：可复现、可 diff 的小文件（JSON 快照/报告）入库到 `artifacts/`；大文件与本地路径相关产物由 `.gitignore` 排除
- 产物目录按阶段命名：`artifacts/phase1/`、`artifacts/phase2/`...
- **数据不入库**：数据库内容只存快照（导出 JSON），不存 dump

## 与其他仓库的分工

| 关注点 | 仓库 |
|---|---|
| 怎么起、怎么连、怎么排障（环境单一事实源） | `.asdm/toolsets/abnk-harness-toolset/config.json` |
| 设计文档、决策记录 | `.asdm/workspace/docs/planning/abnk-design/` |
| 核心引擎代码（fork，需 rebae 上游） | `fineract/` |
| **其余一切工程产物** | **本仓库** |

## 快速开始

```bash
# 1) 起基础设施
cd deploy && docker compose up -d
# 2) 起 Fineract（宿主 devRun，见 .asdm 的环境基线文档）
# 3) 跑 Phase 1 冒烟（12 步端到端）
cd ../scripts/phase1 && python3 smoke_test.py
```
