# abnk-system/custom — 定制模块源（L2）

`custom/abnk/`（product / localization / integration / report 四类别 + 各自 starter）的**源码放在本目录**，规范见 `.asdm/.../02-architecture/customization-strategy.md`（宪法）。

## 规划结构（Phase 2 搭骨架）

```
custom/
├── abnk/
│   ├── product/{savings,consumer-loan,starter}/     # 产品定义
│   ├── localization/{identity,starter}/             # 本地化（证照校验/证照服务）
│   ├── integration/{events,starter}/                # 外部系统适配（事件订阅/推送）
│   └── report/{regulatory,starter}/                 # 监管报送辅助
├── templates/     # 模块骨架模板（宪法 §2）——新模块复制即用
└── sync/          # 与 fineract 仓 custom/abnk 的同步机制（方案定案后落此处）
```

第一个落地模块：`localization/identity`（身份证 18 位校验，宪法 §7）。命名空间 `com.abnk.fineract`，建表只走 `db/custom-changelog/`（红线 R2/R3）。

## ⚠️ 物理位置约束（Phase 2 开项时必须先解决）

Gradle 的动态扫描只认 **fineract 仓库内**的 `custom/<company>/<category>/<module>/` 路径（`settings.gradle:87-94`），因此本目录的源必须进入 fineract 的 `custom/` 才会被编译。三个候选方案：

| 方案 | 做法 | 代价 |
|---|---|---|
| A. 符号链接 | `fineract/custom/abnk → ../../abnk-system/custom/abnk` | 零拷贝；跨平台脆弱（Windows 不友好），`eachDir` 跟随软链的行为需实测 |
| B. 同步脚本 | 本目录为源，`scripts/` 提供 rsync 到 `fineract/custom/abnk/` | 双份物理拷贝；提交纪律要求"只改本目录" |
| C. Gradle 重定向 | 修改 `settings.gradle` 给 include 显式 `projectDir` 指向本目录 | 单份源；但改 settings.gradle 属 fork 本地改动（风险级别同 ADR-002 的 provider 依赖行） |

**倾向 C**（单事实源 + 改动面小且声明式），Phase 2 开项时做 PoC 定案——三个方案都要验证 `eachDir`/`projectDir` 与 Liquibase classpath 扫描的兼容性。定案前本目录不放任何模块代码。
