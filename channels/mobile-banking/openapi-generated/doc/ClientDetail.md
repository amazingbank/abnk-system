# openapi.model.ClientDetail

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**clientId** | **int** |  | 
**externalId** | **String** |  | 
**displayName** | **String** |  | 
**mobileNo** | **String** |  | 
**officeName** | **String** |  | 
**status** | **String** |  | 
**identifierStatus** | **String** |  | [optional] 
**identifierExpiryDate** | [**Date**](Date.md) |  | [optional] 
**firstname** | **String** |  | 
**lastname** | **String** |  | 
**emailAddress** | **String** |  | 
**identifier** | [**ClientIdentifier**](ClientIdentifier.md) | 首证照（无证照为 null） | [optional] 
**savingsAccounts** | [**BuiltList&lt;SavingsAccountSummary&gt;**](SavingsAccountSummary.md) |  | 
**fixedDepositAccounts** | [**BuiltList&lt;FixedDepositSummary&gt;**](FixedDepositSummary.md) |  | 
**loan** | [**LoanSummary**](LoanSummary.md) | 贷款概要（无贷款为 null） | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


