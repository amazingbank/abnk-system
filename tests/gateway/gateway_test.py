#!/usr/bin/env python3
"""ABNK 网关集成测试剧本（Phase P2.7 任务资产）。

把 P2.2–P2.5 的 curl 断言固化为可重跑的端到端剧本（对本地生产形态栈全链路）：
环境健康 → 登录三用户（含通道严格匹配负向）→ me/identity/accounts/transactions
→ 转账正向 + 幂等重放 + 越权 403 → bo 面 + 通道隔离 + identifiers PUT→恢复
→ 黑名单三断言。

约定（Phase P2 详细计划 P2.7 口径）：
- 纯 Python 标准库，零第三方依赖；复用 scripts/lib/fineract_api.py 的
  Client/StepRunner 思路，但直连网关 :8080 并改用 Bearer 头（Fineract 双头由网关注入）
- 演示口令经环境变量 ABNK_DEMO_CREDENTIALS 注入（指向 P0.3 归档处
  .github-private/kbank-poc/gateway-demo-passwords.json），不入剧本代码与报告 JSON
- 幂等后缀 TS 模式：转账 externalId 携带毫秒时间戳，剧本可重复执行
- 报告 JSON 归档 artifacts/phaseP2/gateway-report-<ts>.json（token 字段一律脱敏）
- 退出码：0 = 全部通过；1 = 任一断言失败（fail-fast）；2 = 前置缺失

用法：
    cd $ABNK_REPO/tests/gateway
    ABNK_DEMO_CREDENTIALS=<path>/gateway-demo-passwords.json python3 gateway_test.py
"""

import json
import os
import ssl
import sys
import time
import urllib.error
import urllib.request
from datetime import datetime

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.abspath(os.path.join(SCRIPT_DIR, "..", ".."))
REPORT_DIR = os.path.join(REPO_ROOT, "artifacts", "phaseP2")

GW_BASE = os.environ.get("ABNK_GATEWAY_BASE", "http://localhost:8080").rstrip("/")
FINERACT_HEALTH = os.environ.get(
    "ABNK_FINERACT_HEALTH", "http://localhost:8081/fineract-provider/actuator/health")
CRED_FILE = os.environ.get("ABNK_DEMO_CREDENTIALS", "")
CRED_INSTANCE = os.environ.get("ABNK_CREDENTIALS_INSTANCE", "local-prodform")

# 剧本设计步骤数（VP2.7.1 判据：报告 steps 计数必须与此相等）
DESIGNED_STEPS = 11

SSL_CTX = None
if GW_BASE.startswith("https"):
    SSL_CTX = ssl.create_default_context()
    SSL_CTX.check_hostname = False
    SSL_CTX.verify_mode = ssl.CERT_NONE


# ---------------------------------------------------------------- HTTP 客户端

class Resp:
    def __init__(self, status, data, raw, elapsed):
        self.status = status
        self.data = data  # 解析后的 JSON（非 JSON 为 None）
        self.raw = raw
        self.elapsed = elapsed

    def __repr__(self):
        return f"<Resp {self.status} {self.raw[:80]}>"


def http(method, path, token=None, body=None, timeout=60):
    """对网关的请求：path 为相对路径（含 /abnk /bo 前缀）；绝对 URL 原样使用。"""
    url = path if path.startswith("http") else GW_BASE + path
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(url, data=data, method=method)
    req.add_header("Accept", "application/json")
    if body is not None:
        req.add_header("Content-Type", "application/json")
    if token:
        req.add_header("Authorization", f"Bearer {token}")
    t0 = time.time()
    try:
        with urllib.request.urlopen(req, timeout=timeout, context=SSL_CTX) as r:
            status, raw = r.status, r.read().decode("utf-8", "replace")
    except urllib.error.HTTPError as e:
        status, raw = e.code, e.read().decode("utf-8", "replace")
    elapsed = time.time() - t0
    try:
        parsed = json.loads(raw) if raw else None
    except json.JSONDecodeError:
        parsed = None
    return Resp(status, parsed, raw, elapsed)


def login(username, password, path="/login"):
    return http("POST", path, body={"username": username, "password": password})


# ---------------------------------------------------------------- 步骤记录器

class Runner:
    def __init__(self):
        self.steps = []

    def step(self, no, name):
        print(f"\n===== 步骤 {no:>2} | {name} =====")
        return _StepCtx(self, no, name)

    def save(self, ok, summary):
        doc = {
            "runAt": datetime.now().isoformat(timespec="seconds"),
            "ok": ok,
            "summary": summary,
            "steps": self.steps,
        }
        os.makedirs(REPORT_DIR, exist_ok=True)
        ts = datetime.now().strftime("%Y%m%d-%H%M%S")
        path = os.path.join(REPORT_DIR, f"gateway-report-{ts}.json")
        with open(path, "w", encoding="utf-8") as f:
            json.dump(_redact(doc), f, ensure_ascii=False, indent=2)
        print(f"\n报告已写入: {path}")
        return path


class _StepCtx:
    def __init__(self, runner, no, name):
        self.runner, self.no, self.name = runner, no, name
        self.detail = {"requests": [], "asserts": []}

    def req(self, method, path, resp):
        print(f"  {method} {path} → {resp.status} ({resp.elapsed:.2f}s)")
        self.detail["requests"].append({
            "method": method, "path": path,
            "status": resp.status, "elapsed": round(resp.elapsed, 2)})
        if resp.data is not None:
            self.detail.setdefault("responses", []).append(_trim(resp.data))
        return resp

    def check(self, label, condition, evidence=None):
        mark = "PASS" if condition else "FAIL"
        print(f"  [{mark}] {label}" + (f" | {evidence}" if evidence is not None else ""))
        self.detail["asserts"].append(
            {"label": label, "pass": bool(condition), "evidence": evidence})
        if not condition:
            raise AssertionError(f"步骤 {self.no} 断言失败: {label} (证据: {evidence})")
        return True

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc, tb):
        self.runner.steps.append(
            {"step": self.no, "name": self.name, **self.detail,
             **({"error": str(exc)} if exc is not None else {})})
        if exc is None:
            print(f"  ---- 步骤 {self.no} 完成")
        return False


def _redact(obj):
    """报告脱敏：token 字段值一律替换（演示口令从不进入报告——读取后仅存于内存局部变量）。"""
    if isinstance(obj, dict):
        return {k: ("<redacted>" if k == "token" else _redact(v)) for k, v in obj.items()}
    if isinstance(obj, list):
        return [_redact(x) for x in obj]
    return obj


def _trim(obj, limit=40):
    """响应入报告前裁剪，避免超大 JSON。"""
    if isinstance(obj, dict):
        out = {}
        for i, (k, v) in enumerate(obj.items()):
            if i >= limit:
                out["_truncated"] = f"...共 {len(obj)} 键"
                break
            out[k] = _trim(v, limit)
        return out
    if isinstance(obj, list):
        return [_trim(x, limit) for x in obj[:limit]] + (
            [{"_truncated": f"...共 {len(obj)} 项"}] if len(obj) > limit else [])
    if isinstance(obj, str) and len(obj) > 300:
        return obj[:300] + "…"
    return obj


def norm_date(v):
    """Fineract 回读日期可能是 [Y,M,D] 数组或字符串，统一为 YYYY-MM-DD。"""
    if isinstance(v, (list, tuple)) and len(v) >= 3:
        return f"{int(v[0]):04d}-{int(v[1]):02d}-{int(v[2]):02d}"
    if isinstance(v, str):
        return v[:10]
    return None


# ---------------------------------------------------------------- 剧本

def scenario(runner, users):
    alice = users["alice"]
    bob = users["bob"]
    admin = users["admin"]
    alice_cid = alice["clientId"]
    bob_cid = bob["clientId"]
    a_src = alice["accounts"]["source"]
    a_dst = alice["accounts"]["target"]
    bob_sav = bob["accounts"]["savings"]

    # 幂等后缀（TS 模式，毫秒级——同秒内两轮剧本也不撞键）
    ts = str(int(time.time() * 1000))
    ext_id = f"GT-{ts}"
    tokens = {}

    # 步骤 1：环境前置（网关 + 生产形态栈健康——风险表口径：health UP 先行）
    with runner.step(1, "环境前置：网关与 Fineract 生产形态栈健康") as s:
        r = s.req("GET", "/actuator/health", http("GET", "/actuator/health"))
        s.check("网关 health HTTP 200", r.status == 200, f"HTTP {r.status}")
        s.check("网关 status=UP", bool(r.data) and r.data.get("status") == "UP",
                str(r.data and r.data.get("status")))
        r2 = s.req("GET", "(:8081) /fineract-provider/actuator/health",
                   http("GET", FINERACT_HEALTH))
        s.check("Fineract 生产形态栈 status=UP",
                r2.status == 200 and bool(r2.data) and r2.data.get("status") == "UP",
                f"HTTP {r2.status}")

    # 步骤 2：登录三用户 + 通道严格匹配负向（P2.2/P2.6 口径）
    with runner.step(2, "登录三用户（alice/bob 对客、admin 内部）+ 通道严格匹配负向") as s:
        r = s.req("POST", "/login (alice)", login("alice", alice["password"]))
        s.check("alice 登录 200", r.status == 200, f"HTTP {r.status}")
        d = r.data or {}
        s.check("alice channel=customer", d.get("channel") == "customer",
                str(d.get("channel")))
        s.check("alice clientId=种子值", d.get("clientId") == alice_cid,
                f"{d.get('clientId')} (期望 {alice_cid})")
        s.check("alice token 三段式（JWT）",
                isinstance(d.get("token"), str) and d["token"].count(".") == 2)
        s.check("alice expiresIn=900", d.get("expiresIn") == 900, str(d.get("expiresIn")))
        tokens["alice"] = d.get("token")

        r = s.req("POST", "/login (bob)", login("bob", bob["password"]))
        s.check("bob 登录 200", r.status == 200, f"HTTP {r.status}")
        d = r.data or {}
        s.check("bob channel=customer", d.get("channel") == "customer",
                str(d.get("channel")))
        s.check("bob clientId=种子值", d.get("clientId") == bob_cid,
                f"{d.get('clientId')} (期望 {bob_cid})")
        tokens["bob"] = d.get("token")

        r = s.req("POST", "/bo/login (admin)", login("admin", admin["password"], "/bo/login"))
        s.check("admin /bo/login 200", r.status == 200, f"HTTP {r.status}")
        d = r.data or {}
        s.check("admin channel=internal", d.get("channel") == "internal",
                str(d.get("channel")))
        s.check("admin role=ADMIN", d.get("role") == "ADMIN", str(d.get("role")))
        tokens["admin"] = d.get("token")

        r = s.req("POST", "/login (admin——负向)", login("admin", admin["password"]))
        s.check("admin 打 /login → 401（通道严格匹配）", r.status == 401,
                f"HTTP {r.status}")
        r = s.req("POST", "/bo/login (alice——负向)",
                  login("alice", alice["password"], "/bo/login"))
        s.check("alice 打 /bo/login → 401（通道严格匹配）", r.status == 401,
                f"HTTP {r.status}")

    # 步骤 3：me 聚合（脱敏断言，P2.3 口径）
    with runner.step(3, "对客 me 聚合（姓名/手机号脱敏）") as s:
        r = s.req("GET", "/abnk/api/v1/me",
                  http("GET", "/abnk/api/v1/me", token=tokens["alice"]))
        s.check("me 200", r.status == 200, f"HTTP {r.status}")
        d = r.data or {}
        s.check("clientId=alice 种子值", d.get("clientId") == alice_cid,
                str(d.get("clientId")))
        s.check("displayName 非空", bool(d.get("displayName")), str(d.get("displayName")))
        s.check("mobileNo 脱敏（含 *）",
                isinstance(d.get("mobileNo"), str) and "*" in d["mobileNo"],
                str(d.get("mobileNo")))
        s.check("无证件号明文字段",
                not {"documentKey", "idNumber"} & set(d.keys()),
                f"键集合 {sorted(d.keys())}")

    # 步骤 4：identity 状态计算（alice 过期种子 EXPIRED / bob VALID）
    with runner.step(4, "identity 状态计算（EXPIRED/VALID 两态）") as s:
        r = s.req("GET", "/abnk/api/v1/me/identity (alice)",
                  http("GET", "/abnk/api/v1/me/identity", token=tokens["alice"]))
        s.check("alice identity 200", r.status == 200, f"HTTP {r.status}")
        d = r.data or {}
        s.check("alice status=EXPIRED（过期种子）", d.get("status") == "EXPIRED",
                str(d.get("status")))
        s.check("alice expiryDate 非空", bool(d.get("expiryDate")),
                str(d.get("expiryDate")))
        s.check("documentKey 脱敏（含 *）",
                isinstance(d.get("documentKey"), str) and "*" in d["documentKey"],
                str(d.get("documentKey")))
        r = s.req("GET", "/abnk/api/v1/me/identity (bob)",
                  http("GET", "/abnk/api/v1/me/identity", token=tokens["bob"]))
        s.check("bob identity 200", r.status == 200, f"HTTP {r.status}")
        d = r.data or {}
        s.check("bob status=VALID（有效种子）", d.get("status") == "VALID",
                str(d.get("status")))

    # 步骤 5：账户列表与交易明细（尾号脱敏 + runningBalance）
    with runner.step(5, "账户总览与单账户明细（尾号脱敏 + runningBalance）") as s:
        r = s.req("GET", "/abnk/api/v1/me/accounts",
                  http("GET", "/abnk/api/v1/me/accounts", token=tokens["alice"]))
        s.check("me/accounts 200", r.status == 200, f"HTTP {r.status}")
        d = r.data or {}
        sav = d.get("savingsAccounts") or []
        s.check("savingsAccounts ≥ 2 项（种子口径）", len(sav) >= 2, f"{len(sav)} 项")
        s.check("accountNo 尾号脱敏（含 *）",
                bool(sav) and all("*" in (a.get("accountNo") or "") for a in sav),
                str([a.get("accountNo") for a in sav]))
        r2 = s.req("GET", f"/abnk/api/v1/accounts/{a_src}/transactions",
                   http("GET", f"/abnk/api/v1/accounts/{a_src}/transactions",
                        token=tokens["alice"]))
        s.check("transactions 200", r2.status == 200, f"HTTP {r2.status}")
        items = r2.data if isinstance(r2.data, list) else []
        s.check("明细 ≥ 1 项", len(items) >= 1, f"{len(items)} 项")
        s.check("明细含 runningBalance 字段",
                bool(items) and "runningBalance" in items[-1],
                str(sorted(items[-1].keys())) if items else "无明细")

    # 步骤 6：转账正向（本人账户间，幂等键 TS 后缀）
    with runner.step(6, "转账正向（withdraw+deposit 聚合）") as s:
        body = {"toAccountId": a_dst, "amount": 100, "externalId": ext_id,
                "note": "P2.7 集成测试正向"}
        r = s.req("POST", f"/abnk/api/v1/accounts/{a_src}/transfer",
                  http("POST", f"/abnk/api/v1/accounts/{a_src}/transfer",
                       token=tokens["alice"], body=body))
        s.check("转账 200", r.status == 200, f"HTTP {r.status}")
        d = r.data or {}
        s.check("transactionId 存在", isinstance(d.get("transactionId"), int),
                str(d.get("transactionId")))
        s.check("newSourceBalance 为数值",
                isinstance(d.get("newSourceBalance"), (int, float)),
                str(d.get("newSourceBalance")))
        first = json.dumps(d, sort_keys=True)
        s.detail["firstResponse"] = d

    # 步骤 7：转账幂等重放（同 externalId → 同结果，不重复落账）
    with runner.step(7, "转账幂等重放（同 externalId 同结果）") as s:
        body = {"toAccountId": a_dst, "amount": 100, "externalId": ext_id,
                "note": "P2.7 集成测试正向"}
        r = s.req("POST", f"/abnk/api/v1/accounts/{a_src}/transfer",
                  http("POST", f"/abnk/api/v1/accounts/{a_src}/transfer",
                       token=tokens["alice"], body=body))
        s.check("重放 200", r.status == 200, f"HTTP {r.status}")
        replay = json.dumps(r.data or {}, sort_keys=True)
        prev = json.dumps(s_prev_response(runner, 6), sort_keys=True)
        s.check("重放响应与首次逐字一致（transactionId 不变=未重复落账）",
                replay == prev, f"transactionId={(r.data or {}).get('transactionId')}")

    # 步骤 8：转账越权（转出账户填 bob 的账户 → 403 服务端归属校验）
    with runner.step(8, "转账越权负向（bob 账户 → 403）") as s:
        body = {"toAccountId": a_dst, "amount": 100, "externalId": f"GT-X-{ts}"}
        r = s.req("POST", f"/abnk/api/v1/accounts/{bob_sav}/transfer",
                  http("POST", f"/abnk/api/v1/accounts/{bob_sav}/transfer",
                       token=tokens["alice"], body=body))
        s.check("越权转账 403（转出账户不属于当前客户）", r.status == 403,
                f"HTTP {r.status}")

    # 步骤 9：bo 面可达 + 通道隔离（P2.5 口径）
    with runner.step(9, "内部通道 bo 面 + 通道隔离") as s:
        r = s.req("GET", "/bo/api/v1/clients?limit=10",
                  http("GET", "/bo/api/v1/clients?limit=10", token=tokens["admin"]))
        s.check("admin 查 bo 客户面 200", r.status == 200, f"HTTP {r.status}")
        d = r.data or {}
        total = d.get("total", d.get("totalFilteredRecords"))
        s.check("客户总数 ≥ 3（种子客户 A/B/C）", isinstance(total, int) and total >= 3,
                f"total={total}")
        r = s.req("GET", "/bo/api/v1/clients?limit=10 (alice——负向)",
                  http("GET", "/bo/api/v1/clients?limit=10", token=tokens["alice"]))
        s.check("alice 打 bo 面 → 403（通道隔离）", r.status == 403, f"HTTP {r.status}")
        r = s.req("GET", "/bo/api/v1/clients?limit=10 (无 token——负向)",
                  http("GET", "/bo/api/v1/clients?limit=10"))
        s.check("无 token 打 bo 面 → 401（鉴权先于隔离）", r.status == 401,
                f"HTTP {r.status}")

    # 步骤 10：identifiers PUT → 回读 → 恢复（旅程 Step 7 的网关侧闭环前提）
    with runner.step(10, "identifiers PUT→回读→恢复（过期证照修复链路）") as s:
        r = s.req("GET", f"/bo/api/v1/clients/{alice_cid}/identifiers",
                  http("GET", f"/bo/api/v1/clients/{alice_cid}/identifiers",
                       token=tokens["admin"]))
        s.check("列出 alice 证照 200", r.status == 200, f"HTTP {r.status}")
        idents = r.data if isinstance(r.data, list) else []
        s.check("alice 至少 1 条证照（种子）", len(idents) >= 1, f"{len(idents)} 条")
        # 优先选过期证照（旅程口径）；无过期则取首条
        target = None
        for it in idents:
            exp = norm_date(it.get("expiryDate"))
            if exp and exp < "2099-01-01":
                target = it
                break
        target = target or (idents[0] if idents else None)
        s.check("锁定目标证照", target is not None,
                f"identifierId={target and target.get('id')}")
        ident_id = target["id"]
        original = norm_date(target.get("expiryDate"))
        s.check("原始 expiryDate 可读", bool(original), str(original))

        put = {"expiryDate": "2099-12-31", "locale": "en", "dateFormat": "yyyy-MM-dd"}
        r = s.req("PUT", f"/bo/api/v1/clients/{alice_cid}/identifiers/{ident_id}",
                  http("PUT", f"/bo/api/v1/clients/{alice_cid}/identifiers/{ident_id}",
                       token=tokens["admin"], body=put))
        s.check("PUT 2099-12-31 → 200", r.status == 200, f"HTTP {r.status}")

        r = s.req("GET", f"/bo/api/v1/clients/{alice_cid}/identifiers (回读)",
                  http("GET", f"/bo/api/v1/clients/{alice_cid}/identifiers",
                       token=tokens["admin"]))
        after = None
        for it in (r.data or []):
            if it.get("id") == ident_id:
                after = norm_date(it.get("expiryDate"))
        s.check("回读 expiryDate=2099-12-31", after == "2099-12-31", str(after))

        put = {"expiryDate": original, "locale": "en", "dateFormat": "yyyy-MM-dd"}
        r = s.req("PUT", f"/bo/api/v1/clients/{alice_cid}/identifiers/{ident_id} (恢复)",
                  http("PUT", f"/bo/api/v1/clients/{alice_cid}/identifiers/{ident_id}",
                       token=tokens["admin"], body=put))
        s.check("恢复 PUT → 200", r.status == 200, f"HTTP {r.status}")

        r = s.req("GET", f"/bo/api/v1/clients/{alice_cid}/identifiers (恢复回读)",
                  http("GET", f"/bo/api/v1/clients/{alice_cid}/identifiers",
                       token=tokens["admin"]))
        restored = None
        for it in (r.data or []):
            if it.get("id") == ident_id:
                restored = norm_date(it.get("expiryDate"))
        s.check(f"恢复回读 expiryDate={original}", restored == original, str(restored))

        # 双通道交叉验证（P2.5 口径）：对客 identity 仍为 EXPIRED
        r = s.req("GET", "/abnk/api/v1/me/identity (交叉验证)",
                  http("GET", "/abnk/api/v1/me/identity", token=tokens["alice"]))
        s.check("恢复后对客 identity 仍 EXPIRED（种子态复原）",
                r.status == 200 and (r.data or {}).get("status") == "EXPIRED",
                f"HTTP {r.status} status={(r.data or {}).get('status')}")

    # 步骤 11：黑名单三断言（jobs/internal → 403；契约外路径 → 404）
    with runner.step(11, "对客通道黑名单与收敛负向") as s:
        r = s.req("GET", "/abnk/api/v1/jobs (黑名单)",
                  http("GET", "/abnk/api/v1/jobs", token=tokens["alice"]))
        s.check("jobs → 403（黑名单）", r.status == 403, f"HTTP {r.status}")
        r = s.req("GET", "/abnk/api/v1/internal/cache/evict (黑名单)",
                  http("GET", "/abnk/api/v1/internal/cache/evict", token=tokens["alice"]))
        s.check("internal/cache/evict → 403（黑名单）", r.status == 403,
                f"HTTP {r.status}")
        r = s.req("GET", "/abnk/api/v1/loans/999/command (契约外)",
                  http("GET", "/abnk/api/v1/loans/999/command", token=tokens["alice"]))
        s.check("loans/999/command → 404（非契约路径）", r.status == 404,
                f"HTTP {r.status}")


def s_prev_response(runner, step_no):
    """取先前步骤暂存的响应（幂等比对用）。"""
    for st in runner.steps:
        if st["step"] == step_no:
            return st.get("firstResponse", {})
    return {}


# ---------------------------------------------------------------- 主入口

def main():
    if not CRED_FILE or not os.path.isfile(CRED_FILE):
        print("ERROR: 环境变量 ABNK_DEMO_CREDENTIALS 未设置或文件不存在\n"
              "（应指向 .github-private/kbank-poc/gateway-demo-passwords.json）")
        return 2
    with open(CRED_FILE, encoding="utf-8") as f:
        cred = json.load(f)
    if CRED_INSTANCE not in cred.get("instances", {}):
        print(f"ERROR: 凭据文件无实例 '{CRED_INSTANCE}'"
              f"（可用: {sorted(cred.get('instances', {}).keys())}）")
        return 2
    users = cred["instances"][CRED_INSTANCE]["users"]

    runner = Runner()
    ok, error = True, None
    try:
        scenario(runner, users)
    except Exception as e:  # fail-fast：任一步骤断言失败即停
        ok, error = False, f"{type(e).__name__}: {e}"

    total_asserts = sum(len(st.get("asserts", [])) for st in runner.steps)
    passed_asserts = sum(1 for st in runner.steps for a in st.get("asserts", [])
                         if a.get("pass"))
    summary = {
        "designedSteps": DESIGNED_STEPS,
        "executedSteps": len(runner.steps),
        "assertsPassed": passed_asserts,
        "assertsTotal": total_asserts,
        "credentialsInstance": CRED_INSTANCE,
        "gatewayBase": GW_BASE,
        "fineractHealth": FINERACT_HEALTH,
        "error": error,
    }
    runner.save(ok, summary)

    print(f"\n===== 结果: {'PASS' if ok else 'FAIL'}"
          f" | 步骤 {len(runner.steps)}/{DESIGNED_STEPS}"
          f" | 断言 {passed_asserts}/{total_asserts} =====")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
