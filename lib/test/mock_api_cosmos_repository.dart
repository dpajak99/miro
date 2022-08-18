import 'package:dio/dio.dart';
import 'package:miro/infra/dto/api_cosmos/broadcast/request/broadcast_req.dart';
import 'package:miro/infra/dto/api_cosmos/query_account/request/query_account_req.dart';
import 'package:miro/infra/dto/api_cosmos/query_balance/request/query_balance_req.dart';
import 'package:miro/infra/repositories/api_cosmos_repository.dart';
import 'package:miro/test/mocks/api_cosmos/mock_api_cosmos_auth_accounts.dart';
import 'package:miro/test/mocks/api_cosmos/mock_api_cosmos_bank_balances.dart';
import 'package:miro/test/mocks/api_cosmos/mock_api_cosmos_txs.dart';

class MockApiCosmosRepository implements ApiCosmosRepository {
  static List<String> workingEndpoints = <String>['unhealthy.kira.network', 'healthy.kira.network'];

  @override
  Future<Response<T>> broadcast<T>(Uri networkUri, BroadcastReq request) async {
    bool hasResponse = workingEndpoints.contains(networkUri.host);
    if (hasResponse) {
      return Response<T>(
        statusCode: 200,
        data: MockApiCosmosTxs.defaultResponse as T,
        requestOptions: RequestOptions(path: ''),
      );
    } else {
      throw DioError(requestOptions: RequestOptions(path: networkUri.host));
    }
  }

  @override
  Future<Response<T>> fetchQueryAccount<T>(Uri networkUri, QueryAccountReq request) async {
    bool hasResponse = workingEndpoints.contains(networkUri.host);
    if (hasResponse) {
      return Response<T>(
        statusCode: 200,
        data: MockApiCosmosAuthAccounts.defaultResponse as T,
        headers: MockApiCosmosAuthAccounts.defaultHeaders,
        requestOptions: RequestOptions(path: ''),
      );
    } else {
      throw DioError(requestOptions: RequestOptions(path: networkUri.host));
    }
  }

  @override
  Future<Response<T>> fetchQueryBalance<T>(Uri networkUri, QueryBalanceReq queryBalanceReq) async {
    bool hasResponse = workingEndpoints.contains(networkUri.host);
    if (hasResponse) {
      return Response<T>(
        statusCode: 200,
        data: MockApiCosmosBankBalances.defaultResponse as T,
        requestOptions: RequestOptions(path: ''),
      );
    } else {
      throw DioError(requestOptions: RequestOptions(path: networkUri.host));
    }
  }
}
