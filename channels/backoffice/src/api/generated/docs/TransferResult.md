# TransferResult

转账结果（幂等重放返回同值）

## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**transactionId** | **number** | 转出账户流水号（withdrawal 交易 ID） | [default to undefined]
**newSourceBalance** | **number** | 转出账户新余额 | [default to undefined]

## Example

```typescript
import { TransferResult } from './api';

const instance: TransferResult = {
    transactionId,
    newSourceBalance,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
