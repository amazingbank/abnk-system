# openapi.api.AuthApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**boLogin**](AuthApi.md#bologin) | **POST** /bo/login | 运营登录（内部通道，签发 JWT）
[**login**](AuthApi.md#login) | **POST** /login | 客户登录（简化登录，签发 JWT）


# **boLogin**
> BoLoginResponse boLogin(loginRequest)

运营登录（内部通道，签发 JWT）

凭据校验（PBKDF2，用户表 admin 用户——P0.3 口径）通过后签发 HS256 JWT （claim：`sub`=username（内部通道不依赖 clientId 反查）、`channel`=\"internal\"）。 

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthApi();
final LoginRequest loginRequest = {"username":"admin","password":"password"}; // LoginRequest | 

try {
    final response = api.boLogin(loginRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->boLogin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loginRequest** | [**LoginRequest**](LoginRequest.md)|  | 

### Return type

[**BoLoginResponse**](BoLoginResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **login**
> LoginResponse login(loginRequest)

客户登录（简化登录，签发 JWT）

凭据校验（PBKDF2，用户表 `data/gateway_users.json`——P0.3 口径）通过后 签发 HS256 JWT（claim：`sub`=clientId、`channel`=\"customer\"）。 mock 阶段演示口令见 `channels/mobile-banking/fixtures/me.json`（原型专用明文）。 

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthApi();
final LoginRequest loginRequest = {"username":"alice","password":"password"}; // LoginRequest | 

try {
    final response = api.login(loginRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->login: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loginRequest** | [**LoginRequest**](LoginRequest.md)|  | 

### Return type

[**LoginResponse**](LoginResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

