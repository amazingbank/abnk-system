//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:openapi/src/date_serializer.dart';
import 'package:openapi/src/model/date.dart';

import 'package:openapi/src/model/account.dart';
import 'package:openapi/src/model/account_summary.dart';
import 'package:openapi/src/model/bo_login_response.dart';
import 'package:openapi/src/model/client_detail.dart';
import 'package:openapi/src/model/client_identifier.dart';
import 'package:openapi/src/model/client_list_result.dart';
import 'package:openapi/src/model/client_summary.dart';
import 'package:openapi/src/model/error_response.dart';
import 'package:openapi/src/model/execute_loan_command_request.dart';
import 'package:openapi/src/model/fixed_deposit_product.dart';
import 'package:openapi/src/model/fixed_deposit_request.dart';
import 'package:openapi/src/model/fixed_deposit_result.dart';
import 'package:openapi/src/model/fixed_deposit_summary.dart';
import 'package:openapi/src/model/identifier_update_payload.dart';
import 'package:openapi/src/model/identity_info.dart';
import 'package:openapi/src/model/loan_application_request.dart';
import 'package:openapi/src/model/loan_application_result.dart';
import 'package:openapi/src/model/loan_approve_request.dart';
import 'package:openapi/src/model/loan_command_result.dart';
import 'package:openapi/src/model/loan_detail.dart';
import 'package:openapi/src/model/loan_disburse_request.dart';
import 'package:openapi/src/model/loan_ops_item.dart';
import 'package:openapi/src/model/loan_product.dart';
import 'package:openapi/src/model/loan_summary.dart';
import 'package:openapi/src/model/login_request.dart';
import 'package:openapi/src/model/login_response.dart';
import 'package:openapi/src/model/savings_account_summary.dart';
import 'package:openapi/src/model/transaction_item.dart';
import 'package:openapi/src/model/transfer_request.dart';
import 'package:openapi/src/model/transfer_result.dart';
import 'package:openapi/src/model/user_profile.dart';

part 'serializers.g.dart';

@SerializersFor([
  Account,
  AccountSummary,
  BoLoginResponse,
  ClientDetail,
  ClientIdentifier,
  ClientListResult,
  ClientSummary,
  ErrorResponse,
  ExecuteLoanCommandRequest,
  FixedDepositProduct,
  FixedDepositRequest,
  FixedDepositResult,
  FixedDepositSummary,
  IdentifierUpdatePayload,
  IdentityInfo,
  LoanApplicationRequest,
  LoanApplicationResult,
  LoanApproveRequest,
  LoanCommandResult,
  LoanDetail,
  LoanDisburseRequest,
  LoanOpsItem,
  LoanProduct,
  LoanSummary,$LoanSummary,
  LoginRequest,
  LoginResponse,
  SavingsAccountSummary,
  TransactionItem,
  TransferRequest,
  TransferResult,
  UserProfile,
])
Serializers serializers = (_$serializers.toBuilder()
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(LoanOpsItem)]),
        () => ListBuilder<LoanOpsItem>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(SavingsAccountSummary)]),
        () => ListBuilder<SavingsAccountSummary>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(LoanProduct)]),
        () => ListBuilder<LoanProduct>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(TransactionItem)]),
        () => ListBuilder<TransactionItem>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(FixedDepositProduct)]),
        () => ListBuilder<FixedDepositProduct>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ClientIdentifier)]),
        () => ListBuilder<ClientIdentifier>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(FixedDepositSummary)]),
        () => ListBuilder<FixedDepositSummary>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ClientSummary)]),
        () => ListBuilder<ClientSummary>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Account)]),
        () => ListBuilder<Account>(),
      )
      ..add(LoanSummary.serializer)
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer())
    ).build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
