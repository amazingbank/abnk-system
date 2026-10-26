# abnk-system/scripts — 工程脚本

| 位置 | 内容 |
|---|---|
| `lib/fineract_api.py` | API 封装库：自签证书 SSL 上下文、租户头 + Basic 认证、断言助手、步骤记录器 |

> Phase 1 冒烟（`smoke_test.py`）已于 2026-10-26 迁移至 `../tests/smoke/`——回归资产归 `tests/`，本目录只留工具库。`data/` 的施加脚本（Phase 2）将复用 `lib/`。

## 约定

- 纯 Python 3 标准库（零依赖），环境变量可覆盖一切端点/凭据
- 脚本幂等：重复运行可追溯（externalId / 时间戳后缀）
- 失败即停（fail-fast），带明确步骤号输出，便于对照施工图排障
