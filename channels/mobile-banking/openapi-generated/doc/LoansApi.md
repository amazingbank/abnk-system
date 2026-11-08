# openapi.api.LoansApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**applyLoan**](LoansApi.md#applyloan) | **POST** /abnk/api/v1/loans | 提交贷款申请
[**executeLoanCommand**](LoansApi.md#executeloancommand) | **POST** /bo/api/v1/loans/{id} | 贷款 command 族转发（审批 / 放款）
[**getLoan**](LoansApi.md#getloan) | **GET** /abnk/api/v1/loans/{id} | 贷款详情（对客收敛口径）
[**listFixedDepositProducts**](LoansApi.md#listfixeddepositproducts) | **GET** /abnk/api/v1/fixed-deposit-products | 定期存款产品清单（对客收敛字段）
[**listLoanProducts**](LoansApi.md#listloanproducts) | **GET** /abnk/api/v1/loan-products | 消费贷产品清单（对客收敛字段）
[**listLoans**](LoansApi.md#listloans) | **GET** /bo/api/v1/loans | 贷款运营列表（只读 + 逾期分档）


# **applyLoan**
> LoanApplicationResult applyLoan(loanApplicationRequest)

提交贷款申请

转发 Fineract `POST /loans`（P0.2 VP0.2.2 实测链路），返回申请编号与初始状态 （Submitted and pending approval）；审批/发放为内部通道动作（Backoffice）。 

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getLoansApi();
final LoanApplicationRequest loanApplicationRequest = {"productId":11,"principal":50000,"termMonths":12,"purpose":"装修"}; // LoanApplicationRequest | 

try {
    final response = api.applyLoan(loanApplicationRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling LoansApi->applyLoan: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loanApplicationRequest** | [**LoanApplicationRequest**](LoanApplicationRequest.md)|  | 

### Return type

[**LoanApplicationResult**](LoanApplicationResult.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **executeLoanCommand**
> LoanCommandResult executeLoanCommand(id, command, executeLoanCommandRequest)

贷款 command 族转发（审批 / 放款）

转发 Fineract `POST /loans/{loanId}?command={command}` （P0.2 VP0.2.2 实测：approve / disburse 双 command 200）。 `command` 为查询参数（Fineract 原生形态，转发保真）；请求体按 command 分形。 Backoffice 基线页面的操作按钮为 disabled（只读），本端点为 POC 演示增量 （现场「审批 + 放款」操作）预埋。 

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getLoansApi();
final int id = 789; // int | 贷款 ID（Fineract loan id）
final String command = command_example; // String | 贷款生命周期命令（Fineract command 转发）
final ExecuteLoanCommandRequest executeLoanCommandRequest = {"approvedOnDate":"2026-11-08"}; // ExecuteLoanCommandRequest | 

try {
    final response = api.executeLoanCommand(id, command, executeLoanCommandRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling LoansApi->executeLoanCommand: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| 贷款 ID（Fineract loan id） | 
 **command** | **String**| 贷款生命周期命令（Fineract command 转发） | 
 **executeLoanCommandRequest** | [**ExecuteLoanCommandRequest**](ExecuteLoanCommandRequest.md)|  | 

### Return type

[**LoanCommandResult**](LoanCommandResult.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getLoan**
> LoanDetail getLoan(id)

贷款详情（对客收敛口径）

转发 Fineract `GET /loans/{id}`（P0.2 VP0.2.2 实测：状态对象 + 还款计划）， 按契约收敛为对客字段。仅本人贷款可达（归属校验）。 

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getLoansApi();
final int id = 789; // int | 贷款 ID（Fineract loan id）

try {
    final response = api.getLoan(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling LoansApi->getLoan: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| 贷款 ID（Fineract loan id） | 

### Return type

[**LoanDetail**](LoanDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listFixedDepositProducts**
> BuiltList<FixedDepositProduct> listFixedDepositProducts()

定期存款产品清单（对客收敛字段）

转发 Fineract `GET /fixeddepositproducts`，字段按契约收敛 （利率 chart 收敛为单一 interestRate 数值）。 

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getLoansApi();

try {
    final response = api.listFixedDepositProducts();
    print(response);
} on DioException catch (e) {
    print('Exception when calling LoansApi->listFixedDepositProducts: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;FixedDepositProduct&gt;**](FixedDepositProduct.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listLoanProducts**
> BuiltList<LoanProduct> listLoanProducts()

消费贷产品清单（对客收敛字段）

转发 Fineract `GET /loanproducts`，字段按契约收敛（隐藏内部配置： 会计规则、审批工作流等）。 

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getLoansApi();

try {
    final response = api.listLoanProducts();
    print(response);
} on DioException catch (e) {
    print('Exception when calling LoansApi->listLoanProducts: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;LoanProduct&gt;**](LoanProduct.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listLoans**
> BuiltList<LoanOpsItem> listLoans()

贷款运营列表（只读 + 逾期分档）

转发 Fineract `GET /loans`，网关侧聚合客户投影与逾期口径 （overdueDays / totalOverdue / delinquencyClassification——P0.3 客户 C 种子口径）。 基线只读；审批 / 放款操作位为 POC 预埋（command 族端点已契约化）。 

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getLoansApi();

try {
    final response = api.listLoans();
    print(response);
} on DioException catch (e) {
    print('Exception when calling LoansApi->listLoans: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;LoanOpsItem&gt;**](LoanOpsItem.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

