# MeApi

All URIs are relative to *http://localhost:8080*

|Method | HTTP request | Description|
|------------- | ------------- | -------------|
|[**getMe**](#getme) | **GET** /abnk/api/v1/me | 当前客户资料|
|[**getMyIdentity**](#getmyidentity) | **GET** /abnk/api/v1/me/identity | 当前客户证照信息（只读）|

# **getMe**
> UserProfile getMe()

按 token `sub`（clientId）反查 Fineract `GET /clients/{id}`，字段按契约收敛： 姓名脱敏（姓 + 名首字）、手机号尾号形态（`135******01`）。 

### Example

```typescript
import {
    MeApi,
    Configuration
} from './api';

const configuration = new Configuration();
const apiInstance = new MeApi(configuration);

const { status, data } = await apiInstance.getMe();
```

### Parameters
This endpoint does not have any parameters.


### Return type

**UserProfile**

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
|**200** | 当前客户资料（脱敏口径） |  -  |
|**401** | 未携带 / 无效 token |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMyIdentity**
> IdentityInfo getMyIdentity()

聚合 Fineract `GET /clients/{id}/identifiers`，`status` 为纯读计算值 （expiryDate 对业务日期比较：EXPIRED / EXPIRING_SOON / VALID）。 **基线无任何拦截行为**——证照过期横幅 / 交易拦截为 POC 演示增量。 

### Example

```typescript
import {
    MeApi,
    Configuration
} from './api';

const configuration = new Configuration();
const apiInstance = new MeApi(configuration);

const { status, data } = await apiInstance.getMyIdentity();
```

### Parameters
This endpoint does not have any parameters.


### Return type

**IdentityInfo**

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
|**200** | 证照信息（状态三态 + 有效期） |  -  |
|**401** | 未携带 / 无效 token |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

