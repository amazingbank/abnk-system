# abnk-system/scripts — 工程脚本

| 位置 | 内容 |
|---|---|
| `lib/fineract_api.py` | API 封装库：自签证书 SSL 上下文、租户头 + Basic 认证、断言助手、步骤记录器 |
| `phase1/smoke_test.py` | **Phase 1 十二步端到端冒烟**（施工图见 `.asdm/.../phase-1-validation.md`） |

## 约定

- 纯 Python 3 标准库（零依赖），环境变量可覆盖一切端点/凭据
- 每步产出：请求/响应/断言结果/耗时，报告落 `../artifacts/phase1/`
- 脚本幂等：重复运行会重新创建带时间戳后缀的实体（externalId 保证可追溯）
- 失败即停（fail-fast），带明确步骤号输出，便于对照施工图排障
