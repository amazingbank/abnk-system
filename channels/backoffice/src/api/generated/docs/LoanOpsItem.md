# LoanOpsItem

贷款运营列表行（LoanSummary + 客户投影）

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
**clientId** | **number** |  | [default to undefined]
**clientName** | **string** |  | [default to undefined]

## Example

```typescript
import { LoanOpsItem } from './api';

const instance: LoanOpsItem = {
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
    clientId,
    clientName,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
