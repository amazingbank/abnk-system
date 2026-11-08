# LoanDetail

贷款详情（对客收敛口径）

## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**loanId** | **number** |  | [default to undefined]
**productName** | **string** |  | [default to undefined]
**principal** | **number** |  | [default to undefined]
**interestRate** | **number** |  | [default to undefined]
**termMonths** | **number** |  | [default to undefined]
**status** | **string** | 贷款状态（Submitted and pending approval / Approved / Active 等 Fineract 状态值） | [default to undefined]
**submittedOnDate** | **string** |  | [default to undefined]
**disbursedOnDate** | **string** | 放款日（未放款为 null） | [optional] [default to undefined]
**totalOutstanding** | **number** | 未偿总额（未放款为 null） | [optional] [default to undefined]

## Example

```typescript
import { LoanDetail } from './api';

const instance: LoanDetail = {
    loanId,
    productName,
    principal,
    interestRate,
    termMonths,
    status,
    submittedOnDate,
    disbursedOnDate,
    totalOutstanding,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
