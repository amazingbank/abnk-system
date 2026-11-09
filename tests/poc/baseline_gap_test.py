#!/usr/bin/env python3
"""ABNK 基线缺口验证资产（Phase P3.3 任务资产——Part02 旅程 §1.3 的自动化版）。

POC 开场要演示「证件过期客户转账依然成功」——缺口存在的自动化证据。基线系统
（网关 + Fineract 生产形态栈）不含任何证照拦截逻辑（那是 POC 演示中现场构建的
增量），本剧本把「当前状态」固化为可重跑测试，四段剧本：

  ① alice 登录 → GET /me/identity 断言 status=EXPIRED（过期证照种子）
  ② bob   登录 → 断言 status=VALID（有效证照对照）
  ③ alice 发起转账 10 → 断言 HTTP 200 成功（缺口存在——基线无拦截）
  ④ Fineract 侧独立核对双账户余额变化（-10 / +10）与交易计数 +1

约定（Phase P3 详细计划 P3.3 口径）：
- 纯 Python 标准库，零第三方依赖；结构复用 tests/gateway/gateway_test.py 的
  Runner/StepCtx 范式（fail-fast + 报告脱敏）
- 演示口令经环境变量 ABNK_DEMO_CREDENTIALS 注入（指向 P0.3 归档处
  .github-private/kbank-poc/gateway-demo-passwords.json），不入剧本代码与报告 JSON
- 幂等后缀 TS 模式：转账 externalId 携带毫秒时间戳——同一栈可重复执行（每轮新
  externalId 隔离，各落一笔新交易，不触发网关幂等重放）
- 转账金额小额 10；脚本末尾不做余额回滚（单向，声明）——运行口径见 P3.3 改动详情
- Fineract 侧核对为独立通道（不经网关）：直连生产形态栈 REST（Basic + 租户头）
- 报告 JSON 归档 artifacts/phaseP3/gap-report-<ts>.json（token 字段一律脱敏）
- 退出码：0 = 全部通过（缺口证据成立）；1 = 任一断言失败（fail-fast）；2 = 前置缺失

用法：
    cd $ABNK_REPO/tests/poc
    ABNK_DEMO_CREDENTIALS=<path>/gateway-demo-passwords.json python3 baseline_gap_test.py

环境变量：
    ABNK_GATEWAY_BASE         网关基址（默认 http://localhost:8080）
    ABNK_FINERACT_BASE        Fineract API 基址（默认 http://localhost:8081/fineract-provider/api/v1）
    ABNK_FINERACT_AUTH        Fineract 平台 Basic 凭据头（默认本地生产形态栈口径）
    ABNK_FINERACT_TENANT      租户标识（默认 default）
    ABNK_DEMO_CREDENTIALS     演示口令档案路径（必填）
    ABNK_CREDENTIALS_INSTANCE 凭据实例节（默认 local-prodform）
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
REPORT_DIR = os.path.join(REPO_ROOT, "artifacts", "phaseP3")

GW_BASE = os.environ.get("ABNK_GATEWAY_BASE", "http://localhost:8080").rstrip("/")
FIN_BASE = os.environ.get(
    "ABNK_FINERACT_BASE",
    "http://localhost:8081/fineract-provider/api/v1").rstrip("/")
FIN_AUTH = os.environ.get("ABNK_FINERACT_AUTH", "Basic bWlmb3M6cGFzc3dvcmQ=")
FIN_TENANT = os.environ.get("ABNK_FINERACT_TENANT", "default")
FIN_HEALTH = os.environ.get(
    "ABNK_FINERACT_HEALTH",
    "http://localhost:8081/fineract-provider/actuator/health")
CRED_FILE = os.environ.get("ABNK_DEMO_CREDENTIALS", "")
CRED_INSTANCE = os.environ.get("ABNK_CREDENTIALS_INSTANCE", "local-prodform")

# 剧本设计步骤数（四段①②③④——VP3.3.1 判据：报告 steps 计数必须与此相等）
DESIGNED_STEPS = 4
# 转账金额（P3.3 改动详情：小额 10）
AMOUNT = 10

SSL_CTX = None
if GW_BASE.startswith("https") or FIN_BASE.startswith("https"):
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


def _request(method, url, headers, body=None, timeout=60):
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(url, data=data, method=method)
    req.add_header("Accept", "application/json")
    for k, v in headers.items():
        req.add_header(k, v)
    if body is not None:
        req.add_header("Content-Type", "application/json")
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


def gw(method, path, token=None, body=None):
    """对客通道：网关请求（Bearer），path 为相对路径。"""
    headers = {}
    if token:
        headers["Authorization"] = f"Bearer {token}"
    url = path if path.startswith("http") else GW_BASE + path
    return _request(method, url, headers, body)


def fin(method, path, body=None):
    """Fineract 独立核对通道（不经网关）：Basic + 租户头。"""
    headers = {"Authorization": FIN_AUTH, "Fineract-Platform-TenantId": FIN_TENANT}
    url = path if path.startswith("http") else FIN_BASE + "/" + path.lstrip("/")
    return _request(method, url, headers, body)


def login(username, password, path="/login"):
    return gw("POST", path, body={"username": username, "password": password})


# ---------------------------------------------------------------- 步骤记录器

class Runner:
    def __init__(self):
        self.steps = []

    def step(self, no, name):
        print(f"\n===== 段 {no} | {name} =====")
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
        path = os.path.join(REPORT_DIR, f"gap-report-{ts}.json")
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
            raise AssertionError(f"段 {self.no} 断言失败: {label} (证据: {evidence})")
        return True

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc, tb):
        self.runner.steps.append(
            {"step": self.no, "name": self.name, **self.detail,
             **({"error": str(exc)} if exc is not None else {})})
        if exc is None:
            print(f"  ---- 段 {self.no} 完成")
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


# ---------------------------------------------------------------- Fineract 核对辅助

def savings_balance(acc):
    """Fineract 直连取账户余额（summary.accountBalance）。"""
    r = fin("GET", f"savingsaccounts/{acc}")
    if r.status != 200 or not isinstance(r.data, dict):
        return None, r
    summary = r.data.get("summary") or {}
    return summary.get("accountBalance"), r


def savings_txn_total(acc):
    """Fineract 直连取交易计数（GET transactions/search → total，P0.2 VP0.2.4 实测口径）。"""
    r = fin("GET", f"savingsaccounts/{acc}/transactions/search")
    if r.status != 200 or not isinstance(r.data, dict):
        return None, r
    return r.data.get("total"), r


def num_eq(a, b, tol=0.005):
    return (isinstance(a, (int, float)) and isinstance(b, (int, float))
            and abs(a - b) < tol)


# ---------------------------------------------------------------- 剧本（四段）

def scenario(runner, users):
    alice = users["alice"]
    bob = users["bob"]
    a_src = alice["accounts"]["source"]
    a_dst = alice["accounts"]["target"]

    # 幂等后缀（TS 模式，毫秒级——重跑各轮新 externalId 隔离）
    ts = str(int(time.time() * 1000))
    ext_id = f"GAP-{ts}"

    # 段④核对数据（before 值须在转账前取——在段③末尾采集）
    balance_before = {}
    txn_before = {}

    # ① 过期客户登录与证照态（旅程 §1.3 前提）
    with runner.step(1, "① alice 登录 → /me/identity 断言 EXPIRED（过期证照种子）") as s:
        r = s.req("POST", "/login (alice)", login("alice", alice["password"]))
        s.check("alice 登录 200", r.status == 200, f"HTTP {r.status}")
        d = r.data or {}
        s.check("alice token 三段式（JWT）",
                isinstance(d.get("token"), str) and d["token"].count(".") == 2)
        s.check("alice clientId=种子值", d.get("clientId") == alice["clientId"],
                f"{d.get('clientId')} (期望 {alice['clientId']})")
        token_alice = d.get("token")

        r = s.req("GET", "/abnk/api/v1/me/identity (alice)",
                  gw("GET", "/abnk/api/v1/me/identity", token=token_alice))
        s.check("alice identity 200", r.status == 200, f"HTTP {r.status}")
        d = r.data or {}
        s.check("alice status=EXPIRED（过期种子——旅程 §1.3 前提成立）",
                d.get("status") == "EXPIRED", str(d.get("status")))
        s.check("alice expiryDate 非空", bool(d.get("expiryDate")),
                str(d.get("expiryDate")))
        s.check("documentKey 脱敏（含 *）",
                isinstance(d.get("documentKey"), str) and "*" in d["documentKey"],
                str(d.get("documentKey")))

    # ② 有效客户对照
    with runner.step(2, "② bob 登录 → /me/identity 断言 VALID（对照）") as s:
        r = s.req("POST", "/login (bob)", login("bob", bob["password"]))
        s.check("bob 登录 200", r.status == 200, f"HTTP {r.status}")
        d = r.data or {}
        s.check("bob clientId=种子值", d.get("clientId") == bob["clientId"],
                f"{d.get('clientId')} (期望 {bob['clientId']})")
        token_bob = d.get("token")

        r = s.req("GET", "/abnk/api/v1/me/identity (bob)",
                  gw("GET", "/abnk/api/v1/me/identity", token=token_bob))
        s.check("bob identity 200", r.status == 200, f"HTTP {r.status}")
        d = r.data or {}
        s.check("bob status=VALID（有效种子对照）", d.get("status") == "VALID",
                str(d.get("status")))

    # ③ 缺口主体：EXPIRED 客户转账成功
    with runner.step(3, "③ alice（EXPIRED）转账 10 → HTTP 200 成功（缺口存在——基线无拦截）") as s:
        # Fineract 基线采集（段④独立核对的 before 值）
        for acc in (a_src, a_dst):
            bal, rb = savings_balance(acc)
            s.check(f"Fineract 基线余额可读（账户 {acc}）",
                    isinstance(bal, (int, float)),
                    f"HTTP {rb.status} balance={bal}")
            s.req("GET", f"(fineract) savingsaccounts/{acc} (before)", rb)
            total, rt = savings_txn_total(acc)
            s.req("GET", f"(fineract) savingsaccounts/{acc}/transactions/search (before)", rt)
            s.check(f"Fineract 基线计数可读（账户 {acc}）",
                    isinstance(total, int), f"HTTP {rt.status} total={total}")
            balance_before[acc] = bal
            txn_before[acc] = total

        body = {"toAccountId": a_dst, "amount": AMOUNT, "externalId": ext_id,
                "note": f"P3.3 缺口剧本（基线无拦截）"}
        r = s.req("POST", f"/abnk/api/v1/accounts/{a_src}/transfer",
                  gw("POST", f"/abnk/api/v1/accounts/{a_src}/transfer",
                     token=token_alice, body=body))
        s.check("EXPIRED 客户转账 HTTP 200 成功 —— 缺口存在（这正是 POC 要消灭的缺口）",
                r.status == 200, f"HTTP {r.status} {r.raw[:120]}")
        d = r.data or {}
        s.check("transactionId 存在", isinstance(d.get("transactionId"), int),
                str(d.get("transactionId")))
        s.check("newSourceBalance = 基线 − 金额（网关聚合落账一致）",
                num_eq(d.get("newSourceBalance"), balance_before[a_src] - AMOUNT),
                f"{d.get('newSourceBalance')} (期望 {balance_before[a_src] - AMOUNT})")
        s.detail["externalId"] = ext_id

    # ④ Fineract 侧独立核对（双账户余额变化 + 计数 +1）
    with runner.step(4, "④ Fineract 侧独立核对：双账户余额变化 −10/+10 + 交易计数 +1") as s:
        result = {}
        for acc, expect_delta in ((a_src, -AMOUNT), (a_dst, AMOUNT)):
            bal, rb = savings_balance(acc)
            s.req("GET", f"(fineract) savingsaccounts/{acc} (after)", rb)
            total, rt = savings_txn_total(acc)
            s.req("GET", f"(fineract) savingsaccounts/{acc}/transactions/search (after)", rt)
            result[acc] = {"before": balance_before[acc], "after": bal,
                           "delta": (round(bal - balance_before[acc], 2)
                                     if isinstance(bal, (int, float)) else None),
                           "txnBefore": txn_before[acc], "txnAfter": total}
            s.check(f"账户 {acc} 余额变化 = {expect_delta:+d}",
                    num_eq(bal, balance_before[acc] + expect_delta),
                    f"{balance_before[acc]} → {bal} (delta={result[acc]['delta']})")
            s.check(f"账户 {acc} 交易计数 +1",
                    isinstance(total, int) and total == txn_before[acc] + 1,
                    f"{txn_before[acc]} → {total}")
        s.detail["fineractVerify"] = result
        # 落账一致性：两侧余额变化绝对值相等（−10 与 +10 对称——无凭空生灭资金）
        src_d = result[a_src]["delta"]
        dst_d = result[a_dst]["delta"]
        s.check("双账户余额变化对称（|−10| = |+10|）",
                num_eq(src_d, -dst_d) if src_d is not None and dst_d is not None else False,
                f"src delta={src_d}, dst delta={dst_d}")


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

    # 前置健康检查（不入四段——缺栈直接前置失败退出 2）
    print("===== 前置：网关与 Fineract 生产形态栈健康 =====")
    r = gw("GET", "/actuator/health")
    print(f"  GET {GW_BASE}/actuator/health → {r.status}")
    if not (r.status == 200 and (r.data or {}).get("status") == "UP"):
        print("ERROR: 网关不可用——先启动 abnk-gateway（bootRun :8080）")
        return 2
    r = _request("GET", FIN_HEALTH, {})
    print(f"  GET (fineract) /actuator/health → {r.status}")
    if not (r.status == 200 and (r.data or {}).get("status") == "UP"):
        print("ERROR: Fineract 生产形态栈不可用——先启动 abnk-fineract（:8081）")
        return 2

    runner = Runner()
    ok, error = True, None
    try:
        scenario(runner, users)
    except Exception as e:  # fail-fast：任一段断言失败即停
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
        "fineractBase": FIN_BASE,
        "amount": AMOUNT,
        "gapEvidence": {
            "expiredCustomer": "alice",
            "identityStatus": "EXPIRED",
            "transferHttpStatus": 200,
            "gapPresent": ok,  # True = 过期客户转账成功 → 基线缺口存在
            "note": "POC 要消灭的缺口：证件过期客户转账依然成功（基线无拦截）",
        },
        "rollback": "单向剧本，不做余额回滚（P3.3 改动详情声明）",
        "error": error,
    }
    runner.save(ok, summary)

    print(f"\n===== 结果: {'PASS（缺口证据成立）' if ok else 'FAIL'}"
          f" | 段 {len(runner.steps)}/{DESIGNED_STEPS}"
          f" | 断言 {passed_asserts}/{total_asserts} =====")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
