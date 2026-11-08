# UserProfile

当前客户资料（脱敏口径：姓名姓+首字、手机号尾号形态）

## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**clientId** | **number** |  | [default to undefined]
**externalId** | **string** |  | [default to undefined]
**firstname** | **string** |  | [default to undefined]
**lastname** | **string** |  | [default to undefined]
**displayName** | **string** |  | [default to undefined]
**mobileNo** | **string** | 脱敏形态（如 135******01） | [default to undefined]
**emailAddress** | **string** |  | [default to undefined]
**officeName** | **string** |  | [default to undefined]

## Example

```typescript
import { UserProfile } from './api';

const instance: UserProfile = {
    clientId,
    externalId,
    firstname,
    lastname,
    displayName,
    mobileNo,
    emailAddress,
    officeName,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
