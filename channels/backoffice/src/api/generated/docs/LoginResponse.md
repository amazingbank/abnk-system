# LoginResponse


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**token** | **string** | JWT 三段式（HS256） | [default to undefined]
**tokenType** | **string** |  | [default to undefined]
**expiresIn** | **number** | token 有效期（秒，默认 900） | [default to undefined]
**channel** | **string** |  | [default to undefined]
**username** | **string** |  | [default to undefined]
**displayName** | **string** |  | [default to undefined]
**clientId** | **number** | 映射的种子客户 ID（网关用户表口径，P0.3） | [default to undefined]

## Example

```typescript
import { LoginResponse } from './api';

const instance: LoginResponse = {
    token,
    tokenType,
    expiresIn,
    channel,
    username,
    displayName,
    clientId,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
