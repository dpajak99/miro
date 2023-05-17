import 'package:miro/blocs/widgets/kira/kira_list/abstract_list/models/a_list_item.dart';
import 'package:miro/infra/dto/api_kira/query_proposals/response/proposal.dart';
import 'package:miro/shared/models/proposals/a_proposal_type_content_model.dart';
import 'package:miro/shared/models/proposals/proposal_status.dart';
import 'package:miro/shared/models/proposals/proposal_type.dart';
import 'package:miro/shared/models/validators/validator_simplified_model.dart';

class ProposalModel extends AListItem {
  final int id;
  final String title;
  final ProposalStatus? proposalStatus;
  final AProposalTypeContentModel proposalTypeContentModel;
  final DateTime votingEndTime;
  final ValidatorSimplifiedModel proposer;
  final String description;
  final String transactionHash;
  final String attendance;
  final String quorum;
  final DateTime votingStartTime;
  final DateTime votingEnactedTime;
  final String metaData;
  bool _favourite = false;

  ProposalModel({
    required this.id,
    required this.title,
    required this.proposalStatus,
    required this.proposalTypeContentModel,
    required this.votingEndTime,
    required this.proposer,
    required this.description,
    required this.transactionHash,
    required this.attendance,
    required this.quorum,
    required this.votingStartTime,
    required this.votingEnactedTime,
    required this.metaData,
  });

  factory ProposalModel.fromDto(Proposal proposal) {
    return ProposalModel(
      id: proposal.proposalId,
      title: proposal.title,
      proposalStatus: ProposalStatus.fromString(proposal.result),
      proposalTypeContentModel: AProposalTypeContentModel.buildFromDto(
        proposal.content,
        ProposalType.fromString(proposal.content.type),
      ),
      votingEndTime: proposal.votingEndTime,
      proposer: ValidatorSimplifiedModel.fromDto(proposal.proposerInfo),
      description: proposal.description,
      transactionHash: proposal.transactionHash,
      attendance: '${proposal.votersCount} / ${proposal.votesCount}',
      quorum: proposal.quorum,
      votingStartTime: proposal.submitTime,
      votingEnactedTime: proposal.enactmentEndTime,
      metaData: proposal.metaData,
    );
  }

  @override
  String get cacheId => id.toString();

  @override
  bool get isFavourite => _favourite;

  @override
  set favourite(bool value) => _favourite = value;

  @override
  String toString() {
    return 'ProposalModel(id: $id, title: $title, proposalStatus: $proposalStatus, proposalTypeContentModel: $proposalTypeContentModel, votingEndTime: $votingEndTime, proposer: $proposer, description: $description, transactionHash: $transactionHash, attendance: $attendance, quorum: $quorum, votingStartTime: $votingStartTime, votingEnactedTime: $votingEnactedTime, metaData: $metaData)';
  }
}
