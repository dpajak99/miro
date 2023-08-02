import 'package:flutter/material.dart';
import 'package:miro/config/theme/design_colors.dart';
import 'package:miro/generated/l10n.dart';
import 'package:miro/shared/controllers/menu/my_account_page/staking_page/staking_model.dart';
import 'package:miro/views/layout/scaffold/kira_scaffold.dart';
import 'package:miro/views/pages/drawer/staking_drawer_page/staking_drawer_page.dart';
import 'package:miro/views/pages/menu/my_account_page/staking_page/staking_status_chip/staking_status_chip.dart';
import 'package:miro/views/widgets/buttons/kira_outlined_button.dart';
import 'package:miro/views/widgets/kira/kira_identity_avatar.dart';

class StakingListItemMobile extends StatelessWidget {
  final StakingModel stakingModel;
  final ValueChanged<bool> onFavouriteButtonPressed;

  const StakingListItemMobile({
    required this.stakingModel,
    required this.onFavouriteButtonPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: DesignColors.black,
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 30,
                child: Text(
                  stakingModel.validatorModel.top.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyText2!.copyWith(
                    color: DesignColors.white2,
                  ),
                ),
              ),
              KiraIdentityAvatar(
                address: stakingModel.validatorModel.address,
                size: 40,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  stakingModel.validatorModel.moniker,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyText1!.copyWith(
                    color: DesignColors.white1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(color: DesignColors.grey2),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(width: 30),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      S.of(context).validatorsTableStatus,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyText2!.copyWith(
                        color: DesignColors.white2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    StakingStatusTip(validatorStatus: stakingModel.validatorModel.validatorStatus),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      S.of(context).stakingPoolLabelCommission,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyText2!.copyWith(
                        color: DesignColors.white2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      stakingModel.stakingPoolModel.commission,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyText1!.copyWith(
                        color: DesignColors.white1,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      S.of(context).stakingPoolLabelTokens,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyText2!.copyWith(
                        color: DesignColors.white2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Column(
                      children: <Widget>[
                        for (String token in stakingModel.stakingPoolModel.tokens)
                          Text(
                            '$token ',
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyText1!.copyWith(
                              color: DesignColors.white1,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          KiraOutlinedButton(
            onPressed: () => KiraScaffold.of(context).navigateEndDrawerRoute(
              StakingDrawerPage(stakingModel: stakingModel),
            ),
            title: S.of(context).showDetails,
            leading: const Icon(
              Icons.info_outline,
              color: DesignColors.white2,
            ),
            uppercaseBool: true,
          ),
        ],
      ),
    );
  }
}
