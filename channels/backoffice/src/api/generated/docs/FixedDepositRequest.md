# FixedDepositRequest

定期开户请求（从源活期账户扣款转入新定期账户）

## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**productId** | **number** | 定期存款产品 ID | [default to undefined]
**sourceAccountId** | **number** | 扣款源活期账户（须为本人账户） | [default to undefined]
**amount** | **number** | 存入金额（须 ≥ 产品起存金额且 ≤ 源账户可用余额） | [default to undefined]

## Example

```typescript
import { FixedDepositRequest } from './api';

const instance: FixedDepositRequest = {
    productId,
    sourceAccountId,
    amount,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
