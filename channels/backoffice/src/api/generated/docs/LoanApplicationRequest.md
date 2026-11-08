# LoanApplicationRequest

贷款申请请求

## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**productId** | **number** |  | [default to undefined]
**principal** | **number** | 申请本金（须在产品 min/max 区间内） | [default to undefined]
**termMonths** | **number** | 期限（月，须与产品期限一致） | [default to undefined]
**purpose** | **string** | 贷款用途（可选） | [optional] [default to undefined]

## Example

```typescript
import { LoanApplicationRequest } from './api';

const instance: LoanApplicationRequest = {
    productId,
    principal,
    termMonths,
    purpose,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
