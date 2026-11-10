# ABNK API Gateway（Spring Cloud Gateway，WebFlux）容器镜像
#
# 多阶段：builder = temurin JDK25 + gradle wrapper（9.7.1，与 fineract 仓同版本线）；
#          runtime = temurin JRE25 + curl（compose healthcheck 依赖——temurin 基础
#          镜像不含 curl/wget）。
#
# ⚠️ 构建上下文 = 仓库根（$ABNK_REPO）——gateway_users.json 需自 data/ 打包进镜像
#    （P3.4 口径：用户表只含 PBKDF2 哈希无明文口令，随镜像走不泄漏；容器内
#    ABNK_USERS_FILE=/app/data/gateway_users.json 为 Dockerfile ENV 默认值，
#    不挂宿主卷——宿主路径在容器内不存在，dev 形态 bootRun 才用工程相对路径）。
#
# 构建（仓库根执行；tag 源 = channels/gateway/gradle.properties 的 version）：
#   cd $ABNK_REPO
#   docker build -f channels/gateway/Dockerfile -t abnk-gateway:0.1.0 .
#
# 网关三变量（compose 注入，见 deploy/prod/env/abnk-fullstack.env.example）：
#   ABNK_FINERACT_BASE  容器内网 Fineract 基址（默认经 compose 注入
#                       http://abnk-fineract:8080，prefix /fineract-provider 取
#                       application.yml 缺省）
#   ABNK_USERS_FILE     镜像内默认已配（仅 dev 覆盖）
#   ABNK_JWT_SECRET     生产值经部署根 .env 注入（源 .github-private 凭据档案）

# ⚠️ multi-arch（P3.5 后补）：builder 钉构建机架构（jar 产物架构无关，JVM 字节码
#    COPY 进各目标架构 runtime 层）——避免 QEMU 模拟 gradle 构建；runtime 层
#    eclipse-temurin:25-jre 官方双架构（amd64/arm64）。
FROM --platform=$BUILDPLATFORM eclipse-temurin:25-jdk AS build
WORKDIR /workspace
# 上下文裁剪由 channels/gateway/Dockerfile.dockerignore 承担（仅放行
# channels/gateway/ 与 data/gateway_users.json；build/bin/.gradle 排除）
COPY channels/gateway/ ./
# toolchain = 25：构建 JVM 即 JDK25，Gradle 直接采用、零下载
RUN --mount=type=cache,target=/root/.gradle \
    ./gradlew bootJar --no-daemon

FROM eclipse-temurin:25-jre
RUN apt-get update && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=build /workspace/build/libs/*.jar app.jar
COPY data/gateway_users.json /app/data/gateway_users.json
ENV ABNK_USERS_FILE=/app/data/gateway_users.json
EXPOSE 8080
ENTRYPOINT ["java", "-Xms128m", "-Xmx512m", "-XX:+UseContainerSupport", "-jar", "app.jar"]
