import 'package:miro/config/locator.dart';
import 'package:miro/infra/dto/api/query_interx_status/query_interx_status_resp.dart';
import 'package:miro/infra/dto/api/query_validators/response/status.dart';
import 'package:miro/infra/services/api/query_interx_status_service.dart';
import 'package:miro/infra/services/api/query_validators_service.dart';
import 'package:miro/shared/models/network/data/connection_status_type.dart';
import 'package:miro/shared/models/network/data/network_info_model.dart';
import 'package:miro/shared/models/network/status/a_network_status_model.dart';
import 'package:miro/shared/models/network/status/network_offline_model.dart';
import 'package:miro/shared/models/network/status/network_unknown_model.dart';
import 'package:miro/shared/models/network/status/online/a_network_online_model.dart';
import 'package:miro/shared/utils/app_logger.dart';

abstract class _INetworkModuleService {
  Future<ANetworkStatusModel> getNetworkStatusModel(NetworkUnknownModel networkUnknownModel);
}

class NetworkModuleService implements _INetworkModuleService {
  final QueryInterxStatusService _queryInterxStatusService = globalLocator<QueryInterxStatusService>();
  final QueryValidatorsService _queryValidatorsService = globalLocator<QueryValidatorsService>();

  @override
  Future<ANetworkStatusModel> getNetworkStatusModel(NetworkUnknownModel networkUnknownModel, {NetworkUnknownModel? previousNetworkUnknownModel}) async {
    try {
      NetworkInfoModel networkInfoModel = await _getNetworkInfoModel(networkUnknownModel);
      return ANetworkOnlineModel.build(
        networkInfoModel: networkInfoModel,
        connectionStatusType: ConnectionStatusType.disconnected,
        uri: networkUnknownModel.uri,
        name: networkUnknownModel.name,
      );
    } catch (e) {
      AppLogger().log(message: 'NetworkModuleService: Cannot fetch getNetworkStatusModel() for URI ${networkUnknownModel.uri} $e');
      if (networkUnknownModel.isHttps()) {
        return getNetworkStatusModel(networkUnknownModel.copyWithHttp(), previousNetworkUnknownModel: networkUnknownModel);
      } else {
        return NetworkOfflineModel.fromNetworkStatusModel(
          networkStatusModel: previousNetworkUnknownModel ?? networkUnknownModel,
          connectionStatusType: ConnectionStatusType.disconnected,
        );
      }
    }
  }

  Future<NetworkInfoModel> _getNetworkInfoModel(NetworkUnknownModel networkUnknownModel) async {
    Status? status;

    try {
      status = await _queryValidatorsService.getStatus(networkUnknownModel.uri);
    } catch (e) {
      AppLogger().log(message: 'NetworkModuleService: Cannot fetch getStatus() for URI ${networkUnknownModel.uri} $e');
    }

    QueryInterxStatusResp queryInterxStatusResp = await _queryInterxStatusService.getQueryInterxStatusResp(networkUnknownModel.uri);
    return NetworkInfoModel.fromDto(queryInterxStatusResp, status);
  }
}
