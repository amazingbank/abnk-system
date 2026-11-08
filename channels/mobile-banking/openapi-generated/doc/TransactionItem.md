# openapi.model.TransactionItem

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**date** | [**Date**](Date.md) |  | 
**transactionType** | **String** | 交易类型（Deposit / Withdrawal / InterestPosting 等 Fineract 枚举值） | 
**amount** | **num** |  | 
**runningBalance** | **num** | 该笔交易入账后的账户余额 | 
**note** | **String** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


