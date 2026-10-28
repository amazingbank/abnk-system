# abnk 端口分配规范（62xx 段）

> 目标：ABNK 在本地**与其他所有工作区同时调试、零端口冲突**。
> 基线：2026-10-28 对 `/Users/leixu/source/asdm/` 下全部 7 个工作区的端口扫描（见文末基线表）。

## 原则

1. **ABNK 专属段：6200–6299**。所有本地调试端口收敛到本段（记忆口诀：**abnk = 62xx**）。该段在 asdm 全域（含各参考仓库）完全空闲。
2. **契约端口例外**：跨系统已有契约的端口保持不动（见"契约端口"节），不做无谓的破坏性变更。
3. **strictPort**：所有 dev server 固定端口且禁止自动漂移。端口被占直接报错——冲突要立刻暴露，而不是悄悄换端口导致联调对不上。
4. **占号即登记**：新服务占号前先更新本表再写配置；同一分段内顺序分配，禁止跳段。

## 分段规划

| 分段 | 用途 | 说明 |
|---|---|---|
| 6200–6209 | 渠道层前端（L3 `channels/`） | dev 与 preview 成对：dev 取奇数，preview = dev + 1 |
| 6210–6219 | 渠道网关（L3 `channels/gateway/`，SCG） | HTTP + actuator/management |
| 6220–6249 | 外围服务（L4 `services/`） | 每服务一号，含 management 端口则再占一号 |
| 6250–6259 | 远程调试端口（JDWP / inspector） | 挂到进程，不是 HTTP 服务 |
| 6260–6269 | 本地容器基础设施（`deploy/compose/`） | 中间件宿主映射端口 |
| 6270–6279 | 预留 | |
| 6280–6289 | 可观测性（`observability/`） | 本地 profile 宿主映射 |
| 6290–6299 | 临时 / 测试脚本 | 用完释放，仅登记不算占用 |

## 当前分配表

| 端口 | 服务 | 位置 | 状态 |
|---|---|---|---|
| 6201 | website dev server | `channels/website/vite.config.ts`（`ABNK_WEBSITE_PORT` 可覆盖） | ✅ 生效 |
| 6202 | website preview | 同上 | ✅ 生效 |
| 6203 | backoffice dev | `channels/backoffice/`（ADR-008，Ant Design Pro） | 预留 Phase 3 |
| 6204 | backoffice preview | 同上 | 预留 |
| 6205 / 6206 | online-banking dev / preview | `channels/online-banking/` | 预留 Phase 4 |
| 6207 / 6208 | counter dev / preview | `channels/counter/` | 预留 Phase 3 末 |
| 6209 | mobile-banking H5 dev | `channels/mobile-banking/h5/` | 预留 Phase 5 |
| 6210 | gateway HTTP（SCG） | `channels/gateway/` | 预留 Phase 3 |
| 6211 | gateway actuator/management | 同上 | 预留 |
| 6220 | notification service | `services/` | 预留 Phase 4 |
| 6221 | payment-adapter service | `services/` | 预留 Phase 4 |
| 6250 | Fineract JDWP（宿主调试如需） | `fineract/`（当前默认 5000，容器内调试沿用；宿主远程调试迁移到此时须同步 fineract 仓） | 预留 |
| 6260 | abnk-pg PostgreSQL 备用号 | `deploy/compose/`（默认仍 5432，见契约端口；宿主已有本地 PG 时 `ABNK_PG_PORT=6260`） | 备用 |
| 6261 | Keycloak | `deploy/compose/` 预留模板 | 预留 |
| 6262 | Kafka | 同上 | 预留 |
| 6263 | Valkey/Redis | 同上 | 预留 |
| 6280 / 6281 / 6282 | Grafana / Prometheus / Loki（本地 profile） | `observability/` | 预留 Phase 3 |

## 契约端口（本规范之外，刻意保持）

| 端口 | 服务 | 为什么不动 |
|---|---|---|
| **8443** | Fineract 主服务 | 本仓 ↔ fineract 仓的**唯一契约面**（`channels/README.md` 铁律 1：前端永不直连 8443，一律经 gateway）。且 asdm 其他工作区无人占用 8443（ke-index-repos 里的 fineract 索引副本不会常驻运行），无冲突 |
| **5432** | abnk-pg（PostgreSQL） | `deploy/compose/` 与 Fineract 三方默认值对齐的**零环境变量覆盖**设计（见 `deploy/README.md`）。本地 PG 场景用 `ABNK_PG_PORT` 切到 6260 即可 |

## 本地同时调试全家的启动顺序

```bash
# 1) abnk 基础设施
cd abnk-system/deploy/compose && docker compose up -d     # abnk-pg :5432
# 2) Fineract（宿主 devRun，断点调试）
cd fineract && ./gradlew devRun                            # :8443
# 3) 官网
cd abnk-system/channels/website && npm run dev             # :6201
# 4) 其他工作区各服务按各自文档启动 —— 端口与上表无任何交集
```

## 其他工作区端口基线（2026-10-28 扫描）

> 为什么选 62xx：以下为 `/Users/leixu/source/asdm/` 全部已占用端口，6200–6299 不在其中。

| 工作区 | 已占用端口（本地调试相关） |
|---|---|
| asdm-agentlink-ws / asdm-platform-ws / asdm-portal-ws（同名项目三处 clone，配置相同） | 5173（admin-web）、5175（portal）、5180（phpMyAdmin）、5183（agentlink/agentorbit web）、5184（preview tunnel）、3001（server）、3002（billing）、8880–8889（admin 微服务群）、3306（MySQL）、19310（Loki）、19345（Faro） |
| asdm-ontology-ws（AOS） | 3011（server）、3012（ke ui）、5194/5195/5197（web/web-lite/codegraph）、5199（phpMyAdmin）、33306（MySQL）、3911–3941 与 13111（测试临时） |
| asdm-website-ws | 5273/5274（asdm-ai-2026）、5555（asdm-docs）、12345/13000/13100/14318/19090（telemetry 本地） |
| amazingbank-ws | fineract 8443（契约）、5000（容器 JDWP）、3306/5432/9092/3000/3100/9090/4566/4200/61616 等（fineract 自带 compose，本地调试以 abnk-pg 替代其 PG）；abnk-system 5432（abnk-pg） |
| asdm-ke-index-repos（参考仓库索引，非常驻） | 8080–8085、8101、8201、8401、8800、8900、9000、9080、9090、17888、18888、30007 等 |
| 部署映射（docker compose，宿主侧） | 19306、19080、16379、18080、19800/19801、31001 |

> 相邻段避让备注：61xx（ActiveMQ 6161/61616 在用）、63xx 及以上未占用但留作扩展；62xx 内部分段见上。

## 登记与变更流程

1. 新服务需要端口 → 查本表选号 → **先改本表，再写配置**。
2. 端口废弃 → 表中标 `已释放`，保留一行不删除（防止短期内重复分配导致缓存/书签残留问题）。
3. 本规范变更与 `.asdm/toolsets/abnk-harness-toolset/config.json` 的 `processes[]` 同步（若新端口对应进程需纳入 abnk-debugger 托管）。
