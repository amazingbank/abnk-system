import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { fileURLToPath, URL } from 'node:url';

// ABNK 端口规范（abnk-system/docs/port-allocation.md）：
// ABNK 本地调试端口统一收敛到 6200-6299 段，避开 asdm 其他工作区
// （asdm-admin-web 5173、asdm-portal 5175、AOS 5194/5195/5197、asdm-ai 5273 等）。
// strictPort：端口被占直接报错，不自动漂移——冲突要暴露而不是静默换端口。
const devPort = Number(process.env.ABNK_WEBSITE_PORT) || 6201;

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
  },
  preview: {
    port: devPort + 1,
    strictPort: true,
  },
  optimizeDeps: {
    exclude: ['lucide-react'],
  },
});
