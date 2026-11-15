# ABNK 手机银行 — Flutter web 载体容器镜像
#
# 多阶段：builder = ubuntu + Flutter SDK（官方 release 归档钉版本 + sha256 校验）
#          runtime = nginx 静态托管。
#
# ⚠️ Flutter SDK 版本口径：本地/CI 工具链为 3.47.9（Dart 3.13.7，与 pubspec
#    `sdk: ^3.13.7` 精确对齐）。ghcr.io/cirruslabs/flutter 镜像最新仅到 3.44.0
#    （2026-11-09 实测），故 builder 采用官方 tarball 自装——版本与 sha256 双钉，
#    本地（arm64）与服务器（x86_64）构建行为一致。
#
# ABNK mobile banking — container image for the Flutter web carrier.
#
# Multi-stage: builder = ubuntu + Flutter SDK (the official release archive,
# version-pinned and sha256-verified); runtime = static hosting via nginx.
#
# ⚠️ Flutter SDK version policy: the local/CI toolchain is 3.47.9 (Dart
#    3.13.7, exactly matching pubspec's `sdk: ^3.13.7`). The latest
#    ghcr.io/cirruslabs/flutter image only reaches 3.44.0 (verified
#    2026-11-09), so the builder installs the official tarball itself —
#    version and sha256 both pinned, keeping local (arm64) and server
#    (x86_64) builds identical.
#
# ⚠️ API 基址口径（对计划「相对路径」的实测修正）：P3.1 的
#    GeneratedClient._normalizeBaseUrl 契约要求 ABNK_API_BASE 为绝对 URL（生成
#    client 请求路径已含 /login 与 /abnk/api/v1 全前缀，dio 为 baseUrl+path 字符串
#    拼接）——注入网关 origin https://api.amazingbank.ai，经入口 nginx 的 api Host
#    分流直达网关；跨 origin 由网关 CorsConfig 放行（P3.1 web 载体 :6280 → :8080
#    已实测同机制）。本地演练（VP3.4.4）不回放浏览器内容，仅验健康。
#
# ⚠️ API base-URL policy (a field-tested correction to the plan's "relative
#    path"): the P3.1 GeneratedClient._normalizeBaseUrl contract requires
#    ABNK_API_BASE to be an absolute URL (the generated client's request
#    paths already carry the /login and /abnk/api/v1 prefixes, and dio
#    concatenates baseUrl+path as strings) — the gateway origin
#    https://api.amazingbank.ai is injected, reaching the gateway directly
#    via the entry nginx's api Host routing; cross-origin access is allowed
#    by the gateway's CorsConfig (the same mechanism verified in P3.1 from
#    the web carrier :6280 → :8080). The local drill (VP3.4.4) replays no
#    browser content and only verifies health.
#
# ⚠️ mock 数据集语言（Part03 Phase 4 任务 4.2，决策 D3）：`ABNK_DATA_LOCALE`
#    经 ARG + `--dart-define` 编译期烙入 fixtures/<locale>/ 数据集选择
#    （zh-cn / en-us，与 backoffice 的 VITE_ABNK_DATA_LOCALE 同源变量）；
#    运行时 UI 语言切换不切数据集。
#    EN: mock data-set locale (decision D3): ABNK_DATA_LOCALE is baked in at
#    build time via ARG + --dart-define, selecting the fixtures/<locale>/
#    data set (zh-cn / en-us) — the same deployment variable the backoffice
#    consumes; runtime UI language switching never switches the data set.
#
# 构建（仓库根执行）：
#   docker build -f channels/mobile-banking/Dockerfile \
#     -t abnk-mweb:1.0.1 channels/mobile-banking
#   （tag 源 = pubspec.yaml version 1.0.1+2，build number 不入 tag）
# Build (run from the repo root):
#   docker build -f channels/mobile-banking/Dockerfile \
#     -t abnk-mweb:1.0.1 channels/mobile-banking
#   (tag source = pubspec.yaml version 1.0.1+2; the build number never
#    enters the tag)
# check=skip=FromPlatformFlagConstDisallowed

# ⚠️ 构建阶段固定 linux/amd64：Flutter 官方 stable Linux 归档仅发布 x64
#    （releases_linux.json 实测：3.47.x 无 arm64 归档）。服务器（x86_64）原生构建；
#    本地 Apple Silicon 经 Docker Desktop Rosetta 模拟执行。runtime 层（nginx）
#    不受影响——按宿主架构原生拉取。
# ⚠️ The build stage is pinned to linux/amd64: Flutter's official stable
#    Linux archives are published for x64 only (releases_linux.json, field
#    verified: no arm64 archive for 3.47.x). The server (x86_64) builds
#    natively; local Apple Silicon runs under Docker Desktop's Rosetta
#    emulation. The runtime layer (nginx) is unaffected — pulled natively
#    for the host architecture.
FROM --platform=linux/amd64 ubuntu:24.04 AS build
ARG FLUTTER_VERSION=3.47.9
ARG FLUTTER_SHA256=25ed8c3c29d51a7353f2a944310b478af8214920639524b19c50a19e6c044c5a
# mock 数据集语言（zh-cn / en-us）——构建期经 --dart-define 烙入（D3 口径）；
# 缺省值 en-us = 发版拍板（2026-11-12）：应用数据默认英文，显式 --build-arg 可覆盖
# EN: mock data-set locale (zh-cn / en-us), baked in via --dart-define (D3);
# the en-us default is the release decision (2026-11-12) — app data defaults
# to English, overridable via an explicit --build-arg
ARG ABNK_DATA_LOCALE=en-us
# Flutter 工具链依赖（官方 Linux 安装前提：bash/curl/git/unzip/xz-utils）
# Flutter toolchain prerequisites (per the official Linux install docs:
# bash/curl/git/unzip/xz-utils)
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl git unzip xz-utils \
    && rm -rf /var/lib/apt/lists/*
RUN curl -fsSL -o /tmp/flutter.tar.xz \
      "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
    && echo "${FLUTTER_SHA256}  /tmp/flutter.tar.xz" | sha256sum -c - \
    # --no-same-owner：归档内文件属主非 root，tar 保属主会让 git 判定 dubious
    # ownership（实测 exit 128）；解压归当前用户（root）所有
    # --no-same-owner: the archive's files are owned by a non-root user;
    # preserving ownership makes git report "dubious ownership" (verified:
    # exit 128) — extract as the current user (root) instead
    && tar --no-same-owner -xJf /tmp/flutter.tar.xz -C /opt && rm /tmp/flutter.tar.xz
ENV PATH=/opt/flutter/bin:${PATH}
# flutter 工具链以 git 仓库形态自检版本——显式登记 safe.directory（双保险）
# The flutter toolchain self-checks its version as a git repository —
# register safe.directory explicitly (belt and braces)
RUN git config --global --add safe.directory /opt/flutter \
    && flutter config --no-analytics
WORKDIR /app
# 依赖层先行（pubspec 不变即命中缓存；缓存卷加速重复构建）。
# openapi 为路径依赖（openapi-generated/）——pub get 只读其 pubspec.yaml，
# 单文件前置即可保持依赖层独立于生成代码变化
# Dependency layer first (cache hits while pubspec is unchanged; the cache
# volume speeds up repeated builds).
# openapi is a path dependency (openapi-generated/) — pub get only reads its
# pubspec.yaml, so fronting that single file keeps the dependency layer
# independent of generated-code changes
COPY pubspec.yaml pubspec.lock ./
COPY openapi-generated/pubspec.yaml ./openapi-generated/pubspec.yaml
RUN --mount=type=cache,target=/root/.pub-cache flutter pub get
COPY . .
# pub cache 挂同一缓存卷（BuildKit cache mount 仅在单 RUN 内可见——不挂则
# dart2js 读不到依赖包，实测 vector_math 等 No such file or directory）
# The pub cache mounts the same cache volume (a BuildKit cache mount is only
# visible inside a single RUN — without it dart2js cannot read the
# dependencies, e.g. the verified "vector_math: No such file or directory")
RUN --mount=type=cache,target=/root/.pub-cache \
    flutter build web --release \
      --dart-define=ABNK_API_BASE=https://api.amazingbank.ai \
      --dart-define=ABNK_DATA_LOCALE=$ABNK_DATA_LOCALE

FROM nginx:1.27-alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
