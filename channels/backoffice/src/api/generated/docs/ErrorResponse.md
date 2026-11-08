# ErrorResponse

统一错误载荷

## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**status** | **number** | HTTP 状态码 | [default to undefined]
**error** | **string** | 错误类别（Unauthorized / Forbidden / Not Found / Bad Request / Bad Gateway） | [default to undefined]
**message** | **string** | 人类可读错误信息（中文，对客展示口径） | [default to undefined]

## Example

```typescript
import { ErrorResponse } from './api';

const instance: ErrorResponse = {
    status,
    error,
    message,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
