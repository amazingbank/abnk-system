# openapi.model.LoanApplicationRequest

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**productId** | **int** |  | 
**principal** | **num** | 申请本金（须在产品 min/max 区间内） | 
**termMonths** | **int** | 期限（月，须与产品期限一致） | 
**purpose** | **String** | 贷款用途（可选） | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


