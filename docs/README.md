# abnk-system/docs — 工程操作文档（"怎么干活"）

与 `.asdm` 设计文档的分工（事实与设计分离铁律）：

| 关注点 | 归属 |
|---|---|
| 设计、决策、事实基线 | `.asdm/workspace/docs/planning/abnk-design/`（单一事实源，**只链接、不复制**） |
| 工程操作层 how-to：构建指南、环境手册、协作流程、日志字段规范 | 本目录（随代码演进） |

## 现有文档

| 文档 | 内容 |
|---|---|
| [port-allocation.md](port-allocation.md) | ABNK 端口分配规范：本地调试端口统一收敛到 6200–6299 专属段，与 `/Users/leixu/source/asdm/` 其他工作区零冲突；含分配表、契约端口（Fineract 8443 / abnk-pg 5432）与登记流程 |

后续居民预计：Phase 2 的 custom 模块开发手册（模块骨架使用说明 + 同步机制操作步骤）。
