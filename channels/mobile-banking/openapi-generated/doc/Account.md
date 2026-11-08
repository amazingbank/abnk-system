# openapi.model.Account

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**accountNo** | **String** | 脱敏形态（如 0000**0011） | 
**productName** | **String** |  | 
**accountType** | **String** |  | 
**currency** | **String** |  | 
**accountBalance** | **num** | 账面余额 | 
**availableBalance** | **num** | 可用余额（定期账户支取受限，快照可回退为账面余额） | 
**status** | **String** | 账户状态（ACTIVE 等，透传 Fineract 状态值） | 
**interestRate** | **num** | 年利率（%——仅定期账户） | [optional] 
**maturityDate** | [**Date**](Date.md) | 到期日（仅定期账户；对年对月对日口径） | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


