# channels/website — ABNK 官网（品牌站）

bolt.new 生成并验收的高保真原型，提示词与验收清单见 [`bolt-new-prompt.md`](bolt-new-prompt.md)。

- **定位**：品牌叙事单页（双重身份 / 全球拓展路径 / ASDM 体系 / 开源透明），非业务渠道
- **技术栈**：React + TypeScript + Vite + Tailwind CSS
- **边界（ADR-008）**：零业务 API 调用；不经网关；无第三方持久化服务；数据为本地静态内容
- **后续**：暖色 design tokens 回填为全渠道设计系统基础；已预留"网银入口 · 即将上线"占位（提示词迭代 3）

## 本地运行

```bash
npm install
npm run dev        # 开发服务器
npm run typecheck  # 类型检查
npm run build      # 构建
npm run lint       # ESLint
```

## 待清理

- `package.json` 依赖中的 `@supabase/supabase-js` 为 bolt 模板残留（提示词明令禁止第三方持久化），确认无代码引用后移除
