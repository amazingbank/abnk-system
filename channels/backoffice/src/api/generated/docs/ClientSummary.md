# ClientSummary

客户列表行（列表页最小投影 + 证照状态列）

## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**clientId** | **number** |  | [default to undefined]
**externalId** | **string** |  | [default to undefined]
**displayName** | **string** |  | [default to undefined]
**mobileNo** | **string** |  | [default to undefined]
**officeName** | **string** |  | [default to undefined]
**status** | **string** | 客户状态（Active 等 Fineract 状态值） | [default to undefined]
**identifierStatus** | **string** | 首证照到期状态推导值（无证照为 null） | [optional] [default to undefined]
**identifierExpiryDate** | **string** | 首证照到期日（无证照为 null） | [optional] [default to undefined]

## Example

```typescript
import { ClientSummary } from './api';

const instance: ClientSummary = {
    clientId,
    externalId,
    displayName,
    mobileNo,
    officeName,
    status,
    identifierStatus,
    identifierExpiryDate,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
