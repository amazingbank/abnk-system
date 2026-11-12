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
# 数据集语言注入（Part03 Phase 2 任务 2.2，决策 D3）：部署侧变量
# ABNK_DATA_LOCALE 经 ARG 传入，构建期烘焙为 VITE_ABNK_DATA_LOCALE
# （Vite 前缀铁律：进 import.meta.env 必须 VITE_ 前缀，两名字并存 =
# 部署层与构建层命名域分离）；mock 数据集 zh-cn/en-us 由该变量构建期
# 选择，bundle 只含所选数据集，运行时 UI 语言切换不切数据集。
# Data-set locale injection (Part03 Phase 2 task 2.2, decision D3): the
# deployment-side variable ABNK_DATA_LOCALE flows in through ARG and is
# baked at build time into VITE_ABNK_DATA_LOCALE (Vite prefix rule:
# variables entering import.meta.env must carry the VITE_ prefix; the two
# coexisting names separate the deployment and build naming domains); the
# zh-cn/en-us mock data set is selected at build time so the bundle carries
# only the chosen one, and runtime UI language switching never switches it.
#
# 构建（仓库根执行）：
#   docker build -f channels/backoffice/Dockerfile \
#     -t abnk-bo:0.1.0 channels/backoffice
#   （tag 源 = package.json version 0.1.0，patch 递增纪律同 website Iron Rule 4）

# ---------- builder ----------
# multi-arch：builder 钉构建机架构（npm build 产物为静态文件，架构无关）
FROM --platform=$BUILDPLATFORM node:22-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --no-audit --no-fund
COPY . .
# remote 模式开关注入（构建期烘焙进 import.meta.env）
# 数据集语言注入：ARG 先声明后引用（builder 阶段 RUN 之前）
# Data-set locale injection: declare ARG before referencing it (ahead of the builder-stage RUN)
ARG ABNK_DATA_LOCALE=zh-cn
RUN VITE_ABNK_API_BASE=https://api.amazingbank.ai VITE_ABNK_DATA_LOCALE=$ABNK_DATA_LOCALE npm run build

# ---------- runtime ----------
FROM nginx:1.27-alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
