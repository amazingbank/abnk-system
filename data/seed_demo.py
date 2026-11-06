#!/usr/bin/env python3
"""KBank POC demo 种子数据（第 1 步）。

创建：
- 客户 A（证照「已过期」）＋ 两个储蓄账户（源账户有余额 10000，目标账户 0）
    → 演示「写交易被网关拦截」，修复后放行转账闭环
- 客户 B（证照「有效」）＋ 一个储蓄账户（余额 5000）→ 对照组
- username → clientId 映射 JSON（网关 InMemoryClientResolver 读取）

约定（沿用 lib/fineract_api.py）：
- 纯标准库、幂等（externalId / documentKey 带时间戳后缀）、失败即停
- 日期字段统一 dateFormat="yyyy-MM-dd"（与冒烟测试一致）

运行：cd abnk-system/data && python3 seed_demo.py
输出：seed_demo_mapping.json（本目录）
"""

import json
import os
import sys
from datetime import date, datetime

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "scripts", "lib"))
from fineract_api import Client  # noqa: E402

D_FMT = {"locale": "en", "dateFormat": "yyyy-MM-dd"}
TS = datetime.now().strftime("%m%d%H%M%S")          # 幂等后缀

# 证照有效期：明确早于/晚于任何“今天”，避免与业务日期/真实日期比较产生歧义
EXPIRED = "2020-01-01"
VALID = "2099-12-31"


def jget(data, *path, default=None):
    cur = data
    for p in path:
        if isinstance(cur, dict) and p in cur:
            cur = cur[p]
        else:
            return default
    return cur


def business_today(cli):
    """读 Fineract 业务日期作为“今天”；未设置则置为真实今天。"""
    bd = cli.get("/businessdate").data
    hit = next((x for x in (bd or []) if x.get("type") == "BUSINESS_DATE"), None)
    if hit:
        d = hit["date"]
        return f"{d[0]}-{d[1]:02d}-{d[2]:02d}"
    today = date.today().isoformat()
    cli.post("/businessdate", {"type": "BUSINESS_DATE", "date": today, **D_FMT})
    return today


def create_client(cli, first, last, today, ext):
    r = cli.post("/clients", {
        "officeId": 1, "firstname": first, "lastname": last,
        "legalFormId": 1, "active": False, "submittedOnDate": today,
        "externalId": ext, "mobileNo": f"139{TS[-8:]}", **D_FMT})
    cid = jget(r.data, "clientId", default=jget(r.data, "resourceId"))
    assert cid, f"建客户失败: {r.raw[:400]}"
    cli.post(f"/clients/{cid}", {"activationDate": today, **D_FMT}, query="command=activate")
    return cid


def document_type_id(cli, cid):
    """从 identifier template 取证照类型 id（优先 Id/身份证，否则首个）。"""
    tpl = cli.get(f"/clients/{cid}/identifiers/template").data
    types = jget(tpl, "allowedDocumentTypes", default=[]) or []
    for t in types:
        name = (t.get("name") or "").lower()
        if "id" in name or "身份证" in name:
            return t["id"]
    if types:
        return types[0]["id"]
    return 1


def add_identifier(cli, cid, doc_type_id, key, expiry, desc):
    r = cli.post(f"/clients/{cid}/identifiers", {
        "documentTypeId": doc_type_id, "documentKey": key,
        "documentDescription": desc, "issuanceDate": "2015-01-01",
        "expiryDate": expiry, **D_FMT})
    assert r.status == 200, f"建证照失败: {r.raw[:400]}"
    return jget(r.data, "resourceId")


def create_savings_product(cli):
    r = cli.post("/savingsproducts", {
        "name": f"ABNK-Demo活期{TS}", "shortName": f"D{TS[-3:]}",
        "description": "POC demo savings (accounting NONE)",
        "currencyCode": "CNY", "digitsAfterDecimal": 2, "inMultiplesOf": 0,
        "nominalAnnualInterestRate": 1.5,
        "interestCompoundingPeriodType": 1,      # Daily
        "interestPostingPeriodType": 1,          # Daily
        "interestCalculationType": 1,            # Daily Balance
        "interestCalculationDaysInYearType": 360,
        "accountingRule": 1,                     # NONE（会计为空）
        "minRequiredOpeningBalance": 0,
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
    cli.post(f"/savingsaccounts/{sid}", {"approvedOnDate": today, **D_FMT},
             query="command=approve")
    cli.post(f"/savingsaccounts/{sid}", {"activatedOnDate": today, **D_FMT},
             query="command=activate")
    return sid


def deposit(cli, sid, amount, today, note):
    pt = cli.get("/paymenttypes").data or []
    pay = pt[0]["id"] if pt else 1
    r = cli.post(f"/savingsaccounts/{sid}/transactions", {
        "transactionDate": today, "transactionAmount": amount,
        "paymentTypeId": pay, "note": note, **D_FMT}, query="command=deposit")
    assert r.status == 200, f"存款失败: {r.raw[:400]}"


def main():
    cli = Client()
    today = business_today(cli)
    print(f"业务日期: {today} | 幂等后缀: {TS}")

    # ── 客户 A：证照过期 + 源/目标两个账户 ──
    a_id = create_client(cli, "张", f"三{TS}", today, f"ABNK-DEMO-A-{TS}")
    doc = document_type_id(cli, a_id)
    add_identifier(cli, a_id, doc, f"ID-A-{TS}", EXPIRED, "身份证(已过期)")
    prod = create_savings_product(cli)
    a_src = create_savings_account(cli, a_id, prod, today, f"ABNK-DEMO-A-SRC-{TS}")
    a_dst = create_savings_account(cli, a_id, prod, today, f"ABNK-DEMO-A-DST-{TS}")
    deposit(cli, a_src, 10000, today, "demo 源账户初始余额")

    # ── 客户 B：证照有效 + 一个账户（对照）──
    b_id = create_client(cli, "李", f"四{TS}", today, f"ABNK-DEMO-B-{TS}")
    add_identifier(cli, b_id, doc, f"ID-B-{TS}", VALID, "身份证(有效)")
    b_sav = create_savings_account(cli, b_id, prod, today, f"ABNK-DEMO-B-{TS}")
    deposit(cli, b_sav, 5000, today, "demo 对照客户余额")

    # ── 用户名 → clientId 映射 ──
    mapping = {
        "alice": {"clientId": a_id, "accounts": {"source": a_src, "target": a_dst}},
        "bob": {"clientId": b_id, "accounts": {"primary": b_sav}},
    }
    out = os.path.join(os.path.dirname(os.path.abspath(__file__)), "seed_demo_mapping.json")
    with open(out, "w", encoding="utf-8") as f:
        json.dump(mapping, f, ensure_ascii=False, indent=2)

    print("\n✅ 种子数据完成")
    print(f"  客户A(过期) clientId={a_id} 源账户={a_src} 目标账户={a_dst}（源余额 10000）")
    print(f"  客户B(有效) clientId={b_id} 账户={b_sav}（余额 5000）")
    print(f"  证照类型 documentTypeId={doc}")
    print(f"  映射已写入: {out}")
    print(json.dumps(mapping, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
