# Account

账户（活期 / 定期统一形态；账号尾号脱敏）

## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **number** |  | [default to undefined]
**accountNo** | **string** | 脱敏形态（如 0000**0011） | [default to undefined]
**productName** | **string** |  | [default to undefined]
**accountType** | **string** |  | [default to undefined]
**currency** | **string** |  | [default to undefined]
**accountBalance** | **number** | 账面余额 | [default to undefined]
**availableBalance** | **number** | 可用余额（定期账户支取受限，快照可回退为账面余额） | [default to undefined]
**status** | **string** | 账户状态（ACTIVE 等，透传 Fineract 状态值） | [default to undefined]
**interestRate** | **number** | 年利率（%——仅定期账户） | [optional] [default to undefined]
**maturityDate** | **string** | 到期日（仅定期账户；对年对月对日口径） | [optional] [default to undefined]

## Example

```typescript
import { Account } from './api';

const instance: Account = {
    id,
    accountNo,
    productName,
    accountType,
    currency,
    accountBalance,
    availableBalance,
    status,
    interestRate,
    maturityDate,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
