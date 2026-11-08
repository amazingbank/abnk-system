# TransferRequest

本人账户间转账请求。路径参数 `id` 为转出账户；`externalId` 为客户端幂等键 （重放返回首次结果——P2.4 幂等语义）。 

## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**toAccountId** | **number** | 转入账户（须为本人账户，否则 403） | [default to undefined]
**amount** | **number** | 转账金额（须大于 0） | [default to undefined]
**externalId** | **string** | 幂等键（客户端生成，如 UUID；网关派生 &#x60;&lt;key&gt;-w&#x60;/&#x60;&lt;key&gt;-d&#x60; 落账） | [default to undefined]
**note** | **string** | 附言（可选） | [optional] [default to undefined]

## Example

```typescript
import { TransferRequest } from './api';

const instance: TransferRequest = {
    toAccountId,
    amount,
    externalId,
    note,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
