# IdentifierUpdatePayload

证照更新载荷（P0.2 VP0.2.1 实测口径：expiryDate 为核心可变更字段； Fineract 侧 locale/dateFormat 由网关注入）。 

## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**expiryDate** | **string** | 新到期日（YYYY-MM-DD） | [default to undefined]
**documentKey** | **string** | 证件号（可选——变更时提供） | [optional] [default to undefined]
**description** | **string** |  | [optional] [default to undefined]

## Example

```typescript
import { IdentifierUpdatePayload } from './api';

const instance: IdentifierUpdatePayload = {
    expiryDate,
    documentKey,
    description,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
