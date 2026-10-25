# abnk-system/deploy — 基础设施编排

> 2026-10-25 起本仓库升级为 **ABNK 工程单体仓**（见仓库根 README）。本目录职责收窄为：**中间件容器的运行配置**。工程脚本已移至 `../scripts/`，未来前端/外围服务/定制模块源分别有独立目录。

## 文件

| 文件 | 作用 |
|---|---|
| `docker-compose.yml` | 服务编排（当前：`abnk-pg`；预留 Kafka / Keycloak 接入模板） |
| `.env` | 环境变量默认值（compose 自动读取） |
| `.gitignore` | 排除 `.env.local` 与备份产物 |

## 常用命令

```bash
cd abnk-system/deploy

docker compose up -d          # 启动
docker compose ps             # 查看状态（healthy 才可用）
docker compose logs -f abnk-pg
docker compose stop           # 日常停止（容器保留）
docker compose down           # 移除容器（数据卷保留）
docker compose down -v        # 连数据卷一起删 ⚠️ 会清空数据库
```

## 验证

```bash
docker exec abnk-pg pg_isready -U root
docker exec abnk-pg psql -U root -l        # 列出数据库
```

Fineract 需要两个库：

- `fineract_tenants` — 租户存储库（存租户连接参数，启动时先读它）
- `fineract_default` — 默认业务租户库（业务表）

由 `fineract/` 下的 Gradle 任务创建：

```bash
cd fineract
./gradlew createPGDB -PdbName=fineract_tenants
./gradlew createPGDB -PdbName=fineract_default
```

数据表结构无需手工创建——Fineract 启动时由 Liquibase 自动迁移。

## 两个关键约定

**① 数据卷必须挂在 `/var/lib/postgresql`（不是 `/var/lib/postgresql/data`）**

PostgreSQL 18+ 镜像改用 `pg_ctlcluster` 兼容布局，数据落在版本化子目录 `/var/lib/postgresql/18/data`。挂错会直接启动失败：

```
Error: in 18+, these Docker images are configured to store database data
       in a format which is compatible with "pg_ctlcluster" ...
```

**② compose 项目名与卷名固定**

`name: abnk-system`（防止与其他项目的 `deploy/` 目录撞名导致 `down` 误停他人容器）；卷名 `abnk-pg-data`（与 `.asdm` 的 config.json 记录一致）。

## 账号为什么是 root / postgres

Fineract 三处默认值原本就一致：

1. `fineract-provider/src/main/resources/application.properties` 的 hikari 默认值
2. `fineract-provider/build.gradle` 中 `createPGDB` 任务的 `pgUser` / `pgPassword`
3. 本目录的 `.env`

这样本地调试**零环境变量覆盖**即可跑通。仓库自带的 `docker-compose-postgresql.yml` 用的是随机密码串，本地调试不采用。

## 日志布局

容器开启 `logging_collector`，服务端日志直写工作区统一的 `logs/postgres.log`（按天轮转 / 50MB 切分），与 `logs/fineract.log` 并列——`abnk-debugger` 依赖该布局。**因此本仓库应克隆到 `amazingbank-ws/abnk-system/`**；放其他位置时把 `deploy/.env` 的 `ABNK_LOGS_DIR` 改为绝对路径。

## 接入新中间件

在 `docker-compose.yml` 的 services 追加一项 → 同步登记到 `.asdm/toolsets/abnk-harness-toolset/config.json` 的 `processes[]` → 从 `extensions.planned` 移除该项。**`abnk-debugger` 的 action / spec 文档无需改动。**

## ⚠️ 运维警示（2026-10-25 实际发生）

Docker 虚拟磁盘写满时，PG 会进入**崩溃循环**（日志反复出现 `PANIC: could not write to file "pg_logical/replorigin_checkpoint.tmp": No space left on device` + `all server processes terminated; reinitializing`），容器显示 `running (unhealthy)`。处置：`docker builder prune -f` + `docker image prune -f` 释放空间后 `docker compose restart abnk-pg`——数据可恢复（WAL 回放完整）。监控：`docker system df` 的 RECLAIMABLE 列。
