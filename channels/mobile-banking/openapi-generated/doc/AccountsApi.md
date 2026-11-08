# openapi.api.AccountsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getMyAccounts**](AccountsApi.md#getmyaccounts) | **GET** /abnk/api/v1/me/accounts | 账户总览（活期 + 定期）
[**listAccountTransactions**](AccountsApi.md#listaccounttransactions) | **GET** /abnk/api/v1/accounts/{id}/transactions | 单账户交易明细（含 runningBalance）
[**openFixedDeposit**](AccountsApi.md#openfixeddeposit) | **POST** /abnk/api/v1/savings | 定期开户（从活期账户扣款转入新定期账户）
[**transfer**](AccountsApi.md#transfer) | **POST** /abnk/api/v1/accounts/{id}/transfer | 本人账户间转账（网关聚合，幂等 + 补偿）


# **getMyAccounts**
> AccountSummary getMyAccounts()

账户总览（活期 + 定期）

聚合 Fineract `GET /clients/{id}/accounts`，账号尾号脱敏（`0000**0011`）。 定期账户快照可无 availableBalance（支取受限，回退为账面余额）。 

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAccountsApi();

try {
    final response = api.getMyAccounts();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountsApi->getMyAccounts: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AccountSummary**](AccountSummary.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAccountTransactions**
> BuiltList<TransactionItem> listAccountTransactions(id)

单账户交易明细（含 runningBalance）

转发 Fineract `GET /savingsaccounts/{id}/transactions/search`（P0.2 VP0.2.4 实测：Spring 标准分页 `content`/`total`），item 按契约收敛为 6 字段。 仅本人账户可达（归属校验）。 

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAccountsApi();
final int id = 789; // int | 账户 ID（Fineract savings account id）

try {
    final response = api.listAccountTransactions(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountsApi->listAccountTransactions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| 账户 ID（Fineract savings account id） | 

### Return type

[**BuiltList&lt;TransactionItem&gt;**](TransactionItem.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **openFixedDeposit**
> FixedDepositResult openFixedDeposit(fixedDepositRequest)

定期开户（从活期账户扣款转入新定期账户）

转发 Fineract `POST /fixeddepositaccounts`（P0.2 VP0.2.3 实测链路： 申请→审批→激活由网关侧编排，对客呈现为一次开户动作）。 到期日 = 激活日 + N 个月（对年对月对日，日 Clamp 到月末——P0.2 实测口径）。 

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAccountsApi();
final FixedDepositRequest fixedDepositRequest = {"productId":20,"sourceAccountId":11,"amount":5000}; // FixedDepositRequest | 

try {
    final response = api.openFixedDeposit(fixedDepositRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountsApi->openFixedDeposit: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fixedDepositRequest** | [**FixedDepositRequest**](FixedDepositRequest.md)|  | 

### Return type

[**FixedDepositResult**](FixedDepositResult.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **transfer**
> TransferResult transfer(id, transferRequest)

本人账户间转账（网关聚合，幂等 + 补偿）

Fineract 无满足语义的原生单端点（planning 层 mobile-banking-mvp.md M7 缺口表）， 网关聚合实现：本人账户归属校验 → withdrawal → deposit 两步编排。 **幂等**：`externalId` 为客户端幂等键，重放返回首次结果（缓存未命中时兜底 查 Fineract 派生 externalId `<key>-w`/`<key>-d`——网关重启不破坏幂等）。 **补偿**：第二步失败自动对第一步提交反向冲正（accounting NONE 产品口径， P0.3 种子），冲正失败则 502 + 冲正单号（人工对账口径）。 **基线不做证件校验**（POC 演示增量）。 

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAccountsApi();
final int id = 789; // int | 账户 ID（Fineract savings account id）
final TransferRequest transferRequest = {"toAccountId":12,"amount":2500,"externalId":"T-0001","note":"零钱归集"}; // TransferRequest | 

try {
    final response = api.transfer(id, transferRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountsApi->transfer: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| 账户 ID（Fineract savings account id） | 
 **transferRequest** | [**TransferRequest**](TransferRequest.md)|  | 

### Return type

[**TransferResult**](TransferResult.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

