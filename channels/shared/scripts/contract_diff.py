#!/usr/bin/env python3
"""契约一致性校验（Sprint v0.0.1 Part02 任务 P2.6，D3 契约先行闭环）。

拉取网关 springdoc 导出（$GW_BASE/v3/api-docs）与冻结契约（P1.5 出口
channels/shared/api-contract/openapi.yaml）比对，输出 `DRIFT: <n>`。

比对口径（Phase P2 容差声明 + 实测口径归档）：
- 路径级：字面比对（不做前缀归一化——冻结 spec 的 paths 写全具体前缀，两边
  字面一致才算匹配）；每路径的 HTTP 方法集合比对。
- 字段级：请求体 / 200 响应体的字段名集合。实测 springdoc（2.8.9）对 Java
  record 生成的 schema 无 required 标注，故采用双向包含口径（比契约必填
  字段名集合更严）：
      契约 required ⊆ 实现字段（必填不可缺）
      实现字段 ⊆ 契约 properties（不允许契约外字段 / 多余投影）
  实现省略契约**可选**属性（如 Account.interestRate——对客收敛面实测列表
  无此数据）不计漂移。$ref 递归解析 + allOf 合并 + oneOf 取并集；数组取
  items 的字段集合；**不比 schema $ref 命名与结构**（springdoc 命名与手写
  spec 必然不同）。
- 白名单（容差声明）：
  - springdoc 导出侧忽略：/actuator/**、/v3/**、/error、/swagger-ui/**
    （spring 自有端点）
  - 契约侧忽略：/bo/api/**（BoRouteFilter 路由转发实现，无 @RestController，
    springdoc 天然不可见；其一致性由 P2.5 隔离单测与 VP2.5.2/VP2.5.3
    行为判据保障，不参与 diff）
- 错误响应（401/403/404/…）不比（统一 ErrorResponse 载荷由单测与集成剧本保障）。

依赖：宿主 python3 无 yaml 模块——冻结契约经 `npx --yes js-yaml` 转 JSON
（node v22 实测可用；与 openapi-generator-cli 同一 npx 工具链）。

用法：python3 contract_diff.py [gateway_base_url]
      gateway_base_url 默认 http://localhost:8080
退出码：0 = DRIFT: 0；1 = 存在漂移或前置失败（网关未就绪 / 契约缺失）。
"""

import json
import os
import subprocess
import sys
import urllib.request

HTTP_METHODS = {"get", "post", "put", "delete", "patch"}
# springdoc 导出侧白名单（spring/springdoc 自有端点，前缀匹配）
IMPL_WHITELIST = ("/actuator/", "/v3/", "/error", "/swagger-ui")
# 契约侧白名单（bo 通道转发族——路由转发实现，springdoc 不可见）
CONTRACT_WHITELIST = ("/bo/api/",)

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
CONTRACT_YAML = os.path.join(SCRIPT_DIR, "..", "api-contract", "openapi.yaml")


def fail(msg):
    print(f"DRIFT-ABORT: {msg}")
    sys.exit(1)


def load_contract():
    """冻结契约 YAML → dict（npx js-yaml 转换；宿主 python3 无 yaml 模块）。"""
    if not os.path.isfile(CONTRACT_YAML):
        fail(f"冻结契约不存在: {CONTRACT_YAML}")
    try:
        proc = subprocess.run(["npx", "--yes", "js-yaml", CONTRACT_YAML],
                              capture_output=True, text=True, timeout=120)
    except FileNotFoundError:
        fail("npx 不可用（需要 node 工具链转换契约 YAML）")
    if proc.returncode != 0:
        fail(f"js-yaml 转换失败: {proc.stderr.strip()[:200]}")
    return json.loads(proc.stdout)


def load_exported(base):
    """拉取网关 springdoc 导出 /v3/api-docs。"""
    try:
        with urllib.request.urlopen(f"{base}/v3/api-docs", timeout=10) as resp:
            return json.loads(resp.read().decode("utf-8"))
    except Exception as e:  # noqa: BLE001——前置失败统一退出
        fail(f"无法拉取 {base}/v3/api-docs（网关未就绪？）: {e}")


def whitelisted(path, prefixes):
    return any(path == p.rstrip("/") or path.startswith(p) for p in prefixes)


def resolve(schema, components):
    """$ref 递归解析（契约与 springdoc 两侧通用）。"""
    seen = 0
    while schema and "$ref" in schema and seen < 10:
        name = schema["$ref"].split("/")[-1]
        schema = components.get(name, {})
        seen += 1
    return schema


def schema_fields(schema, components):
    """schema → 顶层属性字段名集合（allOf 合并 / oneOf 取并集 / 数组取 items；None = 无 schema）。"""
    if not schema:
        return None
    schema = resolve(schema, components)
    if not schema:
        return set()
    if schema.get("type") == "array":
        return schema_fields(schema.get("items"), components) or set()
    fields = set(schema.get("properties", {}).keys())
    for combinator in ("allOf", "oneOf", "anyOf"):
        for sub in schema.get(combinator, []):
            sub_fields = schema_fields(sub, components)
            if sub_fields:
                fields |= sub_fields
    return fields


def schema_required(schema, components):
    """schema → required 字段名集合（allOf 合并；数组下钻 items）。"""
    if not schema:
        return set()
    schema = resolve(schema, components)
    if schema.get("type") == "array":
        return schema_required(schema.get("items"), components)
    required = set(schema.get("required", []))
    for sub in schema.get("allOf", []):
        required |= schema_required(sub, components)
    return required


def body_schema(op, response_code=None):
    """操作 → 请求体 schema 或指定响应码的 schema（content 兼容 application/json 与 */*）。"""
    if response_code is None:
        media = (op.get("requestBody") or {}).get("content", {})
    else:
        media = ((op.get("responses") or {}).get(response_code) or {}).get("content", {})
    for key in ("application/json", "*/*"):
        if key in media:
            return media[key].get("schema")
    return media[next(iter(media))].get("schema") if media else None


def main():
    base = sys.argv[1] if len(sys.argv) > 1 else os.environ.get("ABNK_GW_BASE", "http://localhost:8080")
    contract = load_contract()
    exported = load_exported(base)

    contract_components = contract.get("components", {}).get("schemas", {})
    impl_components = exported.get("components", {}).get("schemas", {})

    contract_paths = {p for p in contract.get("paths", {}) if not whitelisted(p, CONTRACT_WHITELIST)}
    impl_paths = {p for p in exported.get("paths", {}) if not whitelisted(p, IMPL_WHITELIST)}

    drifts = []

    for path in sorted(contract_paths - impl_paths):
        drifts.append(f"路径缺失（契约有、导出无）: {path}")
    for path in sorted(impl_paths - contract_paths):
        drifts.append(f"路径多余（导出有、契约无）: {path}")

    for path in sorted(contract_paths & impl_paths):
        c_ops = {m for m in contract["paths"][path] if m in HTTP_METHODS}
        i_ops = {m for m in exported["paths"][path] if m in HTTP_METHODS}
        for m in sorted(c_ops - i_ops):
            drifts.append(f"方法缺失: {path} [{m.upper()}]")
        for m in sorted(i_ops - c_ops):
            drifts.append(f"方法多余: {path} [{m.upper()}]")
        for m in sorted(c_ops & i_ops):
            c_op = contract["paths"][path][m]
            i_op = exported["paths"][path][m]
            # 请求体
            c_req_schema = body_schema(c_op)
            if c_req_schema is not None:
                c_required = schema_required(c_req_schema, contract_components)
                c_fields = schema_fields(c_req_schema, contract_components) or set()
                i_fields = schema_fields(body_schema(i_op), impl_components)
                if i_fields is None:
                    drifts.append(f"请求体 schema 缺失: {path} [{m.upper()}]")
                else:
                    missing = c_required - i_fields
                    extra = i_fields - c_fields
                    if missing:
                        drifts.append(f"请求体缺必填字段: {path} [{m.upper()}] {sorted(missing)}")
                    if extra:
                        drifts.append(f"请求体多余字段: {path} [{m.upper()}] {sorted(extra)}")
            # 200 响应体
            c_resp_schema = body_schema(c_op, "200")
            if c_resp_schema is not None:
                c_required = schema_required(c_resp_schema, contract_components)
                c_fields = schema_fields(c_resp_schema, contract_components) or set()
                i_fields = schema_fields(body_schema(i_op, "200"), impl_components)
                if i_fields is None:
                    drifts.append(f"200 响应 schema 缺失: {path} [{m.upper()}]")
                else:
                    missing = c_required - i_fields
                    extra = i_fields - c_fields
                    if missing:
                        drifts.append(f"响应缺必填字段: {path} [{m.upper()}] {sorted(missing)}")
                    if extra:
                        drifts.append(f"响应多余字段: {path} [{m.upper()}] {sorted(extra)}")

    print(f"契约路径（白名单过滤后）: {len(contract_paths)}；导出路径（白名单过滤后）: {len(impl_paths)}")
    for d in drifts:
        print(f"DRIFT: {d}")
    print(f"DRIFT: {len(drifts)}")
    sys.exit(0 if not drifts else 1)


if __name__ == "__main__":
    main()
