#!/usr/bin/env python3
"""Phase P0 任务 P0.2 —— POC 主线能力探查（生产形态栈）。

四场景（对应 VP0.2.1–VP0.2.4，探查矩阵四节）：
  1. identifiers PUT 闭环：建临时客户+证照(expiry 2020-01-01) → PUT 改 2099-12-31 → GET 回读
     （旅程 Step 7 闭环修复的关键前提；PUT 不可用则实测「删+建」组合并在结论声明）
  2. 贷款全链路：建贷款产品(等额本息) → 申请 → approve → disburse → repayment
     （附带客户储蓄账户+存取款两笔交易，供场景 4 明细探查）
  3. 定期开户链路：fixeddepositproducts 建产品 → 账户 → approve/activate → 回读 maturity 字段
     （对年对月对日判定结论写矩阵，供旅程 Step 5 数据前提）
  4. 储蓄交易明细字段：GET /savingsaccounts/{id}/transactions/search（分页，过滤参数全可省）
     + POST /savingsaccounts/{id}/transactions/query（高级查询）——两种形态一并实测归档
     （旅程 Step 6 明细展示与 P2.3 透传聚合的数据前提）

运行：cd abnk-system/scripts/prodform && \
  ABNK_BASE_URL=http://localhost:8081/fineract-provider/api/v1 python3 probe_poc.py
输出：../../artifacts/phaseP0/capability-probe.json（探查矩阵，无空字段）
幂等：实体名/externalId/documentKey 带 TS 后缀；日期载荷一律带 locale+dateFormat（漏 locale 即 400 实测坑）。

契约依据：Fineract 源码 Swagger 注解与集成测试 helper（生产形态栈 /api-docs 实测返回空 paths，
springdoc 未产出——已归档，故以源码注解为契约事实源）：
  - PUT /clients/{id}/identifiers/{id}：ClientIdentifiersApiResource @PUT，支持字段
    documentTypeId/documentKey/status/description/documentDescription/issuanceDate/expiryDate
  - POST /fixeddepositproducts：必填 name/shortName/description/currencyCode/digitsAfterDecimal/
    inMultiplesOf/interestCompoundingPeriodType/interestCalculationType/interestCalculationDaysInYearType/
    minDepositTerm/minDepositTermTypeId/accountingRule；charts 可选
  - POST /fixeddepositaccounts：必填 clientId/productId/submittedOnDate/depositAmount/
    depositPeriod/depositPeriodFrequencyId；approve=approvedOnDate、activate=activatedOnDate
  - 枚举：SavingsCompoundingInterestPeriodType 1=Daily/4=Monthly；SavingsPostingInterestPeriodType
    1=Daily/4=Monthly；SavingsPeriodFrequencyType 0=Days/2=Months/3=Years
  - GET/POST /savingsaccounts/{id}/transactions/{search,query}：SavingsAccountTransactionsApiResource；
    search 为分页结构（totalFilteredRecords+pageItems），item 含 runningBalance；
    query 请求体 PagedLocalRequest{request:{baseQuery:{columnFilters,resultColumns}},page,size,locale,dateFormat}
"""

import json
import os
import sys
from datetime import date, datetime

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "lib"))
from fineract_api import Client  # noqa: E402

TS = datetime.now().strftime("%m%d%H%M%S")                # 幂等后缀（与冒烟同模式）
D_FMT = {"locale": "en", "dateFormat": "yyyy-MM-dd"}
EXPIRED = "2020-01-01"                                     # 证照初始过期日
VALID = "2099-12-31"                                       # PUT 目标有效期
ART = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "artifacts", "phaseP0")


def jget(data, *path, default=None):
    cur = data
    for p in path:
        if isinstance(cur, dict) and p in cur:
            cur = cur[p]
        else:
            return default
    return cur


def dstr(v):
    """Fineract 日期字段 [2020,1,1] → '2020-01-01'；其他原样。"""
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


class Scenario:
    """场景记录器：requests/asserts/readback/conclusion → 矩阵一节（无空字段）。"""

    def __init__(self, sid, name, purpose):
        self.doc = {"scenario": sid, "name": name, "purpose": purpose,
                    "requests": [], "asserts": [], "readback": {}, "conclusion": None}

    def req(self, method, path, resp):
        print(f"  {method} {path} → {resp.status} ({resp.elapsed:.2f}s)")
        self.doc["requests"].append({"method": method, "path": path, "status": resp.status})
        return resp

    def check(self, label, cond, evidence):
        mark = "✅" if cond else "❌"
        print(f"  {mark} {label} | {evidence}")
        self.doc["asserts"].append(
            {"label": label, "pass": bool(cond), "evidence": str(evidence)})
        if not cond:
            raise AssertionError(f"{self.doc['scenario']} 断言失败: {label} (证据: {evidence})")

    def readback(self, key, value):
        if value is not None:
            self.doc["readback"][key] = value

    def conclude(self, text):
        self.doc["conclusion"] = text
        print(f"  结论: {text}")


# ── 共享助手 ──────────────────────────────────────────────────

_CLIENT_SEQ = [0]


def create_client(cli, today, first, last, ext):
    _CLIENT_SEQ[0] += 1
    seq = _CLIENT_SEQ[0]
    r = cli.post("/clients", {
        "officeId": 1, "firstname": first, "lastname": last,
        "legalFormId": 1, "active": False, "submittedOnDate": today,
        "externalId": ext, "mobileNo": f"137{TS[-5:]}{seq:03d}", **D_FMT})
    cid = jget(r.data, "clientId", default=jget(r.data, "resourceId"))
    assert cid, f"建客户失败: {r.raw[:400]}"
    cli.post(f"/clients/{cid}", {"activationDate": today, **D_FMT}, query="command=activate")
    return cid, r


def document_type_id(cli, cid):
    tpl = cli.get(f"/clients/{cid}/identifiers/template").data
    types = jget(tpl, "allowedDocumentTypes", default=[]) or []
    if types:
        return types[0]["id"]
    return 1


def payment_type(cli):
    pt = cli.get("/paymenttypes").data or []
    return pt[0]["id"] if pt else 1


def create_savings_product(cli):
    r = cli.post("/savingsproducts", {
        "name": f"ABNK探查活期{TS}", "shortName": f"P{TS[-3:]}",
        "description": "P0.2 probe savings (accounting NONE)",
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


def savings_txn(cli, sid, command, amount, today, note):
    r = cli.post(f"/savingsaccounts/{sid}/transactions", {
        "transactionDate": today, "transactionAmount": amount,
        "paymentTypeId": payment_type(cli), "note": note, **D_FMT},
        query=f"command={command}")
    assert r.status == 200, f"储蓄交易({command})失败: {r.raw[:400]}"
    return r


# ── 场景 1：identifiers PUT 闭环（VP0.2.1 ★ 旅程 Step 7 前提） ──

def probe_identifiers_put(cli, today):
    s = Scenario("VP0.2.1", "identifiers PUT 闭环", "旅程 Step 7 证照有效期修复端点实测")

    cid, r = create_client(cli, today, "探查", f"证照{TS}", f"ABNK-PROBE-ID-{TS}")
    s.req("POST", "/clients", r)
    s.readback("clientId", cid)

    doc = document_type_id(cli, cid)
    s.readback("documentTypeId", doc)
    key = f"ID-PROBE-{TS}"

    # 建证照：expiry=2020-01-01（过期）——两处实测坑归档：
    # ① 载荷字段为 description（ClientIdentifierCommandFromApiJsonDeserializer.SUPPORTED_PARAMETERS
    #   实测：documentDescription 常量存在但未列入受支持集合，用之即 400）
    # ② status 必填：ClientIdentifier.fromJson 未缺省 status（返回空串），
    #   ClientIdentifierStatus.valueOf("") 即 500（上游缺陷——漏 status 应 400 实为 500，
    #   矩阵结论列声明；值为枚举名 INACTIVE/ACTIVE）
    payload_create = {"documentTypeId": doc, "documentKey": key,
                      "description": "probe identifier (expired)",
                      "status": "ACTIVE",
                      "issuanceDate": "2015-01-01", "expiryDate": EXPIRED, **D_FMT}
    r = cli.post(f"/clients/{cid}/identifiers", payload_create)
    ident_id = jget(r.data, "resourceId")
    s.req("POST", f"/clients/{cid}/identifiers", r)
    s.check("建证照成功（200 + resourceId）", r.status == 200 and ident_id is not None,
            f"status={r.status} identifierId={ident_id}")

    # 回读 1：expiry=2020-01-01
    r = cli.get(f"/clients/{cid}/identifiers/{ident_id}")
    s.req("GET", f"/clients/{cid}/identifiers/{ident_id}", r)
    before = dstr(jget(r.data, "expiryDate"))
    s.readback("expiryDateBeforePut", before)
    s.check(f"PUT 前回读 expiryDate = {EXPIRED}", before == EXPIRED, before)

    # PUT：改 expiry 为 2099-12-31（载荷带 locale+dateFormat）
    payload_put = {"expiryDate": VALID, **D_FMT}
    r = cli.request("PUT", f"/clients/{cid}/identifiers/{ident_id}", payload_put)
    s.req("PUT", f"/clients/{cid}/identifiers/{ident_id}", r)

    put_ok = r.status == 200
    if put_ok:
        # 回读 2：expiry=2099-12-31
        r2 = cli.get(f"/clients/{cid}/identifiers/{ident_id}")
        s.req("GET", f"/clients/{cid}/identifiers/{ident_id}", r2)
        after = dstr(jget(r2.data, "expiryDate"))
        s.readback("expiryDateAfterPut", after)
        s.readback("putPayload", json.dumps(payload_put, ensure_ascii=False))
        s.check(f"PUT 后回读 expiryDate = {VALID}", after == VALID, after)
        s.conclude(
            "PUT /clients/{clientId}/identifiers/{identifierId} 可用：expiry_date 由 "
            f"{EXPIRED} 更新为 {VALID} 回读一致；旅程 Step 7 证照修复可直接走 PUT 闭环"
            "（载荷须带 locale+dateFormat）")
    else:
        # 差距记录：改走「删 + 建」组合（记录完整即过，不算任务失败）
        s.readback("putFailedRaw", r.raw[:300])
        rd = cli.request("DELETE", f"/clients/{cid}/identifiers/{ident_id}")
        s.req("DELETE", f"/clients/{cid}/identifiers/{ident_id}", rd)
        payload_re = dict(payload_create, expiryDate=VALID)
        rc = cli.post(f"/clients/{cid}/identifiers", payload_re)
        new_id = jget(rc.data, "resourceId")
        s.req("POST", f"/clients/{cid}/identifiers", rc)
        r2 = cli.get(f"/clients/{cid}/identifiers/{new_id}")
        after = dstr(jget(r2.data, "expiryDate"))
        s.readback("fallbackRecreateExpiryDate", after)
        s.check("差距实测：删+建组合可达等效（expiry=2099-12-31）",
                rc.status == 200 and after == VALID, f"status={rc.status} expiry={after}")
        s.conclude(
            f"PUT 不可用（HTTP {r.status}），差距已记录；旅程 Step 7 改走「删 + 建」组合："
            f"DELETE 后重建 expiry={VALID} 回读一致，组合链路实测可用")
    return s.doc


# ── 场景 2：贷款全链路（VP0.2.2）＋ 客户储蓄账户（供场景 4） ──

def probe_loan_lifecycle(cli, today):
    s = Scenario("VP0.2.2", "贷款全链路", "POC 主线贷款端点行为基线（产品→申请→审批→发放→还款）")

    cid, r = create_client(cli, today, "探查", f"贷款{TS}", f"ABNK-PROBE-LN-{TS}")
    s.req("POST", "/clients", r)
    s.readback("clientId", cid)

    # 客户储蓄账户（供场景 4 明细探查）
    sv_product = create_savings_product(cli)
    sv_id = create_savings_account(cli, cid, sv_product, today, f"ABNK-PROBE-SAV-{TS}")
    s.readback("savingsAccountId", sv_id)
    s.readback("savingsProductId", sv_product)
    s.check("客户储蓄账户就绪（申请→审批→激活）", sv_id is not None, f"savingsId={sv_id}")
    t1 = savings_txn(cli, sv_id, "deposit", 10000, today, "probe deposit 10000")
    t2 = savings_txn(cli, sv_id, "withdrawal", 2000, today, "probe withdrawal 2000")
    s.readback("savingsTxnIds", [jget(t1.data, "resourceId"), jget(t2.data, "resourceId")])
    bal = jget(cli.get(f"/savingsaccounts/{sv_id}").data, "summary", "accountBalance")
    s.check("储蓄账户余额 = 8000（两笔交易后）", bal == 8000, bal)
    s.readback("savingsBalance", bal)

    # 贷款产品（等额本息——冒烟 step 8 实测口径原样）
    r = cli.post("/loanproducts", {
        "name": f"ABNK探查消费贷{TS}", "shortName": f"Q{TS[-3:]}",
        "description": "P0.2 probe consumer loan (equal installments)",
        "currencyCode": "CNY", "digitsAfterDecimal": 2, "inMultiplesOf": 0,
        "principal": 50000, "minPrincipal": 1000, "maxPrincipal": 200000,
        "numberOfRepayments": 12, "repaymentEvery": 1, "repaymentFrequencyType": 2,
        "interestRatePerPeriod": 10, "interestRateFrequencyType": 3,
        "amortizationType": 1, "interestType": 0, "interestCalculationPeriodType": 1,
        "daysInMonthType": 30, "daysInYearType": 360,
        "transactionProcessingStrategyCode": "mifos-standard-strategy",
        "accountingRule": 1, "includeInBorrowerCycle": False,
        "isInterestRecalculationEnabled": False, "allowVariableInstallments": False,
        "locale": "en"})
    ln_product = jget(r.data, "resourceId")
    s.req("POST", "/loanproducts", r)
    s.check("建贷款产品成功", ln_product is not None, f"productId={ln_product}")
    s.readback("loanProductId", ln_product)

    # 申请 → 审批 → 发放
    r = cli.post("/loans", {
        "productId": ln_product, "clientId": cid, "loanType": "individual",
        "principal": 50000, "loanTermFrequency": 12, "loanTermFrequencyType": 2,
        "numberOfRepayments": 12, "repaymentEvery": 1, "repaymentFrequencyType": 2,
        "interestRatePerPeriod": 10, "amortizationType": 1, "interestType": 0,
        "transactionProcessingStrategyCode": "mifos-standard-strategy",
        "interestCalculationPeriodType": 1, "submittedOnDate": today,
        "expectedDisbursementDate": today, "externalId": f"ABNK-PROBE-LN-{TS}", **D_FMT})
    loan_id = jget(r.data, "loanId", default=jget(r.data, "resourceId"))
    s.req("POST", "/loans", r)
    s.check("贷款申请成功", loan_id is not None, f"loanId={loan_id}")
    s.readback("loanId", loan_id)

    r = cli.post(f"/loans/{loan_id}", {"approvedOnDate": today, "approvedLoanAmount": 50000,
                                       "note": "probe approve", **D_FMT}, query="command=approve")
    s.req("POST", f"/loans/{loan_id}?command=approve", r)
    s.check("approve 200", r.status == 200, r.status)

    r = cli.post(f"/loans/{loan_id}", {"actualDisbursementDate": today,
                                       "note": "probe disburse", **D_FMT}, query="command=disburse")
    s.req("POST", f"/loans/{loan_id}?command=disburse", r)
    s.check("disburse 200", r.status == 200, r.status)

    r = cli.get(f"/loans/{loan_id}", query="associations=all")
    loan = r.data
    s.req("GET", f"/loans/{loan_id}?associations=all", r)
    status = jget(loan, "status", "value")
    sched = jget(loan, "repaymentSchedule", "periods", default=[])
    s.check("贷款状态 active（Phase 1 行为基线）", str(status).lower() in ("active", "300"),
            jget(loan, "status"))
    s.check("还款计划 ≥13 期（含放款行）", len(sched) >= 13, f"periods={len(sched)}")
    s.readback("loanStatus", jget(loan, "status"))
    s.readback("repaymentPeriods", len(sched))

    # 部分还款
    r = cli.post(f"/loans/{loan_id}/transactions", {
        "transactionDate": today, "transactionAmount": 4000,
        "note": "probe repayment", **D_FMT}, query="command=repayment")
    s.req("POST", f"/loans/{loan_id}/transactions?command=repayment", r)
    s.check("repayment 4000 成功（200）", r.status == 200, jget(r.data, "resourceId"))

    loan2 = cli.get(f"/loans/{loan_id}").data
    outstanding = jget(loan2, "summary", "totalOutstanding",
                      default=jget(loan2, "totalOutstanding"))
    s.readback("totalOutstandingAfterRepayment", outstanding)
    s.conclude(
        f"贷款全链路对生产形态全绿：等额本息 12 期、发放 50000、还款 4000 后状态 active、"
        f" totalOutstanding={outstanding}；与 Phase 1 行为基线一致")
    return s.doc


# ── 场景 3：定期开户链路（VP0.2.3） ────────────────────────────

def probe_fixed_deposit(cli, today):
    s = Scenario("VP0.2.3", "定期开户链路", "旅程 Step 5 定期产品前提：产品→账户→审批→激活→maturity 回读")

    cid, r = create_client(cli, today, "探查", f"定期{TS}", f"ABNK-PROBE-FD-{TS}")
    s.req("POST", "/clients", r)
    s.readback("clientId", cid)

    # 定期产品（必填字段对照 FixedDepositProductsApiResource @Operation；含利率 chart——
    # 无 chart 则 maturityAmount 空悬，按集成测试 FixedDepositProductHelper 实测口径）
    r = cli.post("/fixeddepositproducts", {
        "name": f"ABNK探查定期{TS}", "shortName": f"R{TS[-3:]}",
        "description": "P0.2 probe fixed deposit (12-month tier)",
        "currencyCode": "CNY", "digitsAfterDecimal": 2, "inMultiplesOf": 0,
        "interestCompoundingPeriodType": 4,      # Monthly
        "interestPostingPeriodType": 4,          # Monthly
        "interestCalculationType": 1,           # Daily Balance
        "interestCalculationDaysInYearType": 365,
        "depositAmount": 10000,                  # 实测必填（400: depositAmount.cannot.be.blank——资源文档必填清单未列全）
        "minDepositTerm": 1, "minDepositTermTypeId": 2,      # Months
        "maxDepositTerm": 60, "maxDepositTermTypeId": 2,
        "inMultiplesOfDepositTerm": 1, "inMultiplesOfDepositTermTypeId": 2,
        "preClosurePenalApplicable": False,
        "accountingRule": 1,
        "charts": [{
            "fromDate": "2026-01-01", "locale": "en", "dateFormat": "yyyy-MM-dd",
            "isPrimaryGroupingByAmount": False,
            "chartSlabs": [{
                "description": "POC probe FD tier 1-60m",
                "periodType": 2,               # Months（SavingsPeriodFrequencyType）
                "fromPeriod": 1, "toPeriod": 60,
                "annualInterestRate": 3.0, "locale": "en"}]}],
        "locale": "en"})
    fd_product = jget(r.data, "resourceId")
    s.req("POST", "/fixeddepositproducts", r)
    s.check("建定期产品成功", r.status == 200 and fd_product is not None,
            f"status={r.status} productId={fd_product}")
    s.readback("fdProductId", fd_product)

    # 定期账户：申请 → 审批 → 激活
    r = cli.post("/fixeddepositaccounts", {
        "clientId": cid, "productId": fd_product,
        "submittedOnDate": today, "depositAmount": 10000,
        "depositPeriod": 12, "depositPeriodFrequencyId": 2,   # Months
        "externalId": f"ABNK-PROBE-FDA-{TS}", **D_FMT})
    fd_id = jget(r.data, "savingsId", default=jget(r.data, "resourceId"))
    s.req("POST", "/fixeddepositaccounts", r)
    s.check("定期账户申请成功", r.status == 200 and fd_id is not None,
            f"status={r.status} accountId={fd_id}")
    s.readback("fdAccountId", fd_id)

    r = cli.post(f"/fixeddepositaccounts/{fd_id}", {"approvedOnDate": today, **D_FMT},
                 query="command=approve")
    s.req("POST", f"/fixeddepositaccounts/{fd_id}?command=approve", r)
    s.check("定期账户 approve 200", r.status == 200, r.status)

    r = cli.post(f"/fixeddepositaccounts/{fd_id}", {"activatedOnDate": today, **D_FMT},
                 query="command=activate")
    s.req("POST", f"/fixeddepositaccounts/{fd_id}?command=activate", r)
    s.check("定期账户 activate 200", r.status == 200, r.status)

    # 回读 maturity 字段（顶层与 maturityDetail 两形态兼容读取）
    r = cli.get(f"/fixeddepositaccounts/{fd_id}")
    acct = r.data
    s.req("GET", f"/fixeddepositaccounts/{fd_id}", r)
    status = jget(acct, "status", "value")
    s.check("定期账户状态 active", str(status).lower() in ("active", "300"), jget(acct, "status"))
    md = jget(acct, "maturityDetail", default={}) or {}
    maturity_date = dstr(jget(md, "maturityDate", default=jget(acct, "maturityDate")))
    maturity_amount = jget(md, "maturityAmount", default=jget(acct, "maturityAmount"))
    deposit_period = jget(md, "depositPeriod", default=jget(acct, "depositPeriod"))
    s.readback("maturityDate", maturity_date)
    s.readback("maturityAmount", maturity_amount)
    s.readback("depositPeriod", deposit_period)
    s.readback("fdStatus", jget(acct, "status"))
    s.check("maturity 日期字段存在", maturity_date is not None, maturity_date)
    s.check("maturityAmount 字段存在", maturity_amount is not None, maturity_amount)

    # 对年对月对日判定：12 个月期 → 到期日应为激活日 + 12 个月（同月同日次年）
    y, m, d = (int(x) for x in today.split("-"))
    try:
        expected = date(y + 1, m, d).isoformat()
    except ValueError:  # 2/29 类边界，退化为日尾对齐说明
        expected = date(y + 1, m, 28).isoformat()
    aligned = (maturity_date == expected)
    s.check(f"对年对月对日判定：到期日 = 激活日 + 12 个月（{expected}）", aligned,
            f"maturityDate={maturity_date} expected={expected}")
    s.conclude(
        f"定期开户链路全绿：12 个月期 maturityDate={maturity_date}（对年对月对日"
        f"{'成立' if aligned else '不成立——Fineract 按自然月推算，见归档实测值'}），"
        f"maturityAmount={maturity_amount}；旅程 Step 5 数据前提成立")
    return s.doc


# ── 场景 4：储蓄交易明细字段（VP0.2.4，用场景 2 的储蓄账户） ──

def probe_savings_transactions(cli, loan_doc):
    sid = loan_doc["readback"]["savingsAccountId"]
    s = Scenario("VP0.2.4", "储蓄交易明细字段", "旅程 Step 6 明细展示与 P2.3 透传聚合的数据前提")
    s.readback("savingsAccountId", sid)

    # 形态一：GET search（过滤参数全可省 = 全量分页）
    # 实测形态（2026-11-07 本栈）：分页字段为 content/total/pageable（Spring 标准 Page
    # 序列化），并非计划文档预设的 totalFilteredRecords/pageItems——差异归档进结论，
    # P2.3 聚合与旅程 Step 6 应按实测字段名对接
    r = cli.get(f"/savingsaccounts/{sid}/transactions/search")
    s.req("GET", f"/savingsaccounts/{sid}/transactions/search", r)
    s.check("search 200", r.status == 200, r.status)
    data = r.data or {}
    items = data.get("content") or data.get("pageItems") or []
    s.check("分页结构（content + total，实测 Spring 标准分页）",
            ("content" in data and "total" in data) or ("pageItems" in data and "totalFilteredRecords" in data),
            f"keys={sorted(data.keys())}")
    s.check(f"交易明细 ≥2 笔（存 10000 + 取 2000）", len(items) >= 2, f"items={len(items)}")
    s.readback("searchPageShape", {k: data.get(k) for k in ("total", "totalFilteredRecords") if k in data})

    item_keys = sorted(items[0].keys()) if items else []
    s.readback("searchItemFields", item_keys)
    has_rb = any("runningBalance" in (it or {}) for it in items)
    s.check("item 含 runningBalance 字段", has_rb,
            [it.get("runningBalance") for it in items])
    s.readback("searchItemSample", {
        "id": items[0].get("id"), "transactionType": jget(items[0], "transactionType", "value"),
        "amount": items[0].get("amount"), "runningBalance": items[0].get("runningBalance")})
    rbs = [(jget(it, "transactionType", "value"), it.get("amount"), it.get("runningBalance"))
           for it in items]
    s.readback("runningBalanceSeries", rbs)

    # 形态二：POST query（高级查询——columnFilters/resultColumns 对照
    # m_savings_account_transaction 表列名，operator 为 SqlOperator 枚举）
    payload = {
        "page": 0, "size": 50, "locale": "en", "dateFormat": "yyyy-MM-dd",
        "request": {"baseQuery": {
            "columnFilters": [{"column": "amount", "filters": [
                {"operator": "GTE", "values": ["0"]}]}],
            "resultColumns": ["id", "transaction_date", "amount",
                              "transaction_type_enum", "running_balance_derived"]}}}
    r = cli.request("POST", f"/savingsaccounts/{sid}/transactions/query", payload)
    s.req("POST", f"/savingsaccounts/{sid}/transactions/query", r)
    s.readback("queryPayload", json.dumps(payload, ensure_ascii=False))
    qdata = r.data if isinstance(r.data, (dict, list)) else None
    if r.status == 200:
        qitems = None
        if isinstance(qdata, dict):
            qitems = qdata.get("content") or qdata.get("pageItems")
        elif isinstance(qdata, list):
            qitems = qdata
        s.check("query 高级查询 200", True, f"status={r.status}")
        s.readback("queryResponseShape",
                   "spring-page(content/total)" if isinstance(qdata, dict) and "content" in qdata
                   else ("legacy-page(pageItems/totalFilteredRecords)"
                         if isinstance(qdata, dict) and "pageItems" in qdata else "bare-list"))
        s.readback("queryItemCount", len(qitems) if isinstance(qitems, list) else None)
        s.readback("queryFirstItem", qitems[0] if isinstance(qitems, list) and qitems else None)
        s.conclude(
            f"两种明细形态均可用：GET search 为分页结构（实测字段 content/total/pageable"
            f"——与计划文档预设的 totalFilteredRecords/pageItems 有差异，P2.3 按实测字段名对接），"
            f"item 含 runningBalance/transactionType/amount 共 {len(item_keys)} 字段；"
            f"POST query 高级查询实测 200；旅程 Step 6 明细展示建议采用 search 形态")
    else:
        s.readback("queryFailedRaw", (r.raw or "")[:300])
        s.conclude(
            f"GET search 可用（分页结构 content/total + runningBalance 齐备——实测字段名与"
            f"计划预设的 totalFilteredRecords/pageItems 有差异，P2.3 按实测对接）；POST query"
            f" 实测 HTTP {r.status}（差距已归档，聚合采用 search 形态即可满足旅程 Step 6 前提）")
    return s.doc


# ── 矩阵完整性自检（无空字段） ─────────────────────────────────

def assert_no_empty(obj, path="$"):
    if obj is None or obj == "" or obj == [] or obj == {}:
        raise AssertionError(f"矩阵存在空字段: {path} = {obj!r}")
    if isinstance(obj, dict):
        for k, v in obj.items():
            assert_no_empty(v, f"{path}.{k}")
    elif isinstance(obj, list):
        for i, v in enumerate(obj):
            assert_no_empty(v, f"{path}[{i}]")


def main():
    cli = Client()
    today = business_today(cli)
    print(f"探查目标: {cli.base}")
    print(f"业务日期: {today} | 幂等后缀: {TS}\n")

    print("===== 场景 1/4: identifiers PUT 闭环 =====")
    s1 = probe_identifiers_put(cli, today)
    print("\n===== 场景 2/4: 贷款全链路 =====")
    s2 = probe_loan_lifecycle(cli, today)
    print("\n===== 场景 3/4: 定期开户链路 =====")
    s3 = probe_fixed_deposit(cli, today)
    print("\n===== 场景 4/4: 储蓄交易明细字段 =====")
    s4 = probe_savings_transactions(cli, s2)

    matrix = {
        "runAt": datetime.now().isoformat(timespec="seconds"),
        "baseUrl": cli.base,
        "businessDate": today,
        "tsSuffix": TS,
        "contractNote": ("生产形态栈 /api-docs 实测返回空 paths（springdoc 未产出），"
                         "契约以 Fineract 源码 Swagger 注解与集成测试 helper 为事实源"),
        "scenarios": [s1, s2, s3, s4],
        "summary": {
            "allPassed": all(a["pass"] for sc in [s1, s2, s3, s4] for a in sc["asserts"]),
            "scenarioCount": 4,
            "keyEndpoints": ["PUT /clients/{id}/identifiers/{id}", "POST /loanproducts",
                             "POST /loans + approve/disburse/repayment",
                             "POST /fixeddepositproducts", "POST /fixeddepositaccounts",
                             "GET /savingsaccounts/{id}/transactions/search",
                             "POST /savingsaccounts/{id}/transactions/query"],
        },
    }
    assert_no_empty(matrix)
    os.makedirs(ART, exist_ok=True)
    out = os.path.join(ART, "capability-probe.json")
    with open(out, "w", encoding="utf-8") as f:
        json.dump(matrix, f, ensure_ascii=False, indent=2)
    print(f"\n✅ 四场景探查完成，矩阵已写入: {out}")
    print(f"   全部断言通过: {matrix['summary']['allPassed']}")
    for sc in [s1, s2, s3, s4]:
        print(f"   [{sc['scenario']}] {sc['name']}: {len(sc['asserts'])} 断言全过")


if __name__ == "__main__":
    main()
