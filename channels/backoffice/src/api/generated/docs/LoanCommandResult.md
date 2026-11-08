# LoanCommandResult

贷款命令执行结果（网关收敛口径）

## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**loanId** | **number** |  | [default to undefined]
**status** | **string** | 命令执行后的贷款状态（Approved / Active 等） | [default to undefined]
**processedOnDate** | **string** | 命令生效日（审批日 / 放款日） | [optional] [default to undefined]

## Example

```typescript
import { LoanCommandResult } from './api';

const instance: LoanCommandResult = {
    loanId,
    status,
    processedOnDate,
};
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
