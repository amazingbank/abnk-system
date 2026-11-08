# LoanSummary

贷款概要（含逾期分档——P0.3 客户 C 口径）

## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**loanId** | **number** |  | [default to undefined]
**externalId** | **string** |  | [default to undefined]
**productName** | **string** |  | [default to undefined]
**principal** | **number** |  | [default to undefined]
**interestRate** | **number** |  | [default to undefined]
**termMonths** | **number** |  | [default to undefined]
**status** | **string** |  | [default to undefined]
**inArrears** | **boolean** |  | [default to undefined]
**overdueDays** | **number** | 逾期天数（无逾期为 0） | [default to undefined]
**overdueSinceDate** | **string** | 逾期起始日（无逾期为 null） | [optional] [default to undefined]
**totalOverdue** | **number** | 逾期总额（无逾期为 0） | [default to undefined]
**delinquencyClassification** | **string** | 逾期分档（ABNK_POC_OD 等 P0.3 分档口径；无逾期为 null） | [optional] [default to undefined]

## Example

```typescript
import { LoanSummary } from './api';

const instance: LoanSummary = {
    loanId,
    externalId,
    productName,
    principal,
    interestRate,
    termMonths,
    status,
    inArrears,
    overdueDays,
    overdueSinceDate,
    totalOverdue,
    delinquencyClassification,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
