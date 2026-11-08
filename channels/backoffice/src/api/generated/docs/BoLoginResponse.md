# BoLoginResponse


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**token** | **string** | JWT 三段式（HS256） | [default to undefined]
**tokenType** | **string** |  | [default to undefined]
**expiresIn** | **number** | token 有效期（秒，默认 900） | [default to undefined]
**channel** | **string** |  | [default to undefined]
**username** | **string** |  | [default to undefined]
**displayName** | **string** |  | [default to undefined]
**role** | **string** | 运营角色（基线单一 ADMIN） | [default to undefined]

## Example

```typescript
import { BoLoginResponse } from './api';

const instance: BoLoginResponse = {
    token,
    tokenType,
    expiresIn,
    channel,
    username,
    displayName,
    role,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
