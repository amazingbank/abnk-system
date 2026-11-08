# LoginRequest


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**username** | **string** |  | [default to undefined]
**password** | **string** | 口令明文（仅请求方向；服务端 PBKDF2 校验，不落日志） | [default to undefined]

## Example

```typescript
import { LoginRequest } from './api';

const instance: LoginRequest = {
    username,
    password,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
