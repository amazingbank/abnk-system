/// <reference types="vite/client" />

/**
 * 构建期 env 类型声明（任务 P3.2）——`import.meta.env` 的项目内补充。
 *
 * - `VITE_ABNK_API_BASE`：数据源切换开关（dataSource.ts 判定）——
 *   非空 → remote（P2.6 生成 client 经网关连真实 Fineract 数据）；
 *   空 / 未设置 → mock（P0.3 种子快照，P1 原型口径）。
 *   取值口径：`'/'` = 同源相对路径（dev 走 vite proxy、生产走同域反代）；
 *   也可为绝对基址（如 http://localhost:8080，网关 CORS 已在 P3.1 放行）。
 */

interface ImportMetaEnv {
  readonly VITE_ABNK_API_BASE?: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
