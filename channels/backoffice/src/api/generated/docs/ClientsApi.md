# ClientsApi

All URIs are relative to *http://localhost:8080*

|Method | HTTP request | Description|
|------------- | ------------- | -------------|
|[**getClientDetail**](#getclientdetail) | **GET** /bo/api/v1/clients/{id} | 客户详情（基本信息 + 证照 + 账户 + 贷款）|
|[**getClientIdentifier**](#getclientidentifier) | **GET** /bo/api/v1/clients/{id}/identifiers/{identifierId} | 单条证照详情|
|[**listClientIdentifiers**](#listclientidentifiers) | **GET** /bo/api/v1/clients/{id}/identifiers | 客户证照清单|
|[**listClients**](#listclients) | **GET** /bo/api/v1/clients | 客户列表（含证照状态列数据）|
|[**updateClientIdentifier**](#updateclientidentifier) | **PUT** /bo/api/v1/clients/{id}/identifiers/{identifierId} | 更新证照（旅程 Step 7 修复端点——expiryDate 为核心可变更字段）|

# **getClientDetail**
> ClientDetail getClientDetail()

网关聚合 Fineract `GET /clients/{id}` + `GET /clients/{id}/identifiers` + `GET /clients/{id}/accounts` + 贷款关联（详情页全量形态，Backoffice 消费）。 

### Example

```typescript
import {
    ClientsApi,
    Configuration
} from './api';

const configuration = new Configuration();
const apiInstance = new ClientsApi(configuration);

let id: number; //客户 ID（Fineract client id） (default to undefined)

const { status, data } = await apiInstance.getClientDetail(
    id
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **id** | [**number**] | 客户 ID（Fineract client id） | defaults to undefined|


### Return type

**ClientDetail**

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
|**200** | 客户详情 |  -  |
|**401** | 未携带 / 无效 token |  -  |
|**403** | 对客 token 不可达内部面（通道隔离） |  -  |
|**404** | 客户不存在 |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getClientIdentifier**
> ClientIdentifier getClientIdentifier()

转发 Fineract `GET /clients/{id}/identifiers/{identifierId}`。

### Example

```typescript
import {
    ClientsApi,
    Configuration
} from './api';

const configuration = new Configuration();
const apiInstance = new ClientsApi(configuration);

let id: number; //客户 ID（Fineract client id） (default to undefined)
let identifierId: number; //证照 ID（Fineract client identifier id） (default to undefined)

const { status, data } = await apiInstance.getClientIdentifier(
    id,
    identifierId
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **id** | [**number**] | 客户 ID（Fineract client id） | defaults to undefined|
| **identifierId** | [**number**] | 证照 ID（Fineract client identifier id） | defaults to undefined|


### Return type

**ClientIdentifier**

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
|**200** | 证照详情 |  -  |
|**401** | 未携带 / 无效 token |  -  |
|**403** | 对客 token 不可达内部面（通道隔离） |  -  |
|**404** | 证照不存在 |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listClientIdentifiers**
> Array<ClientIdentifier> listClientIdentifiers()

转发 Fineract `GET /clients/{id}/identifiers`（含到期状态推导值）。

### Example

```typescript
import {
    ClientsApi,
    Configuration
} from './api';

const configuration = new Configuration();
const apiInstance = new ClientsApi(configuration);

let id: number; //客户 ID（Fineract client id） (default to undefined)

const { status, data } = await apiInstance.listClientIdentifiers(
    id
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **id** | [**number**] | 客户 ID（Fineract client id） | defaults to undefined|


### Return type

**Array<ClientIdentifier>**

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
|**200** | 证照清单 |  -  |
|**401** | 未携带 / 无效 token |  -  |
|**403** | 对客 token 不可达内部面（通道隔离） |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listClients**
> ClientListResult listClients()

转发 Fineract `GET /clients`，网关侧聚合每客户首证照的到期状态推导 （expiryDate 对业务日期比较）。`search` 命中姓名 / 外部编号 / 手机号。 

### Example

```typescript
import {
    ClientsApi,
    Configuration
} from './api';

const configuration = new Configuration();
const apiInstance = new ClientsApi(configuration);

let search: string; //关键词检索（姓名 / 外部编号 / 手机号） (optional) (default to undefined)
let offset: number; // (optional) (default to 0)
let limit: number; // (optional) (default to 50)

const { status, data } = await apiInstance.listClients(
    search,
    offset,
    limit
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **search** | [**string**] | 关键词检索（姓名 / 外部编号 / 手机号） | (optional) defaults to undefined|
| **offset** | [**number**] |  | (optional) defaults to 0|
| **limit** | [**number**] |  | (optional) defaults to 50|


### Return type

**ClientListResult**

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
|**200** | 客户列表（列表页最小投影 + 证照状态列） |  -  |
|**401** | 未携带 / 无效 token |  -  |
|**403** | 对客 token 不可达内部面（通道隔离） |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateClientIdentifier**
> ClientIdentifier updateClientIdentifier(identifierUpdatePayload)

转发 Fineract `PUT /clients/{id}/identifiers/{identifierId}` （P0.2 VP0.2.1 实测闭环：expiryDate 2020-01-01 → 2099-12-31 回读一致）。 Fineract 侧要求的 `locale`/`dateFormat` 参数由网关注入，契约面不暴露。 

### Example

```typescript
import {
    ClientsApi,
    Configuration,
    IdentifierUpdatePayload
} from './api';

const configuration = new Configuration();
const apiInstance = new ClientsApi(configuration);

let id: number; //客户 ID（Fineract client id） (default to undefined)
let identifierId: number; //证照 ID（Fineract client identifier id） (default to undefined)
let identifierUpdatePayload: IdentifierUpdatePayload; //

const { status, data } = await apiInstance.updateClientIdentifier(
    id,
    identifierId,
    identifierUpdatePayload
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **identifierUpdatePayload** | **IdentifierUpdatePayload**|  | |
| **id** | [**number**] | 客户 ID（Fineract client id） | defaults to undefined|
| **identifierId** | [**number**] | 证照 ID（Fineract client identifier id） | defaults to undefined|


### Return type

**ClientIdentifier**

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
|**200** | 更新成功（返回更新后全量证照） |  -  |
|**400** | 参数校验失败（expiryDate 缺失 / 日期格式错误） |  -  |
|**401** | 未携带 / 无效 token |  -  |
|**403** | 对客 token 不可达内部面（通道隔离） |  -  |
|**404** | 证照不存在 |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

