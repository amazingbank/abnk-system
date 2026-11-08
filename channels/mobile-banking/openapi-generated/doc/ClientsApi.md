# openapi.api.ClientsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getClientDetail**](ClientsApi.md#getclientdetail) | **GET** /bo/api/v1/clients/{id} | 客户详情（基本信息 + 证照 + 账户 + 贷款）
[**getClientIdentifier**](ClientsApi.md#getclientidentifier) | **GET** /bo/api/v1/clients/{id}/identifiers/{identifierId} | 单条证照详情
[**listClientIdentifiers**](ClientsApi.md#listclientidentifiers) | **GET** /bo/api/v1/clients/{id}/identifiers | 客户证照清单
[**listClients**](ClientsApi.md#listclients) | **GET** /bo/api/v1/clients | 客户列表（含证照状态列数据）
[**updateClientIdentifier**](ClientsApi.md#updateclientidentifier) | **PUT** /bo/api/v1/clients/{id}/identifiers/{identifierId} | 更新证照（旅程 Step 7 修复端点——expiryDate 为核心可变更字段）


# **getClientDetail**
> ClientDetail getClientDetail(id)

客户详情（基本信息 + 证照 + 账户 + 贷款）

网关聚合 Fineract `GET /clients/{id}` + `GET /clients/{id}/identifiers` + `GET /clients/{id}/accounts` + 贷款关联（详情页全量形态，Backoffice 消费）。 

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getClientsApi();
final int id = 789; // int | 客户 ID（Fineract client id）

try {
    final response = api.getClientDetail(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ClientsApi->getClientDetail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| 客户 ID（Fineract client id） | 

### Return type

[**ClientDetail**](ClientDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getClientIdentifier**
> ClientIdentifier getClientIdentifier(id, identifierId)

单条证照详情

转发 Fineract `GET /clients/{id}/identifiers/{identifierId}`。

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getClientsApi();
final int id = 789; // int | 客户 ID（Fineract client id）
final int identifierId = 789; // int | 证照 ID（Fineract client identifier id）

try {
    final response = api.getClientIdentifier(id, identifierId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ClientsApi->getClientIdentifier: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| 客户 ID（Fineract client id） | 
 **identifierId** | **int**| 证照 ID（Fineract client identifier id） | 

### Return type

[**ClientIdentifier**](ClientIdentifier.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listClientIdentifiers**
> BuiltList<ClientIdentifier> listClientIdentifiers(id)

客户证照清单

转发 Fineract `GET /clients/{id}/identifiers`（含到期状态推导值）。

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getClientsApi();
final int id = 789; // int | 客户 ID（Fineract client id）

try {
    final response = api.listClientIdentifiers(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ClientsApi->listClientIdentifiers: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| 客户 ID（Fineract client id） | 

### Return type

[**BuiltList&lt;ClientIdentifier&gt;**](ClientIdentifier.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listClients**
> ClientListResult listClients(search, offset, limit)

客户列表（含证照状态列数据）

转发 Fineract `GET /clients`，网关侧聚合每客户首证照的到期状态推导 （expiryDate 对业务日期比较）。`search` 命中姓名 / 外部编号 / 手机号。 

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getClientsApi();
final String search = search_example; // String | 关键词检索（姓名 / 外部编号 / 手机号）
final int offset = 56; // int | 
final int limit = 56; // int | 

try {
    final response = api.listClients(search, offset, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ClientsApi->listClients: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **search** | **String**| 关键词检索（姓名 / 外部编号 / 手机号） | [optional] 
 **offset** | **int**|  | [optional] [default to 0]
 **limit** | **int**|  | [optional] [default to 50]

### Return type

[**ClientListResult**](ClientListResult.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateClientIdentifier**
> ClientIdentifier updateClientIdentifier(id, identifierId, identifierUpdatePayload)

更新证照（旅程 Step 7 修复端点——expiryDate 为核心可变更字段）

转发 Fineract `PUT /clients/{id}/identifiers/{identifierId}` （P0.2 VP0.2.1 实测闭环：expiryDate 2020-01-01 → 2099-12-31 回读一致）。 Fineract 侧要求的 `locale`/`dateFormat` 参数由网关注入，契约面不暴露。 

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getClientsApi();
final int id = 789; // int | 客户 ID（Fineract client id）
final int identifierId = 789; // int | 证照 ID（Fineract client identifier id）
final IdentifierUpdatePayload identifierUpdatePayload = {"expiryDate":"2030-12-31"}; // IdentifierUpdatePayload | 

try {
    final response = api.updateClientIdentifier(id, identifierId, identifierUpdatePayload);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ClientsApi->updateClientIdentifier: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| 客户 ID（Fineract client id） | 
 **identifierId** | **int**| 证照 ID（Fineract client identifier id） | 
 **identifierUpdatePayload** | [**IdentifierUpdatePayload**](IdentifierUpdatePayload.md)|  | 

### Return type

[**ClientIdentifier**](ClientIdentifier.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

