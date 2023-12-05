import 'package:flutter/material.dart';
import 'package:miro/generated/l10n.dart';
import 'package:miro/shared/models/delegations/validator_staking_model.dart';
import 'package:miro/views/widgets/kira/kira_list/components/list_search_widget.dart';

class StakingListTitleMobile extends StatelessWidget {
  final TextEditingController searchBarTextEditingController;

  const StakingListTitleMobile({
    required this.searchBarTextEditingController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: ListSearchWidget<ValidatorStakingModel>(
            textEditingController: searchBarTextEditingController,
            hint: S.of(context).validatorsHintSearch,
          ),
        ),
      ],
    );
  }
}