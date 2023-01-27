import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miro/shared/models/balances/balance_model.dart';
import 'package:miro/shared/models/tokens/token_amount_model.dart';
import 'package:miro/shared/models/tokens/token_denomination_model.dart';
import 'package:miro/shared/models/wallet/wallet_address.dart';
import 'package:miro/shared/utils/string_utils.dart';
import 'package:miro/views/pages/transactions/tx_form_page/msg_forms/msg_send/msg_send_form_controller.dart';
import 'package:miro/views/widgets/transactions/token_form/token_form.dart';
import 'package:miro/views/widgets/transactions/tx_input_wrapper.dart';
import 'package:miro/views/widgets/transactions/tx_text_field.dart';
import 'package:miro/views/widgets/transactions/wallet_address_text_field.dart';

class MsgSendForm extends StatefulWidget {
  final TokenAmountModel feeTokenAmountModel;
  final MsgSendFormController msgSendFormController;
  final ValueChanged<TokenDenominationModel?> onTokenDenominationChanged;
  final BalanceModel? initialBalanceModel;
  final WalletAddress? initialWalletAddress;

  const MsgSendForm({
    required this.feeTokenAmountModel,
    required this.msgSendFormController,
    required this.onTokenDenominationChanged,
    this.initialBalanceModel,
    this.initialWalletAddress,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MsgSendForm();
}

class _MsgSendForm extends State<MsgSendForm> {
  final ValueNotifier<WalletAddress?> walletAddressNotifier = ValueNotifier<WalletAddress?>(null);
  final TextEditingController memoTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.msgSendFormController.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          WalletAddressTextField(
            label: 'Send from',
            onChanged: _handleSenderAddressChanged,
            initialWalletAddress: widget.initialWalletAddress,
          ),
          const SizedBox(height: 14),
          WalletAddressTextField(
            label: 'Send to',
            onChanged: _handleRecipientAddressChanged,
          ),
          const SizedBox(height: 14),
          ValueListenableBuilder<WalletAddress?>(
            valueListenable: walletAddressNotifier,
            builder: (_, WalletAddress? walletAddress, __) {
              return TokenForm(
                feeTokenAmountModel: widget.feeTokenAmountModel,
                initialBalanceModel: widget.initialBalanceModel,
                onChanged: _handleTokenAmountChanged,
                onTokenDenominationChanged: widget.onTokenDenominationChanged,
                walletAddress: walletAddress,
              );
            },
          ),
          const SizedBox(height: 19),
          TxInputWrapper(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 20),
            child: TxTextField(
              label: 'Memo',
              maxLength: 256,
              onChanged: _handleMemoChanged,
              inputFormatters: <TextInputFormatter>[
                // Warning: Interx doesn't support "<" and ">" in memo, but sekai does.
                FilteringTextInputFormatter.allow(StringUtils.basicCharactersRegExp),
              ],
              textEditingController: memoTextEditingController,
            ),
          ),
        ],
      ),
    );
  }

  void _handleSenderAddressChanged(WalletAddress? walletAddress) {
    walletAddressNotifier.value = walletAddress;
    widget.msgSendFormController.senderWalletAddress = walletAddress;
  }

  void _handleRecipientAddressChanged(WalletAddress? walletAddress) {
    widget.msgSendFormController.recipientWalletAddress = walletAddress;
  }

  void _handleTokenAmountChanged(TokenAmountModel? tokenAmountModel) {
    widget.msgSendFormController.tokenAmountModel = tokenAmountModel;
  }

  void _handleMemoChanged(String memo) {
    widget.msgSendFormController.memo = memo;
  }
}
