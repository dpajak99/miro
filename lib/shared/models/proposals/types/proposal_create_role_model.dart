import 'package:flutter/material.dart';
import 'package:miro/generated/l10n.dart';
import 'package:miro/infra/dto/api_kira/query_proposals/response/types/proposal_create_role.dart';
import 'package:miro/shared/models/proposals/a_proposal_type_content_model.dart';
import 'package:miro/shared/models/proposals/proposal_type.dart';

class ProposalCreateRoleModel extends AProposalTypeContentModel {
  final String roleDescription;
  final String roleSid;
  final List<String> blacklistedPermissions;
  final List<String> whitelistedPermissions;

  const ProposalCreateRoleModel({
    required ProposalType proposalType,
    required this.roleDescription,
    required this.roleSid,
    required this.blacklistedPermissions,
    required this.whitelistedPermissions,
  }) : super(proposalType: proposalType);

  factory ProposalCreateRoleModel.fromDto(ProposalCreateRole proposalCreateRole) {
    return ProposalCreateRoleModel(
      blacklistedPermissions: proposalCreateRole.blacklistedPermissions,
      proposalType: ProposalType.fromString(proposalCreateRole.type),
      roleDescription: proposalCreateRole.roleDescription,
      roleSid: proposalCreateRole.roleSid,
      whitelistedPermissions: proposalCreateRole.whitelistedPermissions,
    );
  }

  @override
  Map<String, dynamic> getProposalContentValues() {
    return <String, dynamic>{
      'roleDescription': roleDescription,
      'roleSid': roleSid,
      'blacklistedPermissions': blacklistedPermissions,
      'whitelistedPermissions': whitelistedPermissions,
    };
  }

  @override
  String getProposalTitle(BuildContext context) {
    return S.of(context).proposalTypeCreateRole;
  }

  @override
  List<Object> get props {
    return <Object>[
      roleDescription,
      roleSid,
      blacklistedPermissions,
      whitelistedPermissions,
    ];
  }
}
