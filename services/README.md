# abnk-system/services — 外围服务（Phase 4 占位）

事件总线的订阅方与外部系统集成适配，规划见 `.asdm/.../02-architecture/event-bus.md`：

- 支付适配（网联/银联/人行报文）
- 通知服务（短信/推送）
- 风控订阅方（实时规则）
- 报送数据服务（EAST/1104）

**边界规则**：记账唯一入口 = Fineract API；订阅方永不直连业务库（依赖方向见 `02-architecture/overview.md`）。
