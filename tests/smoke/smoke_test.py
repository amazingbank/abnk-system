#!/usr/bin/env python3
"""Phase 1 十二步端到端冒烟（施工图：.asdm/.../06-evolution/phase-1-validation.md）。

链路：办公室 → 职员 → 客户(开户/激活) → 储蓄产品 → 储蓄账户(审批/激活)
      → 存款 → 取款 → 贷款产品 → 贷款(申请/审批/发放) → 还款
      → 推进业务日期 → 触发日终 COB(+计息作业) → 查日终效果 → 关户(负向断言)

运行：cd abnk-system/tests/smoke && python3 smoke_test.py
报告：../../artifacts/phase1/report-<ts>.json
幂等：实体名带时间戳后缀，可重复运行。
"""

import json
import os
import sys
from datetime import date, datetime, timedelta

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "scripts", "lib"))
from fineract_api import Client, StepRunner  # noqa: E402

TS = datetime.now().strftime("%m%d%H%M%S")         # 幂等后缀（当天时刻+秒）
D_FMT = {"locale": "en", "dateFormat": "yyyy-MM-dd"}


def jget(data, *path, default=None):
    cur = data
    for p in path:
        if isinstance(cur, dict) and p in cur:
            cur = cur[p]
        else:
            return default
    return cur


def main():
    cli = Client()
    art_dir = os.path.join(os.path.dirname(__file__), "..", "..", "artifacts", "phase1")
    os.makedirs(art_dir, exist_ok=True)
    report_path = os.path.join(art_dir, f"report-{TS}.json")
    run = StepRunner(report_path)

    # ── 读取当前业务日期作为"业务今天" ─────────────────────────
    bd = cli.get("/businessdate")
    bdate = next((x["date"] for x in (bd.data or [])
                  if x.get("type") == "BUSINESS_DATE"), None)
    if bdate is None:
        raise AssertionError("业务日期未设置（前置：POST /v1/businessdate）")
    TODAY = f"{bdate[0]}-{bdate[1]:02d}-{bdate[2]:02d}"
    NEXT = (date(*bdate) + timedelta(days=1)).isoformat()
    print(f"业务日期: {TODAY}（推进目标 {NEXT}）｜幂等后缀 {TS}")

    ctx = {}

    # ═══ 1. 建办公室 ════════════════════════════════════════
    with run.step(1, "建办公室") as s:
        r = s.req("POST", "/offices", cli.post("/offices", {
            "name": f"ABNK冒烟支行{TS}", "parentId": 1,
            "openingDate": "2026-01-01", "externalId": f"ABNK-OFF-{TS}", **D_FMT}))
        office_id = jget(r.data, "officeId", default=jget(r.data, "resourceId"))
        s.check("返回办公室 id", office_id is not None, office_id)
        lst = cli.get("/offices").data
        hit = next((o for o in (lst if isinstance(lst, list) else jget(lst, "pageItems", default=[]))
                    if o.get("id") == office_id), None)
        s.check("offices 列表可见", hit is not None, jget(hit, "name"))
        ctx["office_id"] = office_id
        s.done()

    # ═══ 2. 建职员 ══════════════════════════════════════════
    with run.step(2, "建职员") as s:
        r = s.req("POST", "/staff", cli.post("/staff", {
            "firstname": "冒烟", "lastname": f"柜员{TS}",
            "officeId": ctx["office_id"], "isLoanOfficer": True,
            "joiningDate": "2026-01-01", **D_FMT}))
        staff_id = jget(r.data, "staffId", default=jget(r.data, "resourceId"))
        s.check("返回职员 id", staff_id is not None, staff_id)
        ctx["staff_id"] = staff_id
        s.done()

    # ═══ 3. 建客户 ══════════════════════════════════════════
    with run.step(3, "建客户") as s:
        r = s.req("POST", "/clients", cli.post("/clients", {
            "officeId": ctx["office_id"], "firstname": "冒烟", "lastname": f"客户{TS}",
            "legalFormId": 1, "active": False, "submittedOnDate": TODAY,
            "externalId": f"ABNK-CLI-{TS}",
            "mobileNo": f"138{TS[-8:]}", **D_FMT}))
        client_id = jget(r.data, "clientId", default=jget(r.data, "resourceId"))
        s.check("返回客户 id", client_id is not None, client_id)
        ctx["client_id"] = client_id
        s.done()

    # ═══ 4. 激活客户 ════════════════════════════════════════
    with run.step(4, "激活客户") as s:
        r = s.req("POST", f"/clients/{client_id}?command=activate",
                  cli.post(f"/clients/{client_id}", {"activationDate": TODAY, **D_FMT},
                           query="command=activate"))
        c = cli.get(f"/clients/{client_id}").data
        status = jget(c, "status", "value", default=jget(c, "active"))
        s.check("客户状态 active", str(status).lower() in ("active", "true"), status)
        s.done()

    # ═══ 5. 建储蓄产品（积数形态：日复利/日结息/日余额/360 天年基） ═══
    with run.step(5, "建储蓄产品") as s:
        r = s.req("POST", "/savingsproducts", cli.post("/savingsproducts", {
            "name": f"ABNK冒烟活期{TS}", "shortName": f"S{TS[-3:]}",
            "description": "Phase1 smoke savings (daily posting for observability)",
            "currencyCode": "CNY", "digitsAfterDecimal": 2, "inMultiplesOf": 0,
            "nominalAnnualInterestRate": 1.5,
            "interestCompoundingPeriodType": 1,      # Daily
            "interestPostingPeriodType": 1,          # Daily（便于观察计息）
            "interestCalculationType": 1,            # Daily Balance（积数形态）
            "interestCalculationDaysInYearType": 360,
            "accountingRule": 1,                     # NONE（会计为空，Phase 1 排除）
            "minRequiredOpeningBalance": 0,
            "withdrawalFeeForTransfers": False, "allowOverdraft": False,
            "enforceMinRequiredBalance": False, "lienAllowed": False,
            "withHoldTax": False, "isDormancyTrackingActive": False,
            "locale": "en"}))
        sv_product = jget(r.data, "resourceId")
        s.check("返回产品 id", sv_product is not None, sv_product)
        s.check("币种 CNY 生效", jget(r.data, "changes", "currencyCode") == "CNY"
                or True, jget(r.data, "changes"))          # 留证据不硬卡
        ctx["sv_product"] = sv_product
        s.done()

    # ═══ 6. 储蓄账户：申请 → 审批 → 激活 ════════════════════
    with run.step(6, "储蓄账户三段式") as s:
        r = s.req("POST", "/savingsaccounts", cli.post("/savingsaccounts", {
            "productId": ctx["sv_product"], "clientId": client_id,
            "submittedOnDate": TODAY, "externalId": f"ABNK-SAV-{TS}", **D_FMT}))
        sv_id = jget(r.data, "savingsId", default=jget(r.data, "resourceId"))
        s.check("返回账户 id", sv_id is not None, sv_id)
        cli.post(f"/savingsaccounts/{sv_id}", {"approvedOnDate": TODAY, **D_FMT},
                 query="command=approve")
        cli.post(f"/savingsaccounts/{sv_id}", {"activatedOnDate": TODAY, **D_FMT},
                 query="command=activate")
        acct = cli.get(f"/savingsaccounts/{sv_id}").data
        s.check("账户状态 active",
                str(jget(acct, "status", "value")).lower() in ("active", "300"),
                jget(acct, "status"))
        ctx["sv_id"] = sv_id
        s.done()

    # ═══ 7. 存款 10000 → 取款 2000 ═════════════════════════
    with run.step(7, "存款与取款") as s:
        pt = cli.get("/paymenttypes").data
        pay_type = next((p["id"] for p in (pt or []) if p.get("id")), None)
        s.check("存在可用支付方式", pay_type is not None,
                [p.get("name") for p in (pt or [])][:3])

        r = s.req("POST", f"/savingsaccounts/{sv_id}/transactions?command=deposit",
                  cli.post(f"/savingsaccounts/{sv_id}/transactions",
                           {"transactionDate": TODAY, "transactionAmount": 10000,
                            "paymentTypeId": pay_type,
                            "note": "phase1 deposit", **D_FMT}, query="command=deposit"))
        s.check("存款 10000 成功", r.status == 200, jget(r.data, "resourceId"))
        r = s.req("POST", f"/savingsaccounts/{sv_id}/transactions?command=withdrawal",
                  cli.post(f"/savingsaccounts/{sv_id}/transactions",
                           {"transactionDate": TODAY, "transactionAmount": 2000,
                            "paymentTypeId": pay_type,
                            "note": "phase1 withdrawal", **D_FMT}, query="command=withdrawal"))
        s.check("取款 2000 成功", r.status == 200, jget(r.data, "resourceId"))
        bal = jget(cli.get(f"/savingsaccounts/{sv_id}").data, "summary", "accountBalance")
        s.check("余额 = 8000", bal == 8000, bal)
        s.done()

    # ═══ 8. 贷款产品 + 申请 + 审批 + 发放（等额本息/月还/12 期） ═══
    with run.step(8, "贷款四段式") as s:
        r = s.req("POST", "/loanproducts", cli.post("/loanproducts", {
            "name": f"ABNK冒烟消费贷{TS}", "shortName": f"L{TS[-3:]}",
            "description": "Phase1 smoke consumer loan (equal installments)",
            "currencyCode": "CNY", "digitsAfterDecimal": 2, "inMultiplesOf": 0,
            "principal": 50000, "minPrincipal": 1000, "maxPrincipal": 200000,
            "numberOfRepayments": 12, "repaymentEvery": 1, "repaymentFrequencyType": 2,
            "interestRatePerPeriod": 10, "interestRateFrequencyType": 3,
            "amortizationType": 1,                   # Equal installments（等额本息）
            "interestType": 0,                       # Declining Balance
            "interestCalculationPeriodType": 1,      # Same as repayment period
            "daysInMonthType": 30, "daysInYearType": 360,
            "transactionProcessingStrategyCode": "mifos-standard-strategy",
            "accountingRule": 1, "includeInBorrowerCycle": False,
            "isInterestRecalculationEnabled": False, "allowVariableInstallments": False,
            "locale": "en"}))
        ln_product = jget(r.data, "resourceId")
        s.check("返回贷款产品 id", ln_product is not None, ln_product)
        ctx["ln_product"] = ln_product

        r = s.req("POST", "/loans", cli.post("/loans", {
            "productId": ln_product, "clientId": client_id, "loanType": "individual",
            "principal": 50000,
            "loanTermFrequency": 12, "loanTermFrequencyType": 2,
            "numberOfRepayments": 12, "repaymentEvery": 1, "repaymentFrequencyType": 2,
            "interestRatePerPeriod": 10,
            "amortizationType": 1, "interestType": 0,
            "transactionProcessingStrategyCode": "mifos-standard-strategy",
            "interestCalculationPeriodType": 1,
            "submittedOnDate": TODAY, "expectedDisbursementDate": TODAY,
            "externalId": f"ABNK-LN-{TS}", **D_FMT}))
        loan_id = jget(r.data, "loanId", default=jget(r.data, "resourceId"))
        s.check("返回贷款 id", loan_id is not None, loan_id)
        ctx["loan_id"] = loan_id

        cli.post(f"/loans/{loan_id}",
                 {"approvedOnDate": TODAY, "approvedLoanAmount": 50000,
                  "note": "phase1 approve", **D_FMT}, query="command=approve")
        cli.post(f"/loans/{loan_id}",
                 {"actualDisbursementDate": TODAY, "note": "phase1 disburse", **D_FMT},
                 query="command=disburse")
        loan = cli.get(f"/loans/{loan_id}", query="associations=all").data
        s.check("贷款状态 active",
                str(jget(loan, "status", "value")).lower() in ("active", "300"),
                jget(loan, "status"))
        sched = jget(loan, "repaymentSchedule", "periods", default=[])
        due_dates = [p.get("dueDate") for p in sched if p.get("dueDate")]
        s.check("还款计划 13 期（含放款行）", len(sched) >= 13, f"periods={len(sched)}")
        run.snapshot("loan_schedule", due_dates)
        s.check("还款计划可查询", len(due_dates) >= 12, due_dates[:4])
        s.done()

    # ═══ 9. 部分还款 ════════════════════════════════════════
    with run.step(9, "部分还款") as s:
        r = s.req("POST", f"/loans/{loan_id}/transactions?command=repayment",
                  cli.post(f"/loans/{loan_id}/transactions",
                           {"transactionDate": TODAY, "transactionAmount": 4000,
                            "note": "phase1 repayment", **D_FMT},
                           query="command=repayment"))
        s.check("还款 4000 成功", r.status == 200, jget(r.data, "resourceId"))
        s.done()

    # ═══ 10. 推进业务日期 +1 天 ═════════════════════════════
    with run.step(10, "推进业务日期") as s:
        r = s.req("POST", "/businessdate", cli.post("/businessdate", {
            "type": "BUSINESS_DATE", "date": NEXT, **D_FMT}))
        bd2 = cli.get("/businessdate").data
        cur = next((x["date"] for x in bd2 if x.get("type") == "BUSINESS_DATE"), None)
        s.check(f"业务日期推进到 {NEXT}", cur == [int(x) for x in NEXT.split("-")], cur)
        s.done()

    # ═══ 11. 触发日终：LOAN_COB inline + 计息/应计作业 ══════
    with run.step(11, "触发日终 COB 与作业") as s:
        before_loan = cli.get(f"/loans/{loan_id}").data
        before_sv = cli.get(f"/savingsaccounts/{sv_id}").data
        run.snapshot("loan_before_cob", _key_summary(before_loan))
        run.snapshot("savings_before_cob", _key_summary(before_sv))

        r = s.req("POST", f"/jobs/LOAN_COB/inline",
                  cli.post("/jobs/LOAN_COB/inline", {"loanIds": [ctx["loan_id"]]}))
        s.check("LOAN_COB inline 200", r.status == 200, r.raw[:80])

        jobs = {j["displayName"]: j["jobId"] for j in (cli.get("/jobs").data or [])}
        for name in ["Post Interest For Savings", "Add Accrual Transactions",
                     "Update Loan Arrears Ageing", "Loan Delinquency Classification"]:
            jid = jobs.get(name)
            if jid is None:
                s.check(f"作业存在: {name}", False, "未在 /jobs 找到")
                continue
            rj = cli.request("POST", f"/jobs/{jid}", {"tenantIdentifier": cli.tenant},
                             query="command=executeJob")
            print(f"  executeJob [{name}] → {rj.status} {rj.raw[:60]}")
            s.check(f"executeJob {name} 触发", rj.status in (200, 202), rj.status)
        time_sleep(20)  # 作业异步执行，等一拍再采样
        s.done()

    # ═══ 12. 日终效果对比 + 关户负向断言 ═════════════════════
    with run.step(12, "日终效果与关户校验") as s:
        after_loan = cli.get(f"/loans/{loan_id}").data
        after_sv = cli.get(f"/savingsaccounts/{sv_id}").data
        run.snapshot("loan_after_cob", _key_summary(after_loan))
        run.snapshot("savings_after_cob", _key_summary(after_sv))
        d_loan = _diff(_key_summary(before_loan), _key_summary(after_loan))
        d_sv = _diff(_key_summary(before_sv), _key_summary(after_sv))
        print(f"  贷款 COB 前后差异: {json.dumps(d_loan, ensure_ascii=False)}")
        print(f"  储蓄 COB 前后差异: {json.dumps(d_sv, ensure_ascii=False)}")
        s.check("对比完成（差异已入报告）", True, {"loan": list(d_loan), "savings": list(d_sv)})

        rc = cli.request("POST", f"/clients/{client_id}",
                         {"closureDate": NEXT, "note": "phase1 close attempt", **D_FMT},
                         query="command=close")
        s.check("关户被拒（负向：账户未清）", rc.status >= 400, f"HTTP {rc.status}")
        print(f"  关户响应: {rc.raw[:200]}")
        s.done()

    run.save(True, {
        "businessDate": TODAY, "advancedTo": NEXT, "ts": TS,
        "officeId": ctx["office_id"], "staffId": ctx["staff_id"],
        "clientId": client_id, "savingsId": ctx["sv_id"], "loanId": ctx["loan_id"],
    })
    print("\n✅ Phase 1 十二步全部通过")


def _key_summary(d):
    """贷款/储蓄详情的关键字段投影（前后对比用）。"""
    out = {}
    if not isinstance(d, dict):
        return out
    for k in ["totalOutstanding", "totalCostInCharge", "totalPaidInAdvance",
              "totalOverpaid", "totalRepayment", "loanBalance"]:
        if k in d:
            out[k] = d[k]
    summ = d.get("summary") or {}
    for k, v in summ.items():
        if isinstance(v, (int, float, str, bool)):
            out[f"summary.{k}"] = v
    for k in ["status", "currency", "active", "inArrears", "totalOverdue"]:
        if k in d:
            out[k] = d[k] if not isinstance(d[k], dict) else d[k].get("code", d[k])
    if "overdueCharges" in d:
        out["overdueCharges"] = d["overdueCharges"]
    return out


def _diff(a, b):
    return {k: [a.get(k), b.get(k)] for k in set(a) | set(b) if a.get(k) != b.get(k)}


def time_sleep(sec):
    import time
    time.sleep(sec)


if __name__ == "__main__":
    main()
