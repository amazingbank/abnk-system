# LoanProduct

消费贷产品（对客收敛字段——隐藏内部配置）

## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **number** |  | [default to undefined]
**name** | **string** |  | [default to undefined]
**description** | **string** |  | [default to undefined]
**interestRate** | **number** | 年利率（%） | [default to undefined]
**termFrequency** | **number** | 期限数值（默认 12） | [default to undefined]
**termPeriodFrequencyType** | **string** |  | [default to undefined]
**minPrincipalAmount** | **number** |  | [default to undefined]
**maxPrincipalAmount** | **number** |  | [default to undefined]
**repaymentMethod** | **string** | 还款方式（等额本息） | [default to undefined]

## Example

```typescript
import { LoanProduct } from './api';

const instance: LoanProduct = {
    id,
    name,
    description,
    interestRate,
    termFrequency,
    termPeriodFrequencyType,
    minPrincipalAmount,
    maxPrincipalAmount,
    repaymentMethod,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
