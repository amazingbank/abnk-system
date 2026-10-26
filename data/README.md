# abnk-system/data — L1 本地化数据资产

经 API/脚本**施加**到系统的配置数据定义。入库的是"定义"（YAML 源），不是数据库内容——不违反"数据不入库"纪律。设计依据：`.asdm/.../03-data-model/` 与 `05-domains/`。

## 规划子目录（Phase 2 建）

| 子目录 | 内容 | 阶段 |
|---|---|---|
| `coa/` | 会计科目表定义（**Phase 2 关键路径**，待会计专业输入；五步路径见 `05-domains/accounting.md`） | Phase 2 |
| `calendars/` | 计息/结息日历、假日表 | Phase 2 |
| `seed/` | 租户初始化、产品参数模板 | Phase 2 |

## 格式约定（规划）

- **YAML 为源** + JSON Schema 校验 + Python 施加脚本（复用 `scripts/lib/` 的 API 封装）
- 声明式、可 diff、schema 硬约束（AI 生成不出格）
- 施加动作幂等，可重复执行
