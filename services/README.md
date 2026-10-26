# abnk-system/services — 外围服务（L4，Phase 4 占位）

事件总线的订阅方与外部系统集成适配，规划见 `.asdm/.../02-architecture/event-bus.md`。

## 规划子目录

| 子目录 | 内容 |
|---|---|
| `notification/` | 通知服务（短信/推送，event-bus 首个消费者） |
| `payment-adapter/` | 支付适配（网联/银联/人行报文，骨架见 `05-domains/payments.md`） |
| （按需） | 风控订阅方（实时规则）、报送数据服务（EAST/1104，依赖 COA 稳定一个报送周期） |

技术栈（2026-10-26 定案）：Java + Spring Boot 3 + Spring Kafka + Avro（与 custom 同 JVM 栈，CI/观测/测试复用同一套）。

## 边界规则

- 记账唯一入口 = Fineract API；订阅方**永不直连业务库**（依赖方向见 `overview.md`）
- 若行方强制国产 MQ，在本层加 adapter 隔离，**不碰核心 event-bus**（ADR-007 协议标准原则）
