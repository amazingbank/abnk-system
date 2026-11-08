# ClientIdentifier

客户证照（对齐 Fineract client identifiers 结构 + 到期状态推导）

## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**identifierId** | **number** |  | [default to undefined]
**documentTypeId** | **number** |  | [default to undefined]
**documentTypeName** | **string** |  | [default to undefined]
**documentKey** | **string** | 证件号 | [default to undefined]
**status** | **string** | Fineract 记录状态 | [default to undefined]
**derivedStatus** | **string** | 到期状态推导值（expiryDate 对业务日期比较） | [default to undefined]
**issuanceDate** | **string** |  | [default to undefined]
**expiryDate** | **string** |  | [default to undefined]
**description** | **string** |  | [optional] [default to undefined]

## Example

```typescript
import { ClientIdentifier } from './api';

const instance: ClientIdentifier = {
    identifierId,
    documentTypeId,
    documentTypeName,
    documentKey,
    status,
    derivedStatus,
    issuanceDate,
    expiryDate,
    description,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
