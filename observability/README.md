# abnk-system/observability — 监控 as-code

复用 Fineract 官方观测栈（Loki / Prometheus / Grafana / Tempo，compose 定义届时入 `../deploy/compose/`）。策略：`.asdm/.../04-operations/observability.md`（复用官方栈 + 分阶段接入）。

## 规划子目录

| 子目录 | 内容 | 阶段 |
|---|---|---|
| `dashboards/` | Grafana 面板 JSON（JVM / 网关 / 业务大盘） | Phase 3 首接 |
| `alerts/` | Prometheus 告警规则（YAML） | Phase 4 |
| `runbooks/` | 告警→处置手册：每条告警注解直链对应 runbook（`engineering-conventions.md` 排障决策树的工程侧落点） | Phase 3 |

## 原则

- 面板/告警/手册全部入库、可评审、可 diff——监控即代码
- 全链路 OpenTelemetry（JVM 侧 Micrometer → Tempo）
- 结构化日志字段规范在 `docs/` 维护，为 L5 智能层（日志分析）预留
