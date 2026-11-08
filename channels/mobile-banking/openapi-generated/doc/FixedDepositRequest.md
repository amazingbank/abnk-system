# openapi.model.FixedDepositRequest

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**productId** | **int** | 定期存款产品 ID | 
**sourceAccountId** | **int** | 扣款源活期账户（须为本人账户） | 
**amount** | **num** | 存入金额（须 ≥ 产品起存金额且 ≤ 源账户可用余额） | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


