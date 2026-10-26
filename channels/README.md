# abnk-system/channels — 渠道层（L3）

本目录完整对应架构分层的 **L3 渠道层**（`overview.md`）：网关 + 全部渠道前端，一处管完。技术栈定案见 **ADR-008**：React + TypeScript + Vite + Ant Design；网关 Spring Cloud Gateway；移动端混合 App。

## 子目录

| 目录 | 渠道 | 说明 | 阶段 | 状态 |
|---|---|---|---|---|
| `website/` | 官网 | 品牌站（bolt.new 生成已验收）；零业务 API、静态部署 | 已交付原型 | ✅ 活跃 |
| `gateway/` | 渠道整合层 | 路由 / 鉴权(OIDC) / 租户注入 / 字段脱敏 / 限流；国密商密收口（ADR-007） | Phase 3 | 占位 |
| `backoffice/` | 管理后台 | 内部运营（Ant Design Pro） | Phase 3 首个交付 | 占位 |
| `counter/` | 柜面 | 网点柜员操作 | Phase 3 末 | 占位 |
| `online-banking/` | 网银 | 对客 Web | Phase 4 | 占位 |
| `mobile-banking/` | 手机银行 | 混合 App：原生薄壳只做安全与设备能力，业务页面 H5（`harmony/` `android/` `ios/` `h5/` 四子目录） | Phase 5 | 占位 |
| `shared/` | 跨渠道共享 | 网关 OpenAPI 生成的 TS client、组件库、设计 tokens | Phase 3 | 占位 |

## 铁律（ADR-005 / ADR-008 衍生约束）

1. 前端**永不直连** Fineract 8443，一律经 `gateway/`
2. 前端 API 类型一律从网关 OpenAPI 生成（`shared/`），不手写
3. 网关生产黑名单：`/v1/internal/*` 全部 21 个端点（`api-gateway.md` §3）
4. 官网（`website/`）不得调用任何业务 API，数据只允许本地静态内容
5. 移动端壳不承载业务逻辑；安全键盘/生物识别等原生能力经桥接层暴露给 H5

## 设计基调

官网沉淀的暖色 design tokens（象牙白/深炭咖/铜金/琥珀）与 Palantir 式排版规范（eyebrow/statement/留白/深浅节奏，见 `website/bolt-new-prompt.md` 的沉淀建议）作为 ABNK 全渠道品牌表达基础，后续登录页与工作台在此基础上扩展。
