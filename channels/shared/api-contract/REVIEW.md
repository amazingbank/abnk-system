# ABNK Gateway API 契约评审记录（P1.5 契约冻结铁门）

> **契约文件**：`channels/shared/api-contract/openapi.yaml`（OpenAPI 3.1.0，18 paths / 19 operations）
> **评审时点**：2026-11-07（Sprint v0.0.1 Part02 任务 P1.5）
> **裁决方式**：用户确认铁门（VP1.5.3）——回复「确认冻结」进入冻结态；「修改」+ 意见 → 更新重审；「取消」→ 停 Phase

---

## 1. 契约推导依据（D3 契约先行：契约从产品需求长出）

| 依据 | 位置 | 用途 |
|---|---|---|
| 手机银行 repository 接口签名与模型 | `channels/mobile-banking/lib/data/`（P1.3） | 对客面 schema 字段反推（10 方法） |
| Backoffice repository 接口签名与模型 | `channels/backoffice/src/api/repositories/`（P1.4） | 内部面 schema 字段反推（6 方法） |
| Fineract 端点实测形态 | `artifacts/phaseP0/capability-probe.json`（P0.2） | 载荷形态 / command 族 / 分页结构实测口径 |
| 种子数据快照 | `artifacts/phaseP0/seed-poc-evidence.json`（P0.3） | fixture 值域与客户/账户/证照口径 |

## 2. 端点清单与数据来源矩阵（18 paths / 19 operations）

### 2.1 对客通道（手机银行消费，11 operations）

| 契约端点 | repository 方法（消费方） | Fineract 数据来源 | 脱敏 / 收敛字段 | 幂等 / 补偿语义 |
|---|---|---|---|---|
| `POST /login` | mobile `AuthRepository.login` | 用户表 `data/gateway_users.json`（PBKDF2 校验，P0.3） | 口令仅请求方向（`writeOnly`），不落日志 | — |
| `GET /abnk/api/v1/me` | （模型 `UserProfile` 消费；P2.3 MeController 承载） | `GET /clients/{id}` | 姓名姓+首字；手机号尾号形态（`135******01`）；无证件号字段 | — |
| `GET /abnk/api/v1/me/identity` | mobile `IdentityRepository.getIdentity` | `GET /clients/{id}/identifiers` 聚合 | 证件号脱敏（`3301**********001X`）；`status` 为**纯读计算**三态（基线无拦截） | — |
| `GET /abnk/api/v1/me/accounts` | mobile `AccountRepository.getAccounts` | `GET /clients/{id}/accounts` 聚合 | 账号尾号脱敏（`0000**0011`）；定期账户可用余额回退口径声明 | — |
| `GET /abnk/api/v1/accounts/{id}/transactions` | mobile `AccountRepository.getTransactions` | `GET /savingsaccounts/{id}/transactions/search`（P0.2 VP0.2.4 实测：Spring 分页 `content`/`total`，item 22 字段收敛为 6 字段，`runningBalance` 保留） | 隐藏 22→6 字段外的内部字段（chargesPaid / lien / reversal 等） | — |
| `POST /abnk/api/v1/accounts/{id}/transfer` | mobile `AccountRepository.transfer` | **网关聚合**（Fineract 无满足语义的原生端点——planning 层 M7 缺口）：`withdrawal` → `deposit` 两步编排 | — | **幂等**：`externalId` 客户端幂等键，重放返回首次结果；缓存未命中兜底查 Fineract 派生键 `<key>-w`/`<key>-d`（重启不破坏幂等）。**补偿**：第二步失败对第一步自动反向冲正（accounting NONE 口径）；冲正失败 502 + 冲正单号（人工对账） |
| `POST /abnk/api/v1/savings` | mobile `AccountRepository.openFixedDeposit` | `POST /fixeddepositaccounts`（P0.2 VP0.2.3 实测：申请→审批→激活网关侧编排） | 到期日对年对月对日口径（P0.2 实测） | — |
| `GET /abnk/api/v1/loan-products` | mobile `LoanRepository.getLoanProducts` | `GET /loanproducts` | 9 字段收敛（隐藏会计规则 / 审批工作流等内部配置） | — |
| `GET /abnk/api/v1/fixed-deposit-products` | mobile `LoanRepository.getFixedDepositProducts` | `GET /fixeddepositproducts` | 利率 chart 收敛为单一 `interestRate` | — |
| `POST /abnk/api/v1/loans` | mobile `LoanRepository.applyLoan` | `POST /loans`（P0.2 VP0.2.2 实测链路） | 返回收敛为 `loanId` + `status`（Fineract resourceId 形态） | — |
| `GET /abnk/api/v1/loans/{id}` | （P2.3 LoanController 承载；计划显式列出） | `GET /loans/{id}`（P0.2 实测：状态对象 + 还款计划） | 状态对象收敛为字符串值；隐藏还款计划内部字段 | — |

### 2.2 内部通道（Backoffice 消费，8 operations）

| 契约端点 | repository 方法（消费方） | Fineract 数据来源 | 脱敏 / 收敛字段 | 幂等 / 补偿语义 |
|---|---|---|---|---|
| `POST /bo/login` | bo `AuthRepository.login` | 用户表 admin 用户（PBKDF2，P0.3） | 同 `/login`；`channel`=internal，`sub`=username | — |
| `GET /bo/api/v1/clients` | bo `ClientRepository.listClients` | `GET /clients` + 每客户首证照聚合 | 列表页最小投影（8 字段）；`identifierStatus`/`identifierExpiryDate` 为网关推导值 | — |
| `GET /bo/api/v1/clients/{id}` | bo `ClientRepository.getClientDetail` | `GET /clients/{id}` + identifiers + accounts + 贷款关联（网关聚合） | 详情页全量形态（内部面不脱敏证件号——运营视角） | — |
| `GET /bo/api/v1/clients/{id}/identifiers` | （计划显式列出：identifiers GET 族） | `GET /clients/{id}/identifiers` | `derivedStatus` 为网关推导值 | — |
| `GET /bo/api/v1/clients/{id}/identifiers/{identifierId}` | （计划显式列出） | `GET /clients/{id}/identifiers/{identifierId}`（P0.2 VP0.2.1 回读实测） | 同上 | — |
| `PUT /bo/api/v1/clients/{id}/identifiers/{identifierId}` | bo `ClientRepository.updateClientIdentifier` | `PUT /clients/{id}/identifiers/{identifierId}`（P0.2 VP0.2.1 实测闭环：2020-01-01 → 2099-12-31 回读一致） | Fineract 侧必需的 `locale`/`dateFormat` 由**网关注入**，契约面不暴露 | — |
| `GET /bo/api/v1/loans` | bo `LoanRepository.listLoans` | `GET /loans` + 客户投影聚合 | 逾期口径（`overdueDays`/`totalOverdue`/`delinquencyClassification`——P0.3 客户 C 种子：ABNK_POC_OD 分档） | — |
| `POST /bo/api/v1/loans/{id}` | （POC 演示增量预埋：审批 / 放款操作位；基线页面按钮 disabled） | `POST /loans/{id}?command=approve\|disburse`（P0.2 VP0.2.2 实测双 command 200） | 请求体按 command 分形（`oneOf`）；`command` 查询参数保真 Fineract 原生形态 | 基线只读；端点为 POC 现场「审批 + 放款」操作预埋 |

### 2.3 方法覆盖核对结论（VP1.5.2）

- 两端 repository 方法共 **16**（mobile 10 + backoffice 6），全部有契约端点映射或显式声明（`logout` ×2 = JWT 无状态口径的客户端本地动作，无端点）。
- **GAP（页面有方法而契约无端点）：无**。
- 契约中 5 个「计划 / 网关侧要求端点」（`GET /me`、`GET /loans/{id}`、identifiers GET 族、贷款 command 族）不被 P1 页面方法直接消费，但为 P1.5 计划显式列出与 P2.3/P2.5 实现依据——保留。

## 3. 鉴权与通道隔离口径（D2 简化登录）

- 双登录端点：`POST /login`（customer channel）/ `POST /bo/login`（internal channel）→ HS256 JWT（TTL 15min；claim：`sub`、`channel`）。
- 受保护端点 `Authorization: Bearer <token>`；`channel` claim 通道隔离（customer token 打内部面 → 403，契约在内部面端点均声明 403 响应）。
- 后续换 Keycloak 只动签发 / 校验层（D2 口径，契约面不变）。

## 4. 生成器兼容判定（冻结前试生成——计划内嵌步骤）

| 生成器 | 结果 | 产物抽查 |
|---|---|---|
| `typescript-axios`（openapi-generator latest，7.14.0） | ✅ 生成成功，0 error | nullable 字段 → `string \| null`、`Enum \| null` 正确 |
| `dart-dio`（同版本） | ✅ 生成成功（含 `OpenAPI 3.1 support is still in beta` WARN——非错误） | nullable 字段 → `Date?`、`ClientIdentifier?` 正确；5 个 API 类（auth/me/accounts/clients/loans）齐全 |

**判定**：OpenAPI **3.1.0 保持**，无需降级 3.0.x（判据「报错或产物异常」均未触发；本契约未使用 3.1 独有特性）。
**残留风险归档**：dart-dio 对 3.1 支持标记 beta——若 P2.6 正式生成环节出现异常，按计划**语义无损降级为 3.0.x**（转换口径：`type: [T, 'null']` → `type: T` + `nullable: true`；`oneOf` + null → 同式），降级动作走契约变更流程重评审，不静默改。

## 5. lint 归档说明（VP1.5.1）

`npx @redocly/cli@1.x lint` → **0 error / 2 warning**（「Your API description is valid」）：

1. `info-license`：契约未声明 license 字段——ABNK 内部契约，POC 口径无需开源 license，接受。
2. `no-server-example.com`：servers 含 `http://localhost:8080`——dev 形态服务器声明是有意的（P2 dev 联调 + 生成 client 测试基址），生产另有 `https://api.amazingbank.ai`，接受。

过程修复链归档：① 块标量续行缩进笔误（loan-products description 一行 7 空格）→ lint 首跑 bad indentation，修正后过；② `/bo/api/v1/loans/{loanId}` 路径参数名与 `LoanId` 组件（`name: id`）不一致 → lint 2 error，统一为 `{id}` 后归零。

## 6. 基线范围声明（与 P1 阶段口径一致）

- **零证照拦截**：identity 端点为纯读计算；横幅 / 置灰 / 403 拦截为 POC 演示增量（custom Business Step + 网关预检 + 客户端 UX 三层，D1 决策）。
- 贷款 command 族（内部面 POST）为 POC 现场操作预埋；Backoffice 基线页面按钮 disabled（只读）。
- 无 Keycloak / OIDC、无限流、无字段级脱敏引擎（脱敏仅契约内收敛字段）。

## 7. 冻结确认记录（VP1.5.3 用户裁决——待填）

| 项 | 记录 |
|---|---|
| 评审材料索引 | `artifacts/phaseP1/taskP1.5-review-gate.md`（三端同屏截图 + 端点清单 + 走查记录索引） |
| 用户裁决 | ✅ **「确认冻结」**（2026-11-07） |
| 冻结生效时点 | **2026-11-07**——本契约进入冻结态，P2/P3 以此为唯一契约事实源；后续变更须走契约变更流程重评审（VP2.6.2 口径：不得静默改 spec） |

---

*状态同步：本评审记录与 `v0.0.1-Part02-Plan.md` 任务 P1.5 状态一致；执行规则遵循 toolset action `abnk-doc-review.md` rubric。*
