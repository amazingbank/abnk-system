"""Fineract API 客户端封装（纯 Python 标准库，零依赖）。

用法：
    from fineract_api import Client, StepRunner
    cli = Client()                       # 全部参数可用环境变量覆盖
    r = cli.post("/clients", {...}, expect=200)

设计约定：
- 自签证书：跳过校验（本地调试环境）
- 认证：Basic + 租户头，缺一不可（租户头缺失 4xx 是 Fineract 硬约束）
- 断言失败抛 AssertionError，冒烟脚本 fail-fast
"""

import base64
import json
import os
import ssl
import time
import urllib.error
import urllib.request
from datetime import datetime


class Response:
    def __init__(self, status, data, raw, elapsed):
        self.status = status
        self.data = data      # 解析后的 JSON（非 JSON 为 None）
        self.raw = raw
        self.elapsed = elapsed

    def __repr__(self):
        body = self.raw[:120] if self.raw else ""
        return f"<Response {self.status} {self.elapsed:.2f}s {body}>"


class Client:
    def __init__(self, base_url=None, tenant=None, user=None, password=None, timeout=120):
        self.base = (base_url or os.environ.get(
            "ABNK_BASE_URL", "https://localhost:8443/fineract-provider/api/v1")).rstrip("/")
        self.tenant = tenant or os.environ.get("ABNK_TENANT", "default")
        user = user or os.environ.get("ABNK_USER", "mifos")
        password = password or os.environ.get("ABNK_PASSWORD", "password")
        self.timeout = timeout

        self.ctx = ssl.create_default_context()
        self.ctx.check_hostname = False
        self.ctx.verify_mode = ssl.CERT_NONE

        token = base64.b64encode(f"{user}:{password}".encode()).decode()
        self.headers = {
            "Fineract-Platform-TenantId": self.tenant,
            "Authorization": f"Basic {token}",
            "Content-Type": "application/json",
            "Accept": "application/json",
        }

    def request(self, method, path, body=None, query=""):
        url = self.base + path + (f"?{query}" if query else "")
        data = json.dumps(body).encode() if body is not None else None
        req = urllib.request.Request(url, data=data, method=method)
        for k, v in self.headers.items():
            req.add_header(k, v)
        t0 = time.time()
        try:
            with urllib.request.urlopen(req, timeout=self.timeout, context=self.ctx) as resp:
                status, raw = resp.status, resp.read().decode("utf-8", "replace")
        except urllib.error.HTTPError as e:
            status, raw = e.code, e.read().decode("utf-8", "replace")
        elapsed = time.time() - t0
        try:
            parsed = json.loads(raw) if raw else None
        except json.JSONDecodeError:
            parsed = None
        return Response(status, parsed, raw, elapsed)

    def get(self, path, query="", expect=200):
        return self.request("GET", path, None, query)

    def post(self, path, body=None, query="", expect=(200,)):
        r = self.request("POST", path, body, query)
        if r.status not in (expect if isinstance(expect, tuple) else (expect,)):
            raise AssertionError(
                f"POST {path} → HTTP {r.status}（期望 {expect}）\n{r.raw[:500]}")
        return r

    def put(self, path, body=None, query="", expect=200):
        r = self.request("PUT", path, body, query)
        if r.status != expect:
            raise AssertionError(f"PUT {path} → HTTP {r.status}\n{r.raw[:500]}")
        return r


class StepRunner:
    """12 步冒烟的步骤记录器：请求/断言/耗时 → JSON 报告。"""

    def __init__(self, report_path):
        self.report_path = report_path
        self.steps = []
        self.snapshots = {}

    def step(self, no, name):
        print(f"\n===== 步骤 {no:>2} | {name} =====")
        return _StepCtx(self, no, name)

    def record(self, no, name, detail):
        self.steps.append({"step": no, "name": name, **detail})

    def snapshot(self, key, obj):
        self.snapshots[key] = obj

    def save(self, ok, summary):
        doc = {
            "runAt": datetime.now().isoformat(timespec="seconds"),
            "ok": ok,
            "summary": summary,
            "steps": self.steps,
            "snapshots": self.snapshots,
        }
        with open(self.report_path, "w", encoding="utf-8") as f:
            json.dump(doc, f, ensure_ascii=False, indent=2)
        print(f"\n报告已写入: {self.report_path}")


class _StepCtx:
    def __init__(self, runner, no, name):
        self.runner, self.no, self.name = runner, no, name
        self.detail = {}

    def req(self, method, path, resp):
        print(f"  {method} {path} → {resp.status} ({resp.elapsed:.2f}s)")
        self.detail["request"] = f"{method} {path}"
        self.detail["status"] = resp.status
        if resp.data is not None and isinstance(resp.data, (dict, list)):
            self.detail["response"] = _trim(resp.data)
        return resp

    def check(self, label, condition, evidence=None):
        mark = "✅" if condition else "❌"
        print(f"  {mark} {label}" + (f" | {evidence}" if evidence is not None else ""))
        self.detail.setdefault("asserts", []).append(
            {"label": label, "pass": bool(condition), "evidence": evidence})
        if not condition:
            raise AssertionError(f"步骤 {self.no} 断言失败: {label} (证据: {evidence})")

    def done(self):
        if getattr(self, "_done", False):
            return
        self._done = True
        self.runner.record(self.no, self.name, self.detail)
        print(f"  ---- 步骤 {self.no} 完成")

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc, tb):
        if exc is None:
            self.done()
        else:
            self.detail["error"] = str(exc)
            self.runner.record(self.no, self.name, self.detail)
            self.runner.save(False, {"failedAtStep": self.no, "error": str(exc)})
        return False


def _trim(obj, limit=60):
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
