# openapi.model.LoanDetail

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**loanId** | **int** |  | 
**productName** | **String** |  | 
**principal** | **num** |  | 
**interestRate** | **num** |  | 
**termMonths** | **int** |  | 
**status** | **String** | 贷款状态（Submitted and pending approval / Approved / Active 等 Fineract 状态值） | 
**submittedOnDate** | [**Date**](Date.md) |  | 
**disbursedOnDate** | [**Date**](Date.md) | 放款日（未放款为 null） | [optional] 
**totalOutstanding** | **num** | 未偿总额（未放款为 null） | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


