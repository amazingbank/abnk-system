# abnk-system

Amazing Bank（ABNK）IT 系统的**基础设施编排**——容器化中间件与支撑服务的配置仓库。

Fineract 核心账务引擎不在此仓库：它以 `gradle devRun` 运行在宿主（便于断点调试），代码在 `amazingbank/fineract`。本仓库只管**它依赖的中间件**。

## 当前内容

| 服务 | 镜像 | 端口 | 用途 |
|---|---|---|---|
| `abnk-pg` | `postgres:18.3` | 5432 | 全系统唯一数据库宿主 |

```bash
cd deploy && docker compose up -d
```

详细命令、验证方法与踩坑说明见 [`deploy/README.md`](deploy/README.md)。

## ⚠️ 克隆位置有要求

`deploy/.env` 里的 `ABNK_LOGS_DIR=../../logs`，是**相对于 compose 文件位置**解析的，它把 PostgreSQL 服务端日志写到工作区统一的 `logs/postgres.log`（与 Fineract 的 `logs/fineract.log` 并列，`abnk-debugger` 依赖这个布局）。

因此本仓库应克隆到工作区的 `abnk-system/` 位置：

```
amazingbank-ws/
├── .asdm/          # git@github.com:amazingbank/amazingbank-asdm
├── abnk-system/    # ← 本仓库，克隆到这里
├── fineract/       # git@github.com:amazingbank/fineract（develop）
└── logs/
```

若放在其他位置，改 `ABNK_LOGS_DIR` 为绝对路径即可：

```bash
# deploy/.env
ABNK_LOGS_DIR=/Users/leixu/source/asdm/amazingbank-ws/logs
```

## 接入新系统

后续系统（Kafka、Keycloak、自有业务服务……）在 `deploy/docker-compose.yml` 追加 service，并同步登记到 `.asdm/toolsets/abnk-harness-toolset/config.json` 的 `environments.local.processes[]`——`abnk-debugger` 的 action / spec 文档无需改动。

## 与其他仓库的关系

- 本仓库：中间件的**运行配置**（怎么起、怎么连）
- `.asdm` 仓库：环境的**单一事实源**（进程清单、端口、鉴权、端点），引用本仓库的 compose 文件
- `fineract` 仓库：业务代码

三者独立演进。改动本仓库的容器名 / 卷名 / 端口时，**必须同步更新 `.asdm` 的 `config.json`**。
