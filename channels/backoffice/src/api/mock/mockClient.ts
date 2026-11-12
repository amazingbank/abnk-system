/**
 * ClientRepository 的 mock 实现（任务 P1.4）——数据来自
 * `mockData/clients.json`（P0.3 种子快照口径），模拟网络延迟；
 * 证照更新改内存副本并推导到期状态（回显由页面重读详情实现）。
 */

import { ApiError, ERR } from '../errors';
import type {
  ClientRepository,
  ClientListQuery,
  ClientListResult,
  ClientSummary,
  ClientDetail,
  ClientIdentifier,
  IdentifierUpdatePayload,
} from '../repositories/clientRepository';
import { clientStore, delay, deriveStatus } from './mockStore';

function summaryOf(client: ClientDetail): ClientSummary {
  return {
    clientId: client.clientId,
    externalId: client.externalId,
    displayName: client.displayName,
    mobileNo: client.mobileNo,
    officeName: client.officeName,
    status: client.status,
    identifierStatus: client.identifier?.derivedStatus ?? null,
    identifierExpiryDate: client.identifier?.expiryDate ?? null,
  };
}

export const mockClientRepository: ClientRepository = {
  async listClients(query: ClientListQuery = {}): Promise<ClientListResult> {
    await delay(300);
    const keyword = query.search?.trim();
    const matched = keyword
      ? clientStore.filter((c) =>
          [c.displayName, c.externalId, c.mobileNo].some((field) => field.includes(keyword)),
        )
      : clientStore;
    const items = matched.map(summaryOf);
    return { total: items.length, items };
  },

  async getClientDetail(clientId: number): Promise<ClientDetail> {
    await delay(300);
    const found = clientStore.find((c) => c.clientId === clientId);
    if (!found) {
      // 错误码化：clientId 经 {clientId} 插值，文案由 UI 层翻译（任务 2.1）。
      // Error-coded: clientId interpolates via {clientId}; text is translated
      // by the UI layer (task 2.1).
      throw new ApiError(ERR.client.notFound, { clientId });
    }
    return structuredClone(found);
  },

  async updateClientIdentifier(
    clientId: number,
    identifierId: number,
    payload: IdentifierUpdatePayload,
  ): Promise<ClientIdentifier> {
    await delay(400);
    const client = clientStore.find((c) => c.clientId === clientId);
    const identifier = client?.identifier;
    if (!client || !identifier || identifier.identifierId !== identifierId) {
      // 错误码化：双参数插值，文案由 UI 层翻译（任务 2.1）。
      // Error-coded: dual-param interpolation; text is translated by the
      // UI layer (task 2.1).
      throw new ApiError(ERR.client.identifierNotFound, { clientId, identifierId });
    }
    identifier.expiryDate = payload.expiryDate;
    if (payload.documentKey) {
      identifier.documentKey = payload.documentKey;
    }
    if (payload.description) {
      identifier.description = payload.description;
    }
    identifier.derivedStatus = deriveStatus(identifier.expiryDate);
    return structuredClone(identifier);
  },
};
