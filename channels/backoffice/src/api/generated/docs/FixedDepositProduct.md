# FixedDepositProduct

定期存款产品（利率 chart 收敛为单一数值）

## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **number** |  | [default to undefined]
**name** | **string** |  | [default to undefined]
**description** | **string** |  | [default to undefined]
**interestRate** | **number** | 年利率（%） | [default to undefined]
**depositPeriod** | **number** | 存期（月） | [default to undefined]
**minDepositAmount** | **number** | 起存金额 | [default to undefined]

## Example

```typescript
import { FixedDepositProduct } from './api';

const instance: FixedDepositProduct = {
    id,
    name,
    description,
    interestRate,
    depositPeriod,
    minDepositAmount,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
