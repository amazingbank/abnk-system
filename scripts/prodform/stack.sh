#!/bin/bash
# ABNK 本地生产形态栈一键脚本（Phase P0.1）。
# 用法：scripts/prodform/stack.sh {up|down|ps|logs|status|wait}
#
# ⚠️ down 为停栈操作——按全局规则执行前问用户。
# ⚠️ 项目名固定 abnk-prodform（compose 文件内已声明），脚本必须在任意目录可用。
set -e

COMPOSE_FILE="$(cd "$(dirname "$0")/../../deploy/compose" && pwd)/docker-compose.prodform.yml"
COMPOSE="docker compose -f $COMPOSE_FILE"

case "$1" in
  up)
    $COMPOSE up -d
    echo "提示：Tomcat 部署 + Liquibase 首迁需要 15-30 min；等待就绪用：stack.sh wait"
    ;;
  down)
    # ⚠️ 执行前问用户（停栈；数据卷默认保留，-v 删卷为破坏性操作绝不在本脚本自动执行）
    $COMPOSE down
    ;;
  ps)
    $COMPOSE ps
    ;;
  logs)
    shift
    $COMPOSE logs "${@:--f abnk-fineract}"
    ;;
  status)
    $COMPOSE ps
    echo "--- READY 计数 ---"
    docker logs abnk-fineract 2>&1 | grep -c 'APACHE FINERACT IS READY' || true
    echo "--- health ---"
    curl -s -m 5 http://localhost:8081/fineract-provider/actuator/health || echo "(health 不可达)"
    echo
    ;;
  wait)
    # 轮询 READY 标志（超时 20 min）
    for i in $(seq 1 1200); do
      if docker logs abnk-fineract 2>&1 | grep -q 'APACHE FINERACT IS READY'; then
        echo "READY（第 ${i}s 轮询命中）"
        exit 0
      fi
      sleep 1
    done
    echo "超时（20 min 未见 READY）——查 docker logs abnk-fineract" >&2
    exit 1
    ;;
  *)
    echo "用法: $0 {up|down|ps|logs|status|wait}"
    exit 1
    ;;
esac
