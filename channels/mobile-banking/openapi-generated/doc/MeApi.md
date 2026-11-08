# openapi.api.MeApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getMe**](MeApi.md#getme) | **GET** /abnk/api/v1/me | 当前客户资料
[**getMyIdentity**](MeApi.md#getmyidentity) | **GET** /abnk/api/v1/me/identity | 当前客户证照信息（只读）


# **getMe**
> UserProfile getMe()

当前客户资料

按 token `sub`（clientId）反查 Fineract `GET /clients/{id}`，字段按契约收敛： 姓名脱敏（姓 + 名首字）、手机号尾号形态（`135******01`）。 

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getMeApi();

try {
    final response = api.getMe();
    print(response);
} on DioException catch (e) {
    print('Exception when calling MeApi->getMe: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserProfile**](UserProfile.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMyIdentity**
> IdentityInfo getMyIdentity()

当前客户证照信息（只读）

聚合 Fineract `GET /clients/{id}/identifiers`，`status` 为纯读计算值 （expiryDate 对业务日期比较：EXPIRED / EXPIRING_SOON / VALID）。 **基线无任何拦截行为**——证照过期横幅 / 交易拦截为 POC 演示增量。 

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getMeApi();

try {
    final response = api.getMyIdentity();
    print(response);
} on DioException catch (e) {
    print('Exception when calling MeApi->getMyIdentity: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**IdentityInfo**](IdentityInfo.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

