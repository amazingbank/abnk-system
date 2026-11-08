# ClientDetail

客户详情（详情页全量形态：基本信息 + 证照 + 账户 + 贷款）

## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**clientId** | **number** |  | [default to undefined]
**externalId** | **string** |  | [default to undefined]
**displayName** | **string** |  | [default to undefined]
**mobileNo** | **string** |  | [default to undefined]
**officeName** | **string** |  | [default to undefined]
**status** | **string** |  | [default to undefined]
**identifierStatus** | **string** |  | [optional] [default to undefined]
**identifierExpiryDate** | **string** |  | [optional] [default to undefined]
**firstname** | **string** |  | [default to undefined]
**lastname** | **string** |  | [default to undefined]
**emailAddress** | **string** |  | [default to undefined]
**identifier** | [**ClientIdentifier**](ClientIdentifier.md) | 首证照（无证照为 null） | [optional] [default to undefined]
**savingsAccounts** | [**Array&lt;SavingsAccountSummary&gt;**](SavingsAccountSummary.md) |  | [default to undefined]
**fixedDepositAccounts** | [**Array&lt;FixedDepositSummary&gt;**](FixedDepositSummary.md) |  | [default to undefined]
**loan** | [**LoanSummary**](LoanSummary.md) | 贷款概要（无贷款为 null） | [optional] [default to undefined]

## Example

```typescript
import { ClientDetail } from './api';

const instance: ClientDetail = {
    clientId,
    externalId,
    displayName,
    mobileNo,
    officeName,
    status,
    identifierStatus,
    identifierExpiryDate,
    firstname,
    lastname,
    emailAddress,
    identifier,
    savingsAccounts,
    fixedDepositAccounts,
    loan,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
