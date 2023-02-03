import 'package:flutter/material.dart';
import 'package:miro/config/theme/design_colors.dart';
import 'package:miro/shared/models/validators/validator_model.dart';
import 'package:miro/shared/utils/string_utils.dart';
import 'package:miro/views/pages/menu/validators_page/validator_status_chip/validator_status_chip.dart';
import 'package:miro/views/widgets/buttons/star_button.dart';
import 'package:miro/views/widgets/kira/kira_identity_avatar.dart';

class ValidatorListItemMobile extends StatelessWidget {
  final ValidatorModel validatorModel;
  final ValueChanged<bool> onFavouriteButtonPressed;

  const ValidatorListItemMobile({
    required this.validatorModel,
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
        color: DesignColors.blue1_10,
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 30,
                child: Text(
                  validatorModel.top.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyText2!.copyWith(
                    color: DesignColors.gray2_100,
                  ),
                ),
              ),
              KiraIdentityAvatar(
                address: validatorModel.address,
                size: 32,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  validatorModel.moniker,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyText2!.copyWith(
                    color: DesignColors.gray2_100,
                  ),
                ),
              ),
              StarButton(
                key: Key('fav_validator_${validatorModel.moniker}'),
                onChanged: onFavouriteButtonPressed,
                size: 20,
                value: validatorModel.isFavourite,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFF343261)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(width: 30),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Status',
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyText2!.copyWith(
                        color: DesignColors.gray2_100,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ValidatorStatusTip(validatorStatus: validatorModel.validatorStatus),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Uptime',
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyText2!.copyWith(
                        color: DesignColors.gray2_100,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${validatorModel.uptime}%',
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyText2!.copyWith(
                        color: DesignColors.white_100,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(width: 30),
              Text(
                'Streak',
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyText2!.copyWith(
                  color: DesignColors.gray2_100,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                StringUtils.splitBigNumber(validatorModel.streak),
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyText2!.copyWith(
                  color: DesignColors.white_100,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}