# abnk-system/channels — 渠道层（L3）

本目录完整对应架构分层的 **L3 渠道层**（`overview.md`）：网关 + 全部渠道前端，一处管完。技术栈定案见 **ADR-008**：React + TypeScript + Vite + Ant Design；网关 Spring Cloud Gateway；移动端混合 App。

## 子目录

| 目录 | 渠道 | 说明 | 阶段 | 状态 |
|---|---|---|---|---|
| `website/` | 官网 | 品牌站（bolt.new 生成已验收）；零业务 API、静态部署 | 已交付原型 | ✅ 活跃（P3.4 容器化，端口收编） |
| `gateway/` | 渠道整合层 | SCG + 简化登录/JWT（D2）/ 双通道隔离 / 转账聚合幂等 / 对客收敛面 + 黑名单；容器化（P3.4） | Part02 P2.1–P2.7 | ✅ 已交付（dev :8080，镜像 ghcr） |
| `backoffice/` | 管理后台 | 内部运营（React + AntD v5 暖色定制；P3.2 接线生成 client 连真实网关） | Part02 P1.4 / P3.2 | ✅ 已交付（remote 模式） |
| `counter/` | 柜面 | 网点柜员操作 | Phase 3 末 | 占位 |
| `online-banking/` | 网银 | 对客 Web | Phase 4 | 占位 |
| `mobile-banking/` | 手机银行 | Flutter 工程（ADR-009）：web + iOS + Android 三目标；P3.1 接线生成 client 连真实网关 | Part02 P1.3 / P3.1 | ✅ 已交付（remote 模式，dev web :6280） |
| `shared/` | 跨渠道共享 | 冻结 OpenAPI 契约（P1.5）+ Dart/TS 生成 client（P2.6）+ 设计 tokens | Part02 P1.2/P1.5/P2.6 | ✅ 已交付（契约单一事实源） |

## 铁律（ADR-005 / ADR-008 衍生约束）

1. 前端**永不直连** Fineract 8443，一律经 `gateway/`
2. 前端 API 类型一律从网关 OpenAPI 生成（`shared/`），不手写
3. 网关生产黑名单：`/v1/internal/*` 全部 21 个端点（`api-gateway.md` §3）
4. 官网（`website/`）不得调用任何业务 API，数据只允许本地静态内容
5. 移动端壳不承载业务逻辑；安全键盘/生物识别等原生能力经桥接层暴露给 H5

## 设计基调

官网沉淀的暖色 design tokens（象牙白/深炭咖/铜金/琥珀）与 Palantir 式排版规范（eyebrow/statement/留白/深浅节奏，见 `website/bolt-new-prompt.md` 的沉淀建议）作为 ABNK 全渠道品牌表达基础，后续登录页与工作台在此基础上扩展。
