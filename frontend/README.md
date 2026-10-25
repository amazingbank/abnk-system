# abnk-system/frontend — 前端（Phase 3 占位）

ADR-005 三套前端，交付顺序：

1. `admin/` — 管理后台（租户/产品/作业管理）
2. `teller/` — 柜面
3. `online-banking/` + `mobile/` — 网银 / 手机银行

**边界规则**：永不直连 Fineract 8443，一律经 API 网关（`02-architecture/api-gateway.md`）；客户端 SDK 用 Fineract 自动生成的 `fineract-client(-feign)`，不手写。
