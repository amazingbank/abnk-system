# abnk-system/deploy — 基础设施编排

Amazing Bank IT 系统的基础设施配置。阶段一仅 PostgreSQL；Fineract 通过 `gradle devRun` 在宿主运行（便于断点调试），不进容器。

## 文件

| 文件 | 作用 |
|---|---|
| `docker-compose.yml` | 服务编排（当前：`abnk-pg`） |
| `.env` | 环境变量默认值（compose 自动读取） |
| `.gitignore` | 排除 `.env.local` 与备份产物 |

## 常用命令

```bash
cd abnk-system/deploy

docker compose up -d          # 启动
docker compose ps             # 查看状态（healthy 才可用）
docker compose logs -f abnk-pg
docker compose down           # 停止并移除容器（数据卷保留）
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

**② 卷名用 `name:` 固定为 `abnk-pg-data`**

否则 compose 会加上项目前缀变成 `abnk-system_abnk-pg-data`，与 `.asdm/toolsets/abnk-harness-toolset/config.json` 及 `abnk-debugger` 中记录的名称不一致。

## 账号为什么是 root / postgres

Fineract 三处默认值原本就一致：

1. `fineract-provider/src/main/resources/application.properties` 的 hikari 默认值
2. `fineract-provider/build.gradle` 中 `createPGDB` 任务的 `pgUser` / `pgPassword`
3. 本目录的 `.env`

这样本地调试**零环境变量覆盖**即可跑通。仓库自带的 `docker-compose-postgresql.yml` 用的是随机密码串，本地调试不采用。

## 接入新系统

在 `docker-compose.yml` 的 services 追加一项 → 同步登记到 `.asdm/toolsets/abnk-harness-toolset/config.json` 的 `processes[]` → 从 `extensions.planned` 移除该项。**`abnk-debugger` 的 action / spec 文档无需改动。**
