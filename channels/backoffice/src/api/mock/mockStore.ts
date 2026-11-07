/**
 * mock 数据存储（任务 P1.4）——P1.3 fixtures 同口径：JSON 资产 +
 * 运行时可变内存副本。mock 提交（证照编辑）只改内存态，刷新页面还原。
 */

import type { ClientDetail } from '../repositories/clientRepository';
import rawClients from './mockData/clients.json';

interface ClientsFile {
  _source: string;
  businessDate: string;
  clients: ClientDetail[];
}

/** mock 数据快照（只读源） */
export const clientsFile = rawClients as unknown as ClientsFile;

/** 业务日期（P0.3 种子推进后的时点，用于到期状态推导） */
export const businessDate = clientsFile.businessDate;

/** 运行时可变副本（mock 编辑回显的载体） */
export const clientStore: ClientDetail[] = structuredClone(clientsFile.clients);

/** mock 模拟网络延迟 */
export function delay(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

/** 到期状态推导：expiryDate 对业务日期比较（ISO 日期字符串字典序即时间序） */
export function deriveStatus(
  expiryDate: string,
  reference: string = businessDate,
): 'VALID' | 'EXPIRED' {
  return expiryDate < reference ? 'EXPIRED' : 'VALID';
}
