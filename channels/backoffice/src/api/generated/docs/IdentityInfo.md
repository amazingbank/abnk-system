# IdentityInfo

客户证照信息（只读；status 为到期状态推导值——纯读计算无拦截）

## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**documentTypeId** | **number** |  | [default to undefined]
**documentTypeName** | **string** |  | [default to undefined]
**documentKey** | **string** | 证件号（脱敏形态，如 3301**********001X） | [default to undefined]
**status** | **string** | 到期状态三态（expiryDate 对业务日期比较推导） | [default to undefined]
**issuanceDate** | **string** |  | [default to undefined]
**expiryDate** | **string** |  | [default to undefined]

## Example

```typescript
import { IdentityInfo } from './api';

const instance: IdentityInfo = {
    documentTypeId,
    documentTypeName,
    documentKey,
    status,
    issuanceDate,
    expiryDate,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
