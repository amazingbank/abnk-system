# ABNK Website — 官网渠道前端（Vite React SPA）
#
# 多阶段自含构建：builder 阶段 npm ci + vite build，产物阶段 nginx 托管。
# 构建上下文 = channels/website/（.dockerignore 排除 node_modules / dist）。
# TLS 证书不入镜像——运行时从部署根只读挂载 /etc/nginx/ssl（compose 注入），
# 证书续期 = 覆盖挂载文件 + restart，无需重建镜像。

# ---------- builder ----------
FROM node:20-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --no-audit --no-fund
COPY . .
RUN npm run build

# ---------- runtime ----------
FROM nginx:1.27-alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80 443
