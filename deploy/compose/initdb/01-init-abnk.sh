#!/bin/bash
# ABNK PG initdb：预建 Fineract 双库（租户存储库 + 默认业务租户库）。
#
# 依据实测：Fineract 迁移代码不建库（TenantDatabaseUpgradeService 无 CREATE DATABASE 逻辑）；
# 仅靠 POSTGRES_DB=root 只会建出 root 库，Hikari 连 fineract_tenants 即失败、Liquibase 永不执行。
# 官方 war-test 栈经 config/docker/postgresql/docker-entrypoint-initdb.d/01-init.sh 预建同理。
# 本脚本按 root 口径免建专用 DB 用户（开发口径三方对齐：root/postgres）。
# 注意：仅在容器数据卷首次初始化（卷为空）时执行；已初始化的卷不会重跑。
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE DATABASE fineract_tenants;
    CREATE DATABASE fineract_default;
EOSQL

echo "ABNK initdb: fineract_tenants + fineract_default created"
