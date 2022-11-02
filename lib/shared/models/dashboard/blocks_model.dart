import 'package:equatable/equatable.dart';
import 'package:miro/infra/dto/api/dashboard/blocks.dart';

class BlocksModel extends Equatable {
  final int currentHeight;
  final int sinceGenesis;
  final int pendingTransactions;
  final int currentTransactions;
  final double latestTime;
  final double averageTime;

  const BlocksModel({
    required this.currentHeight,
    required this.sinceGenesis,
    required this.pendingTransactions,
    required this.currentTransactions,
    required this.latestTime,
    required this.averageTime,
  });

  factory BlocksModel.fromDto(Blocks blocks) {
    return BlocksModel(
      currentHeight: blocks.currentHeight,
      sinceGenesis: blocks.sinceGenesis,
      pendingTransactions: blocks.pendingTransactions,
      currentTransactions: blocks.currentTransactions,
      latestTime: blocks.latestTime,
      averageTime: blocks.averageTime,
    );
  }

  String get latestBlocTimeString => '${latestTime.toStringAsFixed(1)} sec';

  String get averageBlocTimeString => '${averageTime.toStringAsFixed(1)} sec';

  @override
  List<Object?> get props => <Object>[currentHeight, sinceGenesis, pendingTransactions, currentTransactions, latestTime, averageTime];
}
