import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miro/blocs/specific_blocs/transactions/tx_form_init/a_tx_form_init_state.dart';
import 'package:miro/blocs/specific_blocs/transactions/tx_form_init/states/tx_form_init_downloading_state.dart';
import 'package:miro/blocs/specific_blocs/transactions/tx_form_init/states/tx_form_init_error_state.dart';
import 'package:miro/blocs/specific_blocs/transactions/tx_form_init/states/tx_form_init_loaded_state.dart';
import 'package:miro/blocs/specific_blocs/transactions/tx_form_init/tx_form_init_cubit.dart';
import 'package:miro/config/app_icons.dart';
import 'package:miro/config/theme/design_colors.dart';
import 'package:miro/shared/models/transactions/messages/tx_msg_type.dart';
import 'package:miro/views/widgets/generic/center_load_spinner.dart';

class TxFormInitCubitWrapper extends StatefulWidget {
  final TxMsgType txMsgType;
  final Widget Function(TxFormInitLoadedState txFormInitLoadedState) childBuilder;

  const TxFormInitCubitWrapper({
    required this.txMsgType,
    required this.childBuilder,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TxSendFormCubitWrapper();
}

class _TxSendFormCubitWrapper extends State<TxFormInitCubitWrapper> {
  late final TxFormInitCubit txFormInitCubit = TxFormInitCubit(txMsgType: widget.txMsgType);

  @override
  void initState() {
    super.initState();
    txFormInitCubit.downloadTxFee();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return BlocBuilder<TxFormInitCubit, ATxFormInitState>(
      bloc: txFormInitCubit,
      builder: (BuildContext context, ATxFormInitState txFormInitState) {
        if (txFormInitState is TxFormInitDownloadingState) {
          return SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const CenterLoadSpinner(),
                const SizedBox(height: 20),
                Text(
                  'Fetching remote data. Please wait...',
                  style: textTheme.bodyText1!.copyWith(
                    color: DesignColors.white_100,
                  ),
                ),
              ],
            ),
          );
        } else if (txFormInitState is TxFormInitErrorState) {
          return SizedBox(
            height: 200,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Cannot fetch transaction details. Check your internet connection',
                  style: textTheme.caption!.copyWith(
                    color: DesignColors.red_100,
                  ),
                ),
                const SizedBox(height: 20),
                TextButton.icon(
                  onPressed: txFormInitCubit.downloadTxFee,
                  icon: const Icon(
                    AppIcons.refresh,
                    size: 18,
                  ),
                  label: Text(
                    'Try again',
                    style: textTheme.subtitle2!.copyWith(
                      color: DesignColors.white_100,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return widget.childBuilder(txFormInitState as TxFormInitLoadedState);
        }
      },
    );
  }
}