import 'package:equatable/equatable.dart';
import 'package:miro/shared/models/network/data/connection_status_type.dart';
import 'package:miro/shared/models/network/status/a_network_status_model.dart';
import 'package:miro/shared/models/network/status/network_empty_model.dart';
import 'package:miro/shared/models/network/status/online/a_network_online_model.dart';

class NetworkModuleState extends Equatable {
  final ANetworkStatusModel networkStatusModel; // NetworkEmptyModel

  const NetworkModuleState.connecting(this.networkStatusModel);

  const NetworkModuleState.connected(ANetworkOnlineModel networkOnlineModel) : networkStatusModel = networkOnlineModel;

  NetworkModuleState.disconnected() : networkStatusModel = NetworkEmptyModel(connectionStatusType: ConnectionStatusType.disconnected);

  bool get isConnecting => networkStatusModel.connectionStatusType == ConnectionStatusType.connecting;

  bool get isConnected => networkStatusModel.connectionStatusType == ConnectionStatusType.connected;

  bool get isDisconnected => networkStatusModel.connectionStatusType == ConnectionStatusType.disconnected;

  Uri get networkUri => networkStatusModel.uri;

  @override
  List<Object?> get props => <Object?>[networkStatusModel];
}
