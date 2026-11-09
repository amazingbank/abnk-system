# ABNK Backoffice（运营后台，Vite React SPA）容器镜像
#
# 多阶段自含构建：builder 阶段 npm ci + vite build（node 22 = 本地开发工具链
# v22.23.1 对齐），产物阶段 nginx 静态托管。范式对齐 channels/website/Dockerfile。
#
# ⚠️ API 基址口径（对计划「相对路径」的实测修正）：P3.2 的 dataSource/
#    generatedClient 契约——`VITE_ABNK_API_BASE` 绝对基址 = 跨 origin 直连
#    （网关 CorsConfig + OPTIONS 直通已在 P3.1/P3.2 放行验证）。注入网关 origin
#    https://api.amazingbank.ai，经入口 nginx 的 api Host 分流直达网关。
#
# 构建（仓库根执行）：
#   docker build -f channels/backoffice/Dockerfile \
#     -t abnk-bo:0.1.0 channels/backoffice
#   （tag 源 = package.json version 0.1.0，patch 递增纪律同 website Iron Rule 4）

# ---------- builder ----------
FROM node:22-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --no-audit --no-fund
COPY . .
# remote 模式开关注入（构建期烘焙进 import.meta.env）
RUN VITE_ABNK_API_BASE=https://api.amazingbank.ai npm run build

# ---------- runtime ----------
FROM nginx:1.27-alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
