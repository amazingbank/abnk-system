import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { fileURLToPath, URL } from 'node:url';

// ABNK 端口规范（abnk-system/docs/port-allocation.md）：
// 6203 = backoffice dev（6204 preview 成对）；strictPort：端口被占直接报错，
// 不自动漂移——冲突要暴露而不是静默换端口。
const devPort = Number(process.env.ABNK_BO_PORT) || 6203;

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
});
