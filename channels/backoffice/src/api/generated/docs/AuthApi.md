# AuthApi

All URIs are relative to *http://localhost:8080*

|Method | HTTP request | Description|
|------------- | ------------- | -------------|
|[**boLogin**](#bologin) | **POST** /bo/login | 运营登录（内部通道，签发 JWT）|
|[**login**](#login) | **POST** /login | 客户登录（简化登录，签发 JWT）|

# **boLogin**
> BoLoginResponse boLogin(loginRequest)

凭据校验（PBKDF2，用户表 admin 用户——P0.3 口径）通过后签发 HS256 JWT （claim：`sub`=username（内部通道不依赖 clientId 反查）、`channel`=\"internal\"）。 

### Example

```typescript
import {
    AuthApi,
    Configuration,
    LoginRequest
} from './api';

const configuration = new Configuration();
const apiInstance = new AuthApi(configuration);

let loginRequest: LoginRequest; //

const { status, data } = await apiInstance.boLogin(
    loginRequest
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **loginRequest** | **LoginRequest**|  | |


### Return type

**BoLoginResponse**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
|**200** | 登录成功，返回 token 与运营角色 |  -  |
|**401** | 凭据错误 |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **login**
> LoginResponse login(loginRequest)

凭据校验（PBKDF2，用户表 `data/gateway_users.json`——P0.3 口径）通过后 签发 HS256 JWT（claim：`sub`=clientId、`channel`=\"customer\"）。 mock 阶段演示口令见 `channels/mobile-banking/fixtures/me.json`（原型专用明文）。 

### Example

```typescript
import {
    AuthApi,
    Configuration,
    LoginRequest
} from './api';

const configuration = new Configuration();
const apiInstance = new AuthApi(configuration);

let loginRequest: LoginRequest; //

const { status, data } = await apiInstance.login(
    loginRequest
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **loginRequest** | **LoginRequest**|  | |


### Return type

**LoginResponse**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
|**200** | 登录成功，返回 token 与客户标识 |  -  |
|**401** | 凭据错误 |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

