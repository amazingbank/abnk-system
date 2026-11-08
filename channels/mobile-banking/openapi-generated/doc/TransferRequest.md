# openapi.model.TransferRequest

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**toAccountId** | **int** | 转入账户（须为本人账户，否则 403） | 
**amount** | **num** | 转账金额（须大于 0） | 
**externalId** | **String** | 幂等键（客户端生成，如 UUID；网关派生 `<key>-w`/`<key>-d` 落账） | 
**note** | **String** | 附言（可选） | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


