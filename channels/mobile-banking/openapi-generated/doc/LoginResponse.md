# openapi.model.LoginResponse

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**token** | **String** | JWT 三段式（HS256） | 
**tokenType** | **String** |  | 
**expiresIn** | **int** | token 有效期（秒，默认 900） | 
**channel** | **String** |  | 
**username** | **String** |  | 
**displayName** | **String** |  | 
**clientId** | **int** | 映射的种子客户 ID（网关用户表口径，P0.3） | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


