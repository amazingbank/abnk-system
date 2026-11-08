# LoansApi

All URIs are relative to *http://localhost:8080*

|Method | HTTP request | Description|
|------------- | ------------- | -------------|
|[**applyLoan**](#applyloan) | **POST** /abnk/api/v1/loans | 提交贷款申请|
|[**executeLoanCommand**](#executeloancommand) | **POST** /bo/api/v1/loans/{id} | 贷款 command 族转发（审批 / 放款）|
|[**getLoan**](#getloan) | **GET** /abnk/api/v1/loans/{id} | 贷款详情（对客收敛口径）|
|[**listFixedDepositProducts**](#listfixeddepositproducts) | **GET** /abnk/api/v1/fixed-deposit-products | 定期存款产品清单（对客收敛字段）|
|[**listLoanProducts**](#listloanproducts) | **GET** /abnk/api/v1/loan-products | 消费贷产品清单（对客收敛字段）|
|[**listLoans**](#listloans) | **GET** /bo/api/v1/loans | 贷款运营列表（只读 + 逾期分档）|

# **applyLoan**
> LoanApplicationResult applyLoan(loanApplicationRequest)

转发 Fineract `POST /loans`（P0.2 VP0.2.2 实测链路），返回申请编号与初始状态 （Submitted and pending approval）；审批/发放为内部通道动作（Backoffice）。 

### Example

```typescript
import {
    LoansApi,
    Configuration,
    LoanApplicationRequest
} from './api';

const configuration = new Configuration();
const apiInstance = new LoansApi(configuration);

let loanApplicationRequest: LoanApplicationRequest; //

const { status, data } = await apiInstance.applyLoan(
    loanApplicationRequest
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **loanApplicationRequest** | **LoanApplicationRequest**|  | |


### Return type

**LoanApplicationResult**

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
|**200** | 申请受理（申请编号 + 初始状态） |  -  |
|**400** | 参数校验失败（金额越界 / 期限不符产品） |  -  |
|**401** | 未携带 / 无效 token |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **executeLoanCommand**
> LoanCommandResult executeLoanCommand(executeLoanCommandRequest)

转发 Fineract `POST /loans/{loanId}?command={command}` （P0.2 VP0.2.2 实测：approve / disburse 双 command 200）。 `command` 为查询参数（Fineract 原生形态，转发保真）；请求体按 command 分形。 Backoffice 基线页面的操作按钮为 disabled（只读），本端点为 POC 演示增量 （现场「审批 + 放款」操作）预埋。 

### Example

```typescript
import {
    LoansApi,
    Configuration,
    ExecuteLoanCommandRequest
} from './api';

const configuration = new Configuration();
const apiInstance = new LoansApi(configuration);

let id: number; //贷款 ID（Fineract loan id） (default to undefined)
let command: 'approve' | 'disburse'; //贷款生命周期命令（Fineract command 转发） (default to undefined)
let executeLoanCommandRequest: ExecuteLoanCommandRequest; //

const { status, data } = await apiInstance.executeLoanCommand(
    id,
    command,
    executeLoanCommandRequest
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **executeLoanCommandRequest** | **ExecuteLoanCommandRequest**|  | |
| **id** | [**number**] | 贷款 ID（Fineract loan id） | defaults to undefined|
| **command** | [**&#39;approve&#39; | &#39;disburse&#39;**]**Array<&#39;approve&#39; &#124; &#39;disburse&#39;>** | 贷款生命周期命令（Fineract command 转发） | defaults to undefined|


### Return type

**LoanCommandResult**

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
|**200** | 命令执行成功（贷款新状态） |  -  |
|**400** | 参数校验失败（状态机不允许该命令 / 日期缺失） |  -  |
|**401** | 未携带 / 无效 token |  -  |
|**403** | 对客 token 不可达内部面（通道隔离） |  -  |
|**404** | 贷款不存在 |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getLoan**
> LoanDetail getLoan()

转发 Fineract `GET /loans/{id}`（P0.2 VP0.2.2 实测：状态对象 + 还款计划）， 按契约收敛为对客字段。仅本人贷款可达（归属校验）。 

### Example

```typescript
import {
    LoansApi,
    Configuration
} from './api';

const configuration = new Configuration();
const apiInstance = new LoansApi(configuration);

let id: number; //贷款 ID（Fineract loan id） (default to undefined)

const { status, data } = await apiInstance.getLoan(
    id
);
```

### Parameters

|Name | Type | Description  | Notes|
|------------- | ------------- | ------------- | -------------|
| **id** | [**number**] | 贷款 ID（Fineract loan id） | defaults to undefined|


### Return type

**LoanDetail**

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
|**200** | 贷款详情 |  -  |
|**401** | 未携带 / 无效 token |  -  |
|**404** | 贷款不存在或不属于当前客户 |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listFixedDepositProducts**
> Array<FixedDepositProduct> listFixedDepositProducts()

转发 Fineract `GET /fixeddepositproducts`，字段按契约收敛 （利率 chart 收敛为单一 interestRate 数值）。 

### Example

```typescript
import {
    LoansApi,
    Configuration
} from './api';

const configuration = new Configuration();
const apiInstance = new LoansApi(configuration);

const { status, data } = await apiInstance.listFixedDepositProducts();
```

### Parameters
This endpoint does not have any parameters.


### Return type

**Array<FixedDepositProduct>**

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
|**200** | 产品清单 |  -  |
|**401** | 未携带 / 无效 token |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listLoanProducts**
> Array<LoanProduct> listLoanProducts()

转发 Fineract `GET /loanproducts`，字段按契约收敛（隐藏内部配置： 会计规则、审批工作流等）。 

### Example

```typescript
import {
    LoansApi,
    Configuration
} from './api';

const configuration = new Configuration();
const apiInstance = new LoansApi(configuration);

const { status, data } = await apiInstance.listLoanProducts();
```

### Parameters
This endpoint does not have any parameters.


### Return type

**Array<LoanProduct>**

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
|**200** | 产品清单 |  -  |
|**401** | 未携带 / 无效 token |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listLoans**
> Array<LoanOpsItem> listLoans()

转发 Fineract `GET /loans`，网关侧聚合客户投影与逾期口径 （overdueDays / totalOverdue / delinquencyClassification——P0.3 客户 C 种子口径）。 基线只读；审批 / 放款操作位为 POC 预埋（command 族端点已契约化）。 

### Example

```typescript
import {
    LoansApi,
    Configuration
} from './api';

const configuration = new Configuration();
const apiInstance = new LoansApi(configuration);

const { status, data } = await apiInstance.listLoans();
```

### Parameters
This endpoint does not have any parameters.


### Return type

**Array<LoanOpsItem>**

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
|**200** | 贷款运营列表 |  -  |
|**401** | 未携带 / 无效 token |  -  |
|**403** | 对客 token 不可达内部面（通道隔离） |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

