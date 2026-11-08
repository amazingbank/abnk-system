# TransactionItem

单笔交易明细（P0.2 VP0.2.4 实测字段口径：runningBalance 保留）

## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **number** |  | [default to undefined]
**date** | **string** |  | [default to undefined]
**transactionType** | **string** | 交易类型（Deposit / Withdrawal / InterestPosting 等 Fineract 枚举值） | [default to undefined]
**amount** | **number** |  | [default to undefined]
**runningBalance** | **number** | 该笔交易入账后的账户余额 | [default to undefined]
**note** | **string** |  | [optional] [default to undefined]

## Example

```typescript
import { TransactionItem } from './api';

const instance: TransactionItem = {
    id,
    date,
    transactionType,
    amount,
    runningBalance,
    note,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
