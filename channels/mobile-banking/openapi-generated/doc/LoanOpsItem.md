# openapi.model.LoanOpsItem

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**loanId** | **int** |  | 
**externalId** | **String** |  | 
**productName** | **String** |  | 
**principal** | **num** |  | 
**interestRate** | **num** |  | 
**termMonths** | **int** |  | 
**status** | **String** |  | 
**inArrears** | **bool** |  | 
**overdueDays** | **int** | 逾期天数（无逾期为 0） | 
**overdueSinceDate** | [**Date**](Date.md) | 逾期起始日（无逾期为 null） | [optional] 
**totalOverdue** | **num** | 逾期总额（无逾期为 0） | 
**delinquencyClassification** | **String** | 逾期分档（ABNK_POC_OD 等 P0.3 分档口径；无逾期为 null） | [optional] 
**clientId** | **int** |  | 
**clientName** | **String** |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


