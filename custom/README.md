# abnk-system/custom — 定制模块源（Phase 2 占位）

`custom/abnk/`（product / localization / integration / report 四类别 + starter）的**源码将放在本目录**，规范见 `.asdm/.../02-architecture/customization-strategy.md`。

## ⚠️ 物理位置约束（Phase 2 开项时必须先解决）

Gradle 的动态扫描只认 **fineract 仓库内**的 `custom/<company>/<category>/<module>/` 路径（`settings.gradle:87-94`），因此本目录的源必须进入 fineract 的 `custom/` 才会被编译。三个候选方案：

| 方案 | 做法 | 代价 |
|---|---|---|
| A. 符号链接 | `fineract/custom/abnk → ../../abnk-system/custom/abnk` | 零拷贝；跨平台脆弱（Windows 不友好），`eachDir` 跟随软链的行为需实测 |
| B. 同步脚本 | 本目录为源，`scripts/` 提供 rsync 到 `fineract/custom/abnk/` | 双份物理拷贝；提交纪律要求"只改本目录" |
| C. Gradle 重定向 | 修改 `settings.gradle` 给 include 显式 `projectDir` 指向本目录 | 单份源；但改 settings.gradle 属 fork 本地改动（风险级别同 ADR-002 的 provider 依赖行） |

**倾向 C**（单事实源 + 改动面小且声明式），Phase 2 开项时做 PoC 定案——三个方案都要验证 `eachDir`/`projectDir` 与 Liquibase classpath 扫描的兼容性。

在定案之前，本目录不放任何模块代码。
