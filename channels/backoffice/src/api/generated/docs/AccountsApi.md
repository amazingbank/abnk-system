# AccountsApi

All URIs are relative to *http://localhost:8080*

|Method | HTTP request | Description|
|------------- | ------------- | -------------|
|[**getMyAccounts**](#getmyaccounts) | **GET** /abnk/api/v1/me/accounts | 账户总览（活期 + 定期）|
|[**listAccountTransactions**](#listaccounttransactions) | **GET** /abnk/api/v1/accounts/{id}/transactions | 单账户交易明细（含 runningBalance）|
|[**openFixedDeposit**](#openfixeddeposit) | **POST** /abnk/api/v1/savings | 定期开户（从活期账户扣款转入新定期账户）|
|[**transfer**](#transfer) | **POST** /abnk/api/v1/accounts/{id}/transfer | 本人账户间转账（网关聚合，幂等 + 补偿）|

# **getMyAccounts**
> AccountSummary getMyAccounts()

聚合 Fineract `GET /clients/{id}/accounts`，账号尾号脱敏（`0000**0011`）。 定期账户快照可无 availableBalance（支取受限，回退为账面余额）。 

### Example

```typescript
import {
    AccountsApi,
    Configuration
} from './api';

const configuration = new Configuration();
const apiInstance = new AccountsApi(configuration);

const { status, data } = await apiInstance.getMyAccounts();
```

### Parameters
This endpoint does not have any parameters.


### Return type

**AccountSummary**

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
|**200** | 账户总览（按账户类型分组） |  -  |
|**401** | 未携带 / 无效 token |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAccountTransactions**
> Array<TransactionItem> listAccountTransactions()

转发 Fineract `GET /savingsaccounts/{id}/transactions/search`（P0.2 VP0.2.4 实测：Spring 标准分页 `content`/`total`），item 按契约收敛为 6 字段。 仅本人账户可达（归属校验）。 

### Example

```typescript
import {
    AccountsApi,
    Configuration
} from './api';

const configuration = new Configuration();
const apiInstance = new AccountsApi(configuration);

let id: number; //账户 ID（Fineract savings account id） (default to undefined)

const { status, data } = await apiInstance.listAccountTransactions(
    id
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **id** | [**number**] | 账户 ID（Fineract savings account id） | defaults to undefined|


### Return type

**Array<TransactionItem>**

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
|**200** | 交易明细列表（新→旧） |  -  |
|**401** | 未携带 / 无效 token |  -  |
|**404** | 账户不存在或不属于当前客户 |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **openFixedDeposit**
> FixedDepositResult openFixedDeposit(fixedDepositRequest)

转发 Fineract `POST /fixeddepositaccounts`（P0.2 VP0.2.3 实测链路： 申请→审批→激活由网关侧编排，对客呈现为一次开户动作）。 到期日 = 激活日 + N 个月（对年对月对日，日 Clamp 到月末——P0.2 实测口径）。 

### Example

```typescript
import {
    AccountsApi,
    Configuration,
    FixedDepositRequest
} from './api';

const configuration = new Configuration();
const apiInstance = new AccountsApi(configuration);

let fixedDepositRequest: FixedDepositRequest; //

const { status, data } = await apiInstance.openFixedDeposit(
    fixedDepositRequest
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **fixedDepositRequest** | **FixedDepositRequest**|  | |


### Return type

**FixedDepositResult**

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
|**200** | 开户成功（新账户号 + 到期日） |  -  |
|**400** | 参数校验失败（金额非正 / 低于起存金额 / 余额不足） |  -  |
|**401** | 未携带 / 无效 token |  -  |
|**404** | 定期产品或源账户不存在 |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **transfer**
> TransferResult transfer(transferRequest)

Fineract 无满足语义的原生单端点（planning 层 mobile-banking-mvp.md M7 缺口表）， 网关聚合实现：本人账户归属校验 → withdrawal → deposit 两步编排。 **幂等**：`externalId` 为客户端幂等键，重放返回首次结果（缓存未命中时兜底 查 Fineract 派生 externalId `<key>-w`/`<key>-d`——网关重启不破坏幂等）。 **补偿**：第二步失败自动对第一步提交反向冲正（accounting NONE 产品口径， P0.3 种子），冲正失败则 502 + 冲正单号（人工对账口径）。 **基线不做证件校验**（POC 演示增量）。 

### Example

```typescript
import {
    AccountsApi,
    Configuration,
    TransferRequest
} from './api';

const configuration = new Configuration();
const apiInstance = new AccountsApi(configuration);

let id: number; //账户 ID（Fineract savings account id） (default to undefined)
let transferRequest: TransferRequest; //

const { status, data } = await apiInstance.transfer(
    id,
    transferRequest
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **transferRequest** | **TransferRequest**|  | |
| **id** | [**number**] | 账户 ID（Fineract savings account id） | defaults to undefined|


### Return type

**TransferResult**

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
|**200** | 转账成功（幂等重放同结果） |  -  |
|**400** | 参数校验失败（金额非正 / 账户相同 / 余额不足） |  -  |
|**401** | 未携带 / 无效 token |  -  |
|**403** | 目标账户不属于当前客户（本人账户约束） |  -  |
|**404** | 账户不存在 |  -  |
|**502** | 下游失败且补偿冲正已提交（含冲正单号，人工对账口径） |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

