#!/usr/bin/env python3
"""KBank POC 完整种子数据（Phase P0 任务 P0.3，对生产形态栈施加）。

在 seed_demo.py 模式上扩展为完整 POC 种子：
- Delinquency 分档前置：range（ABNK_POC_OD，minAge=1，无上界）+ bucket（REGULAR）
  ——贷款产品挂 delinquencyBucketId 后，Loan Delinquency Classification 作业才打标
  （DelinquencyWritePlatformServiceImpl.applyDelinquencyTagToLoan 实测：loan.hasDelinquencyBucket()
  为假即跳过——只建 range 不挂 bucket 分档断言会悬空）
- 贷款产品（等额本息，挂 bucket）+ 定期产品（含利率 chart，depositAmount 必填）
- 客户 A（过期证照 + 源/目标账户，源余额 10000）→ 旅程拦截主线
- 客户 B（有效证照 + 账户 5000 + 定期账户 10000）→ 对照组 / 旅程 Step 5
- 客户 C（逾期贷款：发放后不还款 → 业务日期推进至首期 due + 40 天 → 触发
  「Loan Delinquency Classification」作业 → 回读分档 ABNK_POC_OD）
  ——业务日期推进为单向环境改变，不回拨，所属库 fineract_default（生产形态栈内）
- 网关用户表 gateway_users.json（alice/bob/admin，PBKDF2-HMAC-SHA256）——D2 简化登录

P0.2 实测坑位口径（capability-probe.json 归档，载荷必须遵守）：
  ① 证照描述字段用 description（documentDescription 未列入 SUPPORTED_PARAMETERS，用之即 400）
  ② 证照创建必须带 status（值 INACTIVE/ACTIVE，漏字段即 500——上游缺陷）
  ③ 定期产品 depositAmount 必填
  ④ 同轮多客户 mobileNo 必须唯一（撞 duplicate.mobileNo 403）

跨端互验契约（P2.2 网关侧 Java 同算法校验，在此定死）：
  iterations=100000 定值、salt=16 字节随机（hex 入 JSON）、
  password_hash=PBKDF2-HMAC-SHA256(口令 UTF-8, salt 字节, 100000, dklen=32) 输出 hex、无 pepper。
  明文口令不入库不入 artifacts，仅打印一次性演示口令（执行者存 .github-private/）。

运行：cd abnk-system/data && \
  ABNK_BASE_URL=http://localhost:8081/fineract-provider/api/v1 python3 seed_poc.py
输出：gateway_users.json（本目录）+ ../artifacts/phaseP0/seed-poc-evidence.json
幂等：实体名/externalId/documentKey/mobileNo 带时间戳后缀；失败即停。

种子语言（2026-11-13 发版拍板）：ABNK_SEED_LANG 选文案语言，缺省 en-us
（线上业务数据英文单语口径——「业务数据不需要双语」）；zh-cn 显式回退保留
（文案见 SEED_COPY 文案表——业务数据本体语言，D3 边界：后端存什么显示什么）。
Seed language (release decision, 2026-11-13): ABNK_SEED_LANG picks the copy
language, defaulting to en-us (line-of-business data in English, single
language — "no bilingual business data needed"); zh-cn remains available as
an explicit fallback (copy table below — the data's own language per the D3
boundary: the backend stores, the frontend displays).
"""

import hashlib
import json
import os
import secrets
import sys
import time
from datetime import date, datetime, timedelta

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "scripts", "lib"))
from fineract_api import Client  # noqa: E402

TS = datetime.now().strftime("%m%d%H%M%S")          # 幂等后缀（与冒烟/探查同模式）
D_FMT = {"locale": "en", "dateFormat": "yyyy-MM-dd"}
EXPIRED = "2020-01-01"                               # 证照过期日（明确早于任何业务日期）
VALID = "2099-12-31"                                 # 证照有效日
OD_CLASSIFICATION = "ABNK_POC_OD"                    # POC 逾期分档标识
PBKDF2_ITERATIONS = 100000
DATA_DIR = os.path.dirname(os.path.abspath(__file__))
ART_DIR = os.path.join(DATA_DIR, "..", "artifacts", "phaseP0")

# 种子语言（发版拍板缺省 en-us；文案语言只影响姓名/产品名/证照描述/note——
# externalId/documentKey/mobileNo 与时间戳幂等后缀恒为 ASCII，不随语言变）。
# Seed locale (defaults to en-us per the release call; the copy language only
# affects names/product names/identifier descriptions/notes — externalIds,
# documentKeys and mobileNo stay ASCII with the timestamp idempotency suffix).
SEED_LANG = os.environ.get("ABNK_SEED_LANG", "en-us")

# 文案表（zh-cn 为 2026-11-07 首次施加原文；en-us 为语义重写，D2 口径——
# 姓名用拼音罗马化，产品名按英文银行业惯用表述，非逐字直译）。
# Copy table (zh-cn preserves the first-seed copy from 2026-11-07; en-us is a
# semantic rewrite per D2 — names romanized in pinyin, product names in
# English banking idiom, never word-for-word).
SEED_COPY = {
    "zh-cn": {
        "surname_a": "王", "surname_b": "李", "surname_c": "赵",
        "product_savings": f"ABNK-POC活期{TS}",
        "product_loan": f"ABNK-POC消费贷{TS}",
        "product_fd": f"ABNK-POC定期{TS}",
        "id_desc_expired": "身份证(已过期)",
        "id_desc_valid": "身份证(有效)",
        "note_source_deposit": "POC 源账户初始余额",
        "note_control_deposit": "POC 对照客户余额",
    },
    "en-us": {
        "surname_a": "Wang", "surname_b": "Li", "surname_c": "Zhao",
        "product_savings": f"ABNK-POC Current Savings {TS}",
        "product_loan": f"ABNK-POC Consumer Loan {TS}",
        "product_fd": f"ABNK-POC Fixed Deposit {TS}",
        "id_desc_expired": "National ID (expired)",
        "id_desc_valid": "National ID (valid)",
        "note_source_deposit": "POC source account initial deposit",
        "note_control_deposit": "POC control client deposit",
    },
}

if SEED_LANG not in SEED_COPY:
    sys.exit(f"❌ 未知 ABNK_SEED_LANG: {SEED_LANG}（可选 zh-cn / en-us）")
CP = SEED_COPY[SEED_LANG]

# 施加断言与回读记录（→ seed-poc-evidence.json，无空字段；不含任何明文口令）
EV = {"asserts": [], "readback": {}}


def check(label, cond, evidence):
    mark = "✅" if cond else "❌"
    print(f"  {mark} {label} | {evidence}")
    EV["asserts"].append({"label": label, "pass": bool(cond), "evidence": str(evidence)})
    if not cond:
        raise AssertionError(f"断言失败: {label} (证据: {evidence})")


def jget(data, *path, default=None):
    cur = data
    for p in path:
        if isinstance(cur, dict) and p in cur:
            cur = cur[p]
        else:
            return default
    return cur


def dstr(v):
    """Fineract 日期字段 [2026,12,8] → '2026-12-08'；其他原样。"""
    if isinstance(v, list) and len(v) == 3 and all(isinstance(x, int) for x in v):
        return f"{v[0]:04d}-{v[1]:02d}-{v[2]:02d}"
    return v


def business_today(cli):
    """读业务日期为「今天」；未设置则置为真实今天（单向，不回拨）。"""
    bd = cli.get("/businessdate").data
    hit = next((x for x in (bd or []) if x.get("type") == "BUSINESS_DATE"), None)
    if hit:
        d = hit["date"]
        return f"{d[0]}-{d[1]:02d}-{d[2]:02d}"
    today = date.today().isoformat()
    cli.post("/businessdate", {"type": "BUSINESS_DATE", "date": today, **D_FMT})
    return today


# ── 施加步骤 ──────────────────────────────────────────────────

_SEQ = [0]


def create_client(cli, first, last, today, ext):
    _SEQ[0] += 1
    seq = _SEQ[0]
    r = cli.post("/clients", {
        "officeId": 1, "firstname": first, "lastname": last,
        "legalFormId": 1, "active": False, "submittedOnDate": today,
        "externalId": ext, "mobileNo": f"135{TS[-5:]}{seq:03d}", **D_FMT})   # 坑④：mobileNo 唯一
    cid = jget(r.data, "clientId", default=jget(r.data, "resourceId"))
    assert cid, f"建客户失败: {r.raw[:400]}"
    cli.post(f"/clients/{cid}", {"activationDate": today, **D_FMT}, query="command=activate")
    return cid


def add_identifier(cli, cid, doc_type_id, key, expiry, desc):
    """坑① description、坑② status 必填（值 ACTIVE/INACTIVE）。"""
    r = cli.post(f"/clients/{cid}/identifiers", {
        "documentTypeId": doc_type_id, "documentKey": key,
        "description": desc, "status": "ACTIVE",
        "issuanceDate": "2015-01-01", "expiryDate": expiry, **D_FMT})
    assert r.status == 200, f"建证照失败: {r.raw[:400]}"
    return jget(r.data, "resourceId")


def document_type_id(cli, cid):
    tpl = cli.get(f"/clients/{cid}/identifiers/template").data
    types = jget(tpl, "allowedDocumentTypes", default=[]) or []
    if types:
        return types[0]["id"]
    return 1


def create_savings_product(cli):
    """储蓄产品：accountingRule=1（NONE）——P2.4 转账冲正「无科目纠缠」前提的种子侧声明。"""
    r = cli.post("/savingsproducts", {
        "name": CP["product_savings"], "shortName": f"A{TS[-3:]}",
        "description": "POC seed savings (accounting NONE)",
        "currencyCode": "CNY", "digitsAfterDecimal": 2, "inMultiplesOf": 0,
        "nominalAnnualInterestRate": 1.5,
        "interestCompoundingPeriodType": 1, "interestPostingPeriodType": 1,
        "interestCalculationType": 1, "interestCalculationDaysInYearType": 360,
        "accountingRule": 1, "minRequiredOpeningBalance": 0,
        "withdrawalFeeForTransfers": False, "allowOverdraft": False,
        "enforceMinRequiredBalance": False, "lienAllowed": False,
        "withHoldTax": False, "isDormancyTrackingActive": False,
        "locale": "en"})
    pid = jget(r.data, "resourceId")
    assert pid, f"建储蓄产品失败: {r.raw[:400]}"
    return pid


def create_savings_account(cli, cid, product, today, ext):
    r = cli.post("/savingsaccounts", {
        "productId": product, "clientId": cid, "submittedOnDate": today,
        "externalId": ext, **D_FMT})
    sid = jget(r.data, "savingsId", default=jget(r.data, "resourceId"))
    assert sid, f"建储蓄账户失败: {r.raw[:400]}"
    cli.post(f"/savingsaccounts/{sid}", {"approvedOnDate": today, **D_FMT}, query="command=approve")
    cli.post(f"/savingsaccounts/{sid}", {"activatedOnDate": today, **D_FMT}, query="command=activate")
    return sid


def deposit(cli, sid, amount, today, note):
    pt = cli.get("/paymenttypes").data or []
    pay = pt[0]["id"] if pt else 1
    r = cli.post(f"/savingsaccounts/{sid}/transactions", {
        "transactionDate": today, "transactionAmount": amount,
        "paymentTypeId": pay, "note": note, **D_FMT}, query="command=deposit")
    assert r.status == 200, f"存款失败: {r.raw[:400]}"


def create_delinquency_setup(cli):
    """分档三件套前置：range → bucket（REGULAR）。贷款产品挂 bucket 后作业才打标。

    契约（源码核实）：DelinquencyRangeRequest{classification, minimumAgeDays,
    maximumAgeDays 可省, locale}；DelinquencyBucketRequest{name, ranges[], bucketType,
    minimumPaymentPeriodAndRule 仅 WORKING_CAPITAL 必填}。
    幂等：classification 唯一约束——已存在同 classification 的 range/bucket 则复用。
    """
    existing = cli.get("/delinquency/ranges").data or []
    hit = next((x for x in existing if x.get("classification") == OD_CLASSIFICATION), None)
    if hit:
        range_id = hit["id"]
        check("Delinquency range 已存在，复用（classification 唯一约束）", True, f"rangeId={range_id}")
    else:
        r = cli.post("/delinquency/ranges", {
            "classification": OD_CLASSIFICATION, "minimumAgeDays": 1, "locale": "en"})
        range_id = jget(r.data, "resourceId")
        assert range_id, f"建 delinquency range 失败: {r.raw[:400]}"
        check("Delinquency range 施加成功（minAge=1 无上界）", range_id is not None, f"rangeId={range_id}")

    buckets = cli.get("/delinquency/buckets").data or []
    bhit = next((b for b in buckets
                 if range_id in [x.get("id") for x in (b.get("ranges") or [])]), None)
    if bhit:
        bucket_id = bhit["id"]
        check("Delinquency bucket 已存在（挂本 range），复用", True, f"bucketId={bucket_id}")
    else:
        r = cli.post("/delinquency/buckets", {
            "name": f"ABNK-POC-BUCKET-{TS}", "ranges": [range_id],
            "bucketType": "REGULAR", "locale": "en"})
        bucket_id = jget(r.data, "resourceId")
        assert bucket_id, f"建 delinquency bucket 失败: {r.raw[:400]}"
        check("Delinquency bucket 施加成功（REGULAR，挂 1 range）", bucket_id is not None, f"bucketId={bucket_id}")
    return range_id, bucket_id


def create_loan_product(cli, bucket_id):
    """贷款产品：等额本息 + delinquencyBucketId（分档打标前提）。"""
    r = cli.post("/loanproducts", {
        "name": CP["product_loan"], "shortName": f"B{TS[-3:]}",
        "description": "POC seed consumer loan (equal installments, delinquency bucket)",
        "currencyCode": "CNY", "digitsAfterDecimal": 2, "inMultiplesOf": 0,
        "principal": 50000, "minPrincipal": 1000, "maxPrincipal": 200000,
        "numberOfRepayments": 12, "repaymentEvery": 1, "repaymentFrequencyType": 2,
        "interestRatePerPeriod": 10, "interestRateFrequencyType": 3,
        "amortizationType": 1, "interestType": 0, "interestCalculationPeriodType": 1,
        "daysInMonthType": 30, "daysInYearType": 360,
        "transactionProcessingStrategyCode": "mifos-standard-strategy",
        "accountingRule": 1, "includeInBorrowerCycle": False,
        "isInterestRecalculationEnabled": False, "allowVariableInstallments": False,
        "delinquencyBucketId": bucket_id,
        "locale": "en"})
    pid = jget(r.data, "resourceId")
    assert pid, f"建贷款产品失败: {r.raw[:400]}"
    check("贷款产品施加深成功（等额本息 + delinquencyBucketId）",
          pid is not None, f"productId={pid} bucketId={bucket_id}")
    return pid


def create_fixed_deposit_product(cli):
    """定期产品：坑③ depositAmount 必填 + 利率 chart（无 chart 则 maturityAmount 空悬）。"""
    r = cli.post("/fixeddepositproducts", {
        "name": CP["product_fd"], "shortName": f"C{TS[-3:]}",
        "description": "POC seed fixed deposit (12-month tier)",
        "currencyCode": "CNY", "digitsAfterDecimal": 2, "inMultiplesOf": 0,
        "interestCompoundingPeriodType": 4, "interestPostingPeriodType": 4,
        "interestCalculationType": 1, "interestCalculationDaysInYearType": 365,
        "depositAmount": 10000,
        "minDepositTerm": 1, "minDepositTermTypeId": 2,
        "maxDepositTerm": 60, "maxDepositTermTypeId": 2,
        "inMultiplesOfDepositTerm": 1, "inMultiplesOfDepositTermTypeId": 2,
        "preClosurePenalApplicable": False,
        "accountingRule": 1,
        "charts": [{
            "fromDate": "2026-01-01", "locale": "en", "dateFormat": "yyyy-MM-dd",
            "isPrimaryGroupingByAmount": False,
            "chartSlabs": [{
                "description": "POC seed FD tier 1-60m",
                "periodType": 2, "fromPeriod": 1, "toPeriod": 60,
                "annualInterestRate": 3.0, "locale": "en"}]}],
        "locale": "en"})
    pid = jget(r.data, "resourceId")
    assert pid, f"建定期产品失败: {r.raw[:400]}"
    check("定期产品施加深成功（含利率 chart）", pid is not None, f"productId={pid}")
    return pid


def create_fd_account(cli, cid, product, today):
    r = cli.post("/fixeddepositaccounts", {
        "clientId": cid, "productId": product,
        "submittedOnDate": today, "depositAmount": 10000,
        "depositPeriod": 12, "depositPeriodFrequencyId": 2,
        "externalId": f"ABNK-POC-B-FD-{TS}", **D_FMT})
    fid = jget(r.data, "savingsId", default=jget(r.data, "resourceId"))
    assert fid, f"建定期账户失败: {r.raw[:400]}"
    cli.post(f"/fixeddepositaccounts/{fid}", {"approvedOnDate": today, **D_FMT}, query="command=approve")
    cli.post(f"/fixeddepositaccounts/{fid}", {"activatedOnDate": today, **D_FMT}, query="command=activate")
    return fid


def create_overdue_loan(cli, cid, product, today):
    """客户 C 逾期贷款：申请 → 审批 → 发放，不还款（逾期由业务日期推进 + 分档作业制造）。"""
    r = cli.post("/loans", {
        "productId": product, "clientId": cid, "loanType": "individual",
        "principal": 50000, "loanTermFrequency": 12, "loanTermFrequencyType": 2,
        "numberOfRepayments": 12, "repaymentEvery": 1, "repaymentFrequencyType": 2,
        "interestRatePerPeriod": 10, "amortizationType": 1, "interestType": 0,
        "transactionProcessingStrategyCode": "mifos-standard-strategy",
        "interestCalculationPeriodType": 1, "submittedOnDate": today,
        "expectedDisbursementDate": today, "externalId": f"ABNK-POC-C-LN-{TS}", **D_FMT})
    loan_id = jget(r.data, "loanId", default=jget(r.data, "resourceId"))
    assert loan_id, f"贷款申请失败: {r.raw[:400]}"
    cli.post(f"/loans/{loan_id}", {"approvedOnDate": today, "approvedLoanAmount": 50000,
                                   "note": "POC seed approve", **D_FMT}, query="command=approve")
    cli.post(f"/loans/{loan_id}", {"actualDisbursementDate": today,
                                   "note": "POC seed disburse", **D_FMT}, query="command=disburse")
    check("客户 C 贷款施加深成功（发放后零还款）", loan_id is not None, f"loanId={loan_id}")
    return loan_id


def advance_business_date(cli, loan_id, min_overdue_days=31, buffer_days=9):
    """推进业务日期至首期还款日 + (min_overdue_days + buffer) 天（单向，不回拨）。"""
    loan = cli.get(f"/loans/{loan_id}", query="associations=all").data
    periods = jget(loan, "repaymentSchedule", "periods", default=[]) or []
    first_due = None
    for p in periods:
        d = dstr(p.get("dueDate"))
        if d and isinstance(p.get("period"), int) and p.get("period") >= 1:
            first_due = d
            break
    assert first_due, f"还款计划无还款行: {periods[:2]}"
    target = (date.fromisoformat(first_due) + timedelta(days=min_overdue_days + buffer_days)).isoformat()
    cli.post("/businessdate", {"type": "BUSINESS_DATE", "date": target, **D_FMT})
    bd = cli.get("/businessdate").data
    cur = next((x["date"] for x in (bd or []) if x.get("type") == "BUSINESS_DATE"), None)
    cur_s = f"{cur[0]}-{cur[1]:02d}-{cur[2]:02d}" if cur else None
    check(f"业务日期推进到 {target}（首期 due {first_due} + {min_overdue_days + buffer_days} 天，单向不回拨）",
          cur_s == target, f"businessDate={cur_s}")
    EV["readback"]["businessDateAdvanced"] = {"to": target, "firstDueDate": first_due,
                                              "daysAdvancedPastFirstDue": min_overdue_days + buffer_days}
    return target, first_due


def trigger_delinquency_job(cli, loan_id, target, first_due):
    """触发日终双作业（异步），等一拍后回读分档。

    ① Update Loan Arrears Ageing——更新 arrears 派生数据（inArrears/overdueSinceDate/
    totalOverdue，实测：不触发则分档标签已打但 arrears 字段悬空）
    ② Loan Delinquency Classification——按逾期天数打 delinquency range 标签
    （实测作业链 DelinquencyWritePlatformServiceImpl：贷款产品挂 bucket 是打标前提）
    """
    jobs = {j["displayName"]: j["jobId"] for j in (cli.get("/jobs").data or [])}
    for job_name in ("Update Loan Arrears Ageing", "Loan Delinquency Classification"):
        jid = jobs.get(job_name)
        assert jid, f"未在 /jobs 找到 {job_name}: {list(jobs)[:10]}"
        r = cli.request("POST", f"/jobs/{jid}", {"tenantIdentifier": cli.tenant},
                        query="command=executeJob")
        check(f"executeJob {job_name} 触发（jobId={jid}）",
              r.status in (200, 202), f"HTTP {r.status} {r.raw[:120]}")
    time.sleep(25)  # 作业异步执行，等一拍再回读

    loan = cli.get(f"/loans/{loan_id}", query="associations=all").data
    in_arrears = jget(loan, "inArrears")
    dr = jget(loan, "delinquencyRange", default={}) or {}
    classification = dr.get("classification")
    overdue_since = dstr(jget(loan, "summary", "overdueSinceDate"))
    total_overdue = jget(loan, "summary", "totalOverdue")
    overdue_days = (date.fromisoformat(target) - date.fromisoformat(first_due)).days
    EV["readback"]["clientCLoan"] = {
        "loanId": loan_id,
        "inArrears": in_arrears,
        "delinquencyRange": dr,
        "overdueSinceDate": overdue_since,
        "totalOverdue": total_overdue,
        "overdueDaysCalculated": overdue_days,
        "businessDate": target,
        "firstDueDate": first_due,
    }
    check(f"客户 C 贷款逾期天数 ≥{overdue_days}（业务日期 {target} − 首期 due {first_due}）",
          overdue_days >= 31, f"days={overdue_days}")
    check("客户 C 贷款 inArrears = true", in_arrears is True, in_arrears)
    check(f"delinquency 分档字段命中种子 range（classification={OD_CLASSIFICATION} 非空）",
          classification == OD_CLASSIFICATION, f"classification={classification}")
    check("overdueSinceDate 字段存在", overdue_since is not None, overdue_since)


# ── 网关用户表（D2 简化登录） ─────────────────────────────────

def gen_gateway_users(client_map):
    """生成 gateway_users.json（PBKDF2-HMAC-SHA256，跨端互验契约见模块 docstring）。

    明文口令不入返回结构（也不入任何 artifacts）——仅打印一次，由执行者存 .github-private/。
    """
    users, plaintexts = [], {}
    for username in ("alice", "bob", "admin"):
        pw = secrets.token_urlsafe(12)
        salt = secrets.token_bytes(16)
        h = hashlib.pbkdf2_hmac("sha256", pw.encode("utf-8"), salt,
                                PBKDF2_ITERATIONS, dklen=32)
        entry = {
            "username": username,
            "clientId": client_map.get(username),
            "algorithm": "PBKDF2-HMAC-SHA256",
            "iterations": PBKDF2_ITERATIONS,
            "salt": salt.hex(),
            "password_hash": h.hex(),
        }
        if entry["clientId"] is None:
            entry.pop("clientId")  # admin 无 clientId——显式不存在而非空值
        users.append(entry)
        plaintexts[username] = pw

    out = {
        "algorithm": "PBKDF2-HMAC-SHA256",
        "iterations": PBKDF2_ITERATIONS,
        "dklen": 32,
        "pepper": "none",
        "hashContract": ("password_hash = PBKDF2-HMAC-SHA256(password_utf8, "
                         "salt_bytes, iterations=100000, dklen=32) as hex; "
                         "salt = 16 random bytes as hex; no pepper"),
        "users": users,
    }
    with open(os.path.join(DATA_DIR, "gateway_users.json"), "w", encoding="utf-8") as f:
        json.dump(out, f, ensure_ascii=False, indent=2)
    return plaintexts


# ── 主流程 ────────────────────────────────────────────────────

def main():
    cli = Client()
    today = business_today(cli)
    print(f"施加目标: {cli.base}")
    print(f"业务日期: {today} | 幂等后缀: {TS}\n")

    EV["runAt"] = datetime.now().isoformat(timespec="seconds")
    EV["baseUrl"] = cli.base
    EV["tsSuffix"] = TS
    EV["seedLang"] = SEED_LANG
    EV["businessDateBeforeAdvance"] = today

    # 分档三件套 + 产品族
    range_id, bucket_id = create_delinquency_setup(cli)
    sv_product = create_savings_product(cli)
    ln_product = create_loan_product(cli, bucket_id)
    fd_product = create_fixed_deposit_product(cli)

    # ── 客户 A：过期证照 + 源/目标账户（源余额 10000）──
    a_id = create_client(cli, CP["surname_a"], f"POC-A{TS}", today, f"ABNK-POC-A-{TS}")
    doc = document_type_id(cli, a_id)
    add_identifier(cli, a_id, doc, f"ID-A-{TS}", EXPIRED, CP["id_desc_expired"])
    a_src = create_savings_account(cli, a_id, sv_product, today, f"ABNK-POC-A-SRC-{TS}")
    a_dst = create_savings_account(cli, a_id, sv_product, today, f"ABNK-POC-A-DST-{TS}")
    deposit(cli, a_src, 10000, today, CP["note_source_deposit"])
    bal_a = jget(cli.get(f"/savingsaccounts/{a_src}").data, "summary", "accountBalance")
    check("客户 A（过期证照）+ 源/目标账户施加深成功", a_src is not None and bal_a == 10000,
          f"clientId={a_id} src={a_src} dst={a_dst} 源余额={bal_a}")

    # ── 客户 B：有效证照 + 账户 5000 + 定期账户 10000 ──
    b_id = create_client(cli, CP["surname_b"], f"POC-B{TS}", today, f"ABNK-POC-B-{TS}")
    add_identifier(cli, b_id, doc, f"ID-B-{TS}", VALID, CP["id_desc_valid"])
    b_sav = create_savings_account(cli, b_id, sv_product, today, f"ABNK-POC-B-SAV-{TS}")
    deposit(cli, b_sav, 5000, today, CP["note_control_deposit"])
    b_fd = create_fd_account(cli, b_id, fd_product, today)
    fd_acct = cli.get(f"/fixeddepositaccounts/{b_fd}").data
    md = jget(fd_acct, "maturityDetail", default={}) or {}
    fd_maturity = dstr(jget(md, "maturityDate", default=jget(fd_acct, "maturityDate")))
    check("客户 B（有效证照）+ 账户 + 定期账户施加深成功",
          b_sav is not None and b_fd is not None and fd_maturity is not None,
          f"clientId={b_id} sav={b_sav} fd={b_fd} maturity={fd_maturity}")

    # ── 客户 C：逾期贷款（发放后不还款 → 日期推进 → 分档作业）──
    c_id = create_client(cli, CP["surname_c"], f"POC-C{TS}", today, f"ABNK-POC-C-{TS}")
    add_identifier(cli, c_id, doc, f"ID-C-{TS}", VALID, CP["id_desc_valid"])
    loan_id = create_overdue_loan(cli, c_id, ln_product, today)

    target, first_due = advance_business_date(cli, loan_id)
    trigger_delinquency_job(cli, loan_id, target, first_due)

    # ── 网关用户表 ──
    plaintexts = gen_gateway_users({"alice": a_id, "bob": b_id})
    users_path = os.path.join(DATA_DIR, "gateway_users.json")
    loaded = json.load(open(users_path, encoding="utf-8"))
    names = sorted(u["username"] for u in loaded["users"])
    check("gateway_users.json 三用户就位", names == ["admin", "alice", "bob"], names)
    # 自验：同一 PBKDF2 参数复算 alice hash 与文件比对
    alice = next(u for u in loaded["users"] if u["username"] == "alice")
    re_hash = hashlib.pbkdf2_hmac(
        "sha256", plaintexts["alice"].encode("utf-8"),
        bytes.fromhex(alice["salt"]), alice["iterations"], dklen=32).hex()
    check("alice PBKDF2 复算 hash 一致（跨端互验契约自检）",
          re_hash == alice["password_hash"], f"match=True iterations={alice['iterations']}")

    # ── 汇总与证据归档 ──
    EV["readback"]["seed"] = {
        "clientA": {"clientId": a_id, "externalId": f"ABNK-POC-A-{TS}",
                    "identifierExpiry": EXPIRED, "sourceAccount": a_src, "targetAccount": a_dst,
                    "sourceBalance": bal_a},
        "clientB": {"clientId": b_id, "externalId": f"ABNK-POC-B-{TS}",
                    "identifierExpiry": VALID, "savingsAccount": b_sav,
                    "fixedDepositAccount": b_fd, "fdMaturityDate": fd_maturity},
        "clientC": {"clientId": c_id, "externalId": f"ABNK-POC-C-{TS}",
                    "loanId": loan_id, "loanExternalId": f"ABNK-POC-C-LN-{TS}"},
        "products": {"savingsProductId": sv_product, "loanProductId": ln_product,
                     "fixedDepositProductId": fd_product,
                     "delinquencyRangeId": range_id, "delinquencyBucketId": bucket_id,
                     "delinquencyClassification": OD_CLASSIFICATION},
        "gatewayUsers": {"file": "data/gateway_users.json",
                         "usernames": names, "iterations": PBKDF2_ITERATIONS},
    }
    EV["summary"] = {
        "allPassed": all(a["pass"] for a in EV["asserts"]),
        "assertCount": len(EV["asserts"]),
        "note": "明文演示口令不入本证据文件（仅打印一次性，由执行者存 .github-private/）",
    }
    assert_no_empty(EV)
    os.makedirs(ART_DIR, exist_ok=True)
    ev_path = os.path.join(ART_DIR, "seed-poc-evidence.json")
    with open(ev_path, "w", encoding="utf-8") as f:
        json.dump(EV, f, ensure_ascii=False, indent=2)

    print("\n✅ POC 种子施加完成")
    print(f"  客户A(过期证照) clientId={a_id} 源账户={a_src} 目标账户={a_dst}（源余额 10000）")
    print(f"  客户B(有效证照) clientId={b_id} 储蓄={b_sav} 定期={b_fd}（maturity {fd_maturity}）")
    print(f"  客户C(逾期贷款) clientId={c_id} loanId={loan_id}（分档 {OD_CLASSIFICATION}）")
    print(f"  产品：储蓄={sv_product} 贷款={ln_product}(bucket={bucket_id}) 定期={fd_product}")
    print(f"  网关用户表: {users_path}")
    print(f"  证据: {ev_path}")

    print("\n═══ 一次性演示口令（勿入 git/artifacts——请存 .github-private/）═══")
    for username, pw in plaintexts.items():
        print(f"  {username}: {pw}")
    print("══════════════════════════════════════════════════════════════")


def assert_no_empty(obj, path="$"):
    if obj is None or obj == "" or obj == [] or obj == {}:
        raise AssertionError(f"证据存在空字段: {path} = {obj!r}")
    if isinstance(obj, dict):
        for k, v in obj.items():
            assert_no_empty(v, f"{path}.{k}")
    elif isinstance(obj, list):
        for i, v in enumerate(obj):
            assert_no_empty(v, f"{path}[{i}]")


if __name__ == "__main__":
    main()
