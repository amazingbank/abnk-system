import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { fileURLToPath, URL } from 'node:url';

// ABNK 端口规范（abnk-system/docs/port-allocation.md）：
// 6203 = backoffice dev（6204 preview 成对）；strictPort：端口被占直接报错，
// 不自动漂移——冲突要暴露而不是静默换端口。
const devPort = Number(process.env.ABNK_BO_PORT) || 6203;

// P3.2 接线：dev server proxy——remote 模式（VITE_ABNK_API_BASE 非空，见
// src/api/dataSource.ts）经同源相对路径转发到 ABNK 网关（ADR-005：前端
// 永不直连 Fineract）。mock 模式无网络请求，proxy 常驻不干扰。
// 目标可经 ABNK_GW_BASE 覆盖（默认本地 dev 网关 :8080）。
const gwProxyTarget = process.env.ABNK_GW_BASE || 'http://localhost:8080';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url)),
    },
  },
  server: {
    port: devPort,
    strictPort: true,
    proxy: {
      '/bo': { target: gwProxyTarget, changeOrigin: true },
    },
  },
  preview: {
    port: devPort + 1,
    strictPort: true,
  },
});
