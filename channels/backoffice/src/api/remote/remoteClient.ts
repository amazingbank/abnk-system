/**
 * ClientRepository 的 remote 实现（任务 P3.2）——契约内部面 `/bo/api/v1/clients*`
 * 经网关全量转发（P2.5 转发面定案），raw Fineract 形态在本适配层组装为
 * P1.4 repository 接口形态（页面零感知）。
 *
 * 组装链（契约 ClientDetail/ClientListResult 的字段反推依据）：
 * - 列表：`GET /clients?search=`（raw 分页）+ 每客户首证照并发补齐
 *   （`GET /clients/{id}/identifiers`——证照状态列数据，转发面无聚合故由
 *   适配层补齐；失败降级 null 不阻断整页）；
 * - 详情：`GET /clients/{id}` + identifiers + `GET /clients/{id}/accounts`
 *   （rawGet——不在生成 client 契约面）+ 贷款 `GET /loans/{id}`；
 *   定期账户到期日/利率经 `GET /fixeddepositaccounts/{id}` 补齐（/accounts
 *   投影无 maturityDate）；
 * - 证照更新：`PUT /clients/{id}/identifiers/{identifierId}`——Fineract 侧
 *   必填的 locale/dateFormat 由本层注入（契约面不暴露、转发面不注入，
 *   P0.2 VP0.2.1 / P2.5 VP2.5.3 归档实测口径），PUT 响应为变更回执
 *   （resourceId/changes），非证照形态——回读 identifiers 后映射返回。
 */

import type {
  ClientDetail,
  ClientIdentifier,
  ClientListQuery,
  ClientListResult,
  ClientRepository,
  ClientSummary,
  IdentifierUpdatePayload,
  LoanSummary,
  SavingsAccountSummary,
} from '../repositories/clientRepository';
import { AxiosError } from 'axios';
import { toApiError, type GatewayClient } from './generatedClient';
import {
  daysBetween,
  deriveStatus,
  getBusinessDate,
  normalizeDate,
  type RawClientAccounts,
  type RawClientFull,
  type RawClientsPage,
  type RawFixedDepositDetail,
  type RawIdentifier,
  type RawLoanLike,
  type RawSavingsAccount,
} from './fineractRaw';

/** 定期账户判据（/accounts 投影 depositType.code，P3.2 探查实测） */
const FIXED_DEPOSIT_CODE = 'depositAccountType.fixedDeposit';

/** raw 证照 → 契约 ClientIdentifier（含到期状态推导 + 记录状态映射） */
function mapIdentifier(raw: RawIdentifier, businessDate: string): ClientIdentifier {
  const expiryDate = normalizeDate(raw.expiryDate) ?? '';
  return {
    identifierId: raw.id,
    documentTypeId: raw.documentType?.id ?? 0,
    documentTypeName: raw.documentType?.name ?? '',
    documentKey: raw.documentKey ?? '',
    status: raw.status?.endsWith('.active') ? 'ACTIVE' : 'INACTIVE',
    derivedStatus: deriveStatus(expiryDate, businessDate),
    issuanceDate: normalizeDate(raw.issuanceDate) ?? '',
    expiryDate,
    description: raw.description,
  };
}

/** raw 贷款 → 契约 LoanSummary（逾期天数 = 业务日期 − 逾期起算日） */
function mapLoan(raw: RawLoanLike, businessDate: string): LoanSummary {
  const overdueSinceDate = normalizeDate(raw.summary?.overdueSinceDate);
  return {
    loanId: raw.id,
    externalId: raw.externalId ?? '',
    productName: raw.loanProductName ?? '',
    principal: raw.principal ?? 0,
    interestRate: raw.annualInterestRate ?? 0,
    termMonths: raw.termFrequency ?? 0,
    status: raw.status?.value ?? '',
    inArrears: raw.inArrears ?? false,
    overdueDays: overdueSinceDate ? daysBetween(overdueSinceDate, businessDate) : 0,
    overdueSinceDate,
    totalOverdue: raw.summary?.totalOverdue ?? 0,
    delinquencyClassification: raw.delinquencyRange?.classification ?? null,
  };
}

/** raw 活期账户 → 契约 SavingsAccountSummary */
function mapSavings(acct: RawSavingsAccount): SavingsAccountSummary {
  return {
    id: acct.id,
    accountNo: acct.accountNo ?? '',
    productName: acct.productName ?? '',
    accountBalance: acct.accountBalance ?? 0,
    currency: acct.currency?.code ?? '',
    status: acct.status?.value ?? '',
  };
}

export function createRemoteClientRepository(client: GatewayClient): ClientRepository {
  return {
    async listClients(query: ClientListQuery = {}): Promise<ClientListResult> {
      try {
        const search = query.search?.trim() || undefined;
        const page = (await client.clients.listClients(search)).data as unknown as RawClientsPage;
        const rows = page.pageItems ?? [];
        const businessDate = await getBusinessDate(client);
        // 首证照并发补齐（N+1 转发面无聚合——POC 数据量口径）；单项失败降级 null
        const firstIdentifiers = await Promise.all(
          rows.map((row) =>
            client.clients
              .listClientIdentifiers(row.id)
              .then((resp) => (resp.data as unknown as RawIdentifier[])[0] ?? null)
              .catch(() => null),
          ),
        );
        const items: ClientSummary[] = rows.map((row, i) => {
          const identifier = firstIdentifiers[i];
          const expiryDate = identifier ? normalizeDate(identifier.expiryDate) : null;
          return {
            clientId: row.id,
            externalId: row.externalId ?? '',
            displayName: row.displayName ?? '',
            mobileNo: row.mobileNo ?? '',
            officeName: row.officeName ?? '',
            status: row.status?.value ?? '',
            identifierStatus: expiryDate ? deriveStatus(expiryDate, businessDate) : null,
            identifierExpiryDate: expiryDate,
          };
        });
        return { total: page.totalFilteredRecords ?? items.length, items };
      } catch (err) {
        throw toApiError(err);
      }
    },

    async getClientDetail(clientId: number): Promise<ClientDetail> {
      try {
        const [rawClientResp, identifiersResp, accounts] = await Promise.all([
          client.clients
            .getClientDetail(clientId)
            .then((resp) => resp.data as unknown as RawClientFull),
          client.clients
            .listClientIdentifiers(clientId)
            .then((resp) => resp.data as unknown as RawIdentifier[])
            .catch(() => [] as RawIdentifier[]),
          client
            .rawGet<RawClientAccounts>(`/bo/api/v1/clients/${clientId}/accounts`)
            .catch(() => null),
        ]);
        if (!rawClientResp?.id) {
          throw new Error(`客户不存在：clientId=${clientId}`);
        }
        const businessDate = await getBusinessDate(client);
        const rawAccounts = accounts?.savingsAccounts ?? [];
        const savings: SavingsAccountSummary[] = [];
        const fixedDeposits: RawSavingsAccount[] = [];
        for (const acct of rawAccounts) {
          if (acct.depositType?.code === FIXED_DEPOSIT_CODE) {
            fixedDeposits.push(acct);
          } else {
            savings.push(mapSavings(acct));
          }
        }
        // 定期账户补齐到期日/利率（/accounts 投影无 maturityDate——FD 详情端点）
        const fdDetails = await Promise.all(
          fixedDeposits.map((fd) =>
            client
              .rawGet<RawFixedDepositDetail>(`/bo/api/v1/fixeddepositaccounts/${fd.id}`)
              .catch(() => null),
          ),
        );
        const firstIdentifier = identifiersResp[0] ?? null;
        // 贷款：首笔账户贷款（active 优先）→ 详情端点补齐逾期分档
        const loanRefs = accounts?.loanAccounts ?? [];
        const loanRef =
          loanRefs.find((a) => a.status?.active === true) ?? loanRefs[0] ?? null;
        let loan: LoanSummary | null = null;
        if (loanRef) {
          const loanDetail = await client.loans
            .getLoan(loanRef.id)
            .then((resp) => resp.data as unknown as RawLoanLike)
            .catch(() => null);
          if (loanDetail) {
            loan = mapLoan(loanDetail, businessDate);
          }
        }
        return {
          clientId: rawClientResp.id,
          externalId: rawClientResp.externalId ?? '',
          displayName: rawClientResp.displayName ?? '',
          mobileNo: rawClientResp.mobileNo ?? '',
          officeName: rawClientResp.officeName ?? '',
          status: rawClientResp.status?.value ?? '',
          identifierStatus: firstIdentifier
            ? deriveStatus(normalizeDate(firstIdentifier.expiryDate) ?? '', businessDate)
            : null,
          identifierExpiryDate: firstIdentifier
            ? normalizeDate(firstIdentifier.expiryDate)
            : null,
          firstname: rawClientResp.firstname ?? '',
          lastname: rawClientResp.lastname ?? '',
          emailAddress: rawClientResp.emailAddress ?? '',
          identifier: firstIdentifier ? mapIdentifier(firstIdentifier, businessDate) : null,
          savingsAccounts: savings,
          fixedDepositAccounts: fixedDeposits.map((fd, i) => ({
            id: fd.id,
            accountNo: fd.accountNo ?? '',
            productName: fd.productName ?? '',
            accountBalance: fd.accountBalance ?? 0,
            interestRate: fdDetails[i]?.nominalAnnualInterestRate ?? 0,
            maturityDate: normalizeDate(fdDetails[i]?.maturityDate) ?? '',
            status: fd.status?.value ?? '',
          })),
          loan,
        };
      } catch (err) {
        if (err instanceof AxiosError && err.response?.status === 404) {
          throw new Error(`客户不存在：clientId=${clientId}`);
        }
        throw toApiError(err);
      }
    },

    async updateClientIdentifier(
      clientId: number,
      identifierId: number,
      payload: IdentifierUpdatePayload,
    ): Promise<ClientIdentifier> {
      try {
        // Fineract PUT 必填参数由本层注入（网关转发面不注入——P2.5 实测口径）
        const wirePayload = {
          expiryDate: payload.expiryDate,
          documentKey: payload.documentKey,
          description: payload.description,
          locale: 'en',
          dateFormat: 'yyyy-MM-dd',
        };
        await client.clients.updateClientIdentifier(
          clientId,
          identifierId,
          wirePayload as IdentifierUpdatePayload,
        );
        // PUT 响应为变更回执——回读证照清单后映射（回显由页面重读详情实现）
        const identifiers = (
          await client.clients.listClientIdentifiers(clientId)
        ).data as unknown as RawIdentifier[];
        const updated =
          identifiers.find((it) => it.id === identifierId) ?? identifiers[0] ?? null;
        if (!updated) {
          throw new Error(`证照不存在：clientId=${clientId} identifierId=${identifierId}`);
        }
        return mapIdentifier(updated, await getBusinessDate(client));
      } catch (err) {
        throw toApiError(err);
      }
    },
  };
}
