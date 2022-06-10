import 'package:dio/dio.dart';
import 'package:miro/infra/dto/api/deposits/request/deposit_req.dart';
import 'package:miro/infra/dto/api/query_validators/request/query_validators_req.dart';
import 'package:miro/infra/dto/api/withdraws/request/withdraws_req.dart';
import 'package:miro/infra/repositories/api_repository.dart';
import 'package:miro/test/mocks/api/api_dashboard.dart';
import 'package:miro/test/mocks/api/api_query_validators.dart';
import 'package:miro/test/mocks/api/api_status.dart';

class MockApiRepository implements ApiRepository {
  @override
  Future<Response<T>> fetchQueryInterxStatus<T>(Uri networkUri) async {
    int statusCode = 404;
    Map<String, dynamic>? mockedResponse;

    if (networkUri.host == 'online.kira.network') {
      statusCode = 200;
      mockedResponse = apiStatusMock;
    } else {
      throw DioError(requestOptions: RequestOptions(path: networkUri.host));
    }

    return Response<T>(
      statusCode: statusCode,
      data: mockedResponse as T,
      requestOptions: RequestOptions(path: ''),
    );
  }

  @override
  Future<Response<T>> fetchDeposits<T>(Uri networkUri, DepositsReq depositsReq) {
    // TODO(Karol): implement fetchDeposits
    throw UnimplementedError();
  }

  @override
  Future<Response<T>> fetchWithdraws<T>(Uri networkUri, WithdrawsReq withdrawsReq) {
    // TODO(Karol): implement fetchWithdraws
    throw UnimplementedError();
  }

  @override
  Future<Response<T>> fetchQueryValidators<T>(Uri networkUri, QueryValidatorsReq queryValidatorsReq) async {
    int statusCode = 404;
    Map<String, dynamic>? mockedResponse;

    if (networkUri.host == 'online.kira.network') {
      statusCode = 200;
      mockedResponse = apiValidatorsMock;
    } else {
      throw DioError(requestOptions: RequestOptions(path: networkUri.host));
    }

    return Response<T>(
      statusCode: statusCode,
      data: mockedResponse as T,
      requestOptions: RequestOptions(path: ''),
    );
  }

  @override
  Future<Response<T>> fetchDashboard<T>(Uri networkUri) async {
    return Response<T>(
      statusCode: 200,
      data: apiDashboardMock as T,
      requestOptions: RequestOptions(path: ''),
    );
  }
}
