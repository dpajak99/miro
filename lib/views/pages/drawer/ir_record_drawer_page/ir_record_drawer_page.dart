import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:miro/blocs/generic/identity_registrar/identity_registrar_cubit.dart';
import 'package:miro/blocs/pages/drawer/ir_record_drawer_page/a_ir_record_drawer_page_state.dart';
import 'package:miro/blocs/pages/drawer/ir_record_drawer_page/ir_record_drawer_page_cubit.dart';
import 'package:miro/blocs/pages/drawer/ir_record_drawer_page/state/ir_record_drawer_page_loaded_state.dart';
import 'package:miro/blocs/pages/drawer/ir_record_drawer_page/state/ir_record_drawer_page_loading_state.dart';
import 'package:miro/config/theme/design_colors.dart';
import 'package:miro/generated/l10n.dart';
import 'package:miro/shared/models/identity_registrar/ir_record_field_config_model.dart';
import 'package:miro/shared/models/identity_registrar/ir_record_field_type.dart';
import 'package:miro/shared/models/identity_registrar/ir_record_model.dart';
import 'package:miro/shared/router/kira_router.dart';
import 'package:miro/shared/router/router.gr.dart';
import 'package:miro/views/layout/drawer/drawer_subtitle.dart';
import 'package:miro/views/pages/drawer/ir_record_drawer_page/ir_record_verifications_list.dart';
import 'package:miro/views/pages/drawer/ir_record_drawer_page/ir_record_verifications_list_shimmer.dart';
import 'package:miro/views/pages/menu/my_account_page/identity_registrar/ir_record_status_chip/ir_record_status_chip.dart';
import 'package:miro/views/pages/menu/my_account_page/identity_registrar/ir_record_value_widget/ir_record_text_value_widget.dart';
import 'package:miro/views/pages/menu/my_account_page/identity_registrar/ir_record_value_widget/ir_record_urls_value_widget.dart';
import 'package:miro/views/widgets/buttons/kira_outlined_button.dart';
import 'package:miro/views/widgets/generic/expandable_text.dart';
import 'package:miro/views/widgets/generic/prefixed_widget.dart';
import 'package:miro/views/widgets/generic/responsive/responsive_value.dart';

class IRRecordDrawerPage extends StatefulWidget {
  final IRRecordFieldConfigModel irRecordFieldConfigModel;
  final IdentityRegistrarCubit identityRegistrarCubit;
  final IRRecordModel irRecordModel;

  const IRRecordDrawerPage({
    required this.irRecordFieldConfigModel,
    required this.identityRegistrarCubit,
    required this.irRecordModel,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _IRRecordDrawerPage();
}

class _IRRecordDrawerPage extends State<IRRecordDrawerPage> {
  late final IRRecordDrawerPageCubit irRecordDrawerPageCubit = IRRecordDrawerPageCubit(irRecordModel: widget.irRecordModel);

  @override
  void initState() {
    super.initState();
    irRecordDrawerPageCubit.init();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    late Widget valueWidget;

    if (widget.irRecordFieldConfigModel.irRecordFieldType == IRRecordFieldType.urls) {
      valueWidget = IRRecordUrlsValueWidget(
        loadingBool: false,
        label: S.of(context).irTxHintValue,
        urls: widget.irRecordModel.value?.split(',').toList() ?? <String>[],
      );
    } else {
      valueWidget = IRRecordTextValueWidget(
        expandableBool: true,
        maxLines: 6,
        loadingBool: false,
        label: S.of(context).irTxHintValue,
        value: widget.irRecordModel.value,
      );
    }

    return BlocBuilder<IRRecordDrawerPageCubit, AIRRecordDrawerPageState>(
      bloc: irRecordDrawerPageCubit,
      builder: (BuildContext context, AIRRecordDrawerPageState irRecordDrawerPageState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DrawerTitle(title: S.of(context).irRecordDetails),
            const SizedBox(height: 32),
            PrefixedWidget(
              prefix: S.of(context).irTxHintKey,
              child: ExpandableText(
                initialTextLength: const ResponsiveValue<int>(
                  largeScreen: 500,
                  mediumScreen: 300,
                  smallScreen: 150,
                ).get(context),
                textLengthSeeMore: 500,
                text: Text(
                  widget.irRecordFieldConfigModel.label,
                  style: textTheme.bodyText2!.copyWith(color: DesignColors.white1),
                ),
              ),
            ),
            const SizedBox(height: 30),
            valueWidget,
            const SizedBox(height: 30),
            KiraOutlinedButton(
              height: 40,
              title: S.of(context).irRecordEdit,
              onPressed: _pressEditButton,
            ),
            const SizedBox(height: 30),
            PrefixedWidget(
              prefix: S.of(context).irRecordStatus,
              child: IRRecordStatusChip(
                loadingBool: false,
                irRecordModel: widget.irRecordModel,
              ),
            ),
            const SizedBox(height: 30),
            PrefixedWidget(
              prefix: S.of(context).creationDate,
              child: Text(
                widget.irRecordModel.dateTime != null ? DateFormat('d MMM y, HH:mm').format(widget.irRecordModel.dateTime!.toLocal()) : '---',
                style: textTheme.bodyText2!.copyWith(color: DesignColors.white1),
              ),
            ),
            const SizedBox(height: 30),
            if (irRecordDrawerPageState is IRRecordDrawerPageLoadedState) ...<Widget>[
              IRRecordVerificationsList(
                irVerificationModels: irRecordDrawerPageState.irVerificationModels,
              ),
            ] else if (irRecordDrawerPageState is IRRecordDrawerPageLoadingState) ...<Widget>[
              const IRRecordVerificationsListShimmer(),
            ] else ...<Widget>[
              Text(
                S.of(context).errorCannotFetchData,
                style: textTheme.bodyText2!.copyWith(color: DesignColors.redStatus1),
              )
            ],
            const SizedBox(height: 30),
            InkWell(
              onTap: _pressAddMoreButton,
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.add,
                    color: DesignColors.accent,
                  ),
                  const SizedBox(width: 10),
                  Text(S.of(context).irRecordVerifiersAddMore),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        );
      },
    );
  }

  Future<void> _pressEditButton() async {
    await KiraRouter.of(context).push<void>(PagesWrapperRoute(
      children: <PageRouteInfo>[
        TransactionsWrapperRoute(children: <PageRouteInfo>[
          IRTxRegisterRecordRoute(
            irRecordModel: widget.irRecordModel,
            irKeyEditableBool: false,
            irValueMaxLength: widget.irRecordFieldConfigModel.valueMaxLength,
          ),
        ]),
      ],
    ));
    await widget.identityRegistrarCubit.refresh();
    Navigator.of(context).pop();
  }

  Future<void> _pressAddMoreButton() async {
    await KiraRouter.of(context).push<void>(PagesWrapperRoute(
      children: <PageRouteInfo>[
        TransactionsWrapperRoute(children: <PageRouteInfo>[
          IRTxRequestVerificationRoute(irRecordModel: widget.irRecordModel),
        ]),
      ],
    ));
    await widget.identityRegistrarCubit.refresh();
    await irRecordDrawerPageCubit.init();
  }
}