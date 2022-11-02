import 'package:miro/infra/dto/api_cosmos/broadcast/request/messages/i_tx_msg.dart';
import 'package:miro/infra/dto/api_cosmos/broadcast/request/messages/identity_records/msg_cancel_identity_records_verify_request.dart';
import 'package:miro/shared/models/transactions/messages/a_tx_msg_model.dart';
import 'package:miro/shared/models/transactions/messages/tx_msg_type.dart';
import 'package:miro/shared/models/wallet/wallet_address.dart';

class MsgCancelIdentityRecordsVerifyRequestModel extends ATxMsgModel {
  final BigInt verifyRequestId;
  final WalletAddress walletAddress;

  const MsgCancelIdentityRecordsVerifyRequestModel({
    required this.verifyRequestId,
    required this.walletAddress,
  }) : super(txMsgType: TxMsgType.msgCancelIdentityRecordsVerifyRequest);

  factory MsgCancelIdentityRecordsVerifyRequestModel.fromDto(MsgCancelIdentityRecordsVerifyRequest msgCancelIdentityRecordsVerifyRequest) {
    return MsgCancelIdentityRecordsVerifyRequestModel(
      verifyRequestId: msgCancelIdentityRecordsVerifyRequest.verifyRequestId,
      walletAddress: WalletAddress.fromBech32(msgCancelIdentityRecordsVerifyRequest.executor),
    );
  }

  @override
  ITxMsg toMsgDto() {
    return MsgCancelIdentityRecordsVerifyRequest(
      executor: walletAddress.bech32Address,
      verifyRequestId: verifyRequestId,
    );
  }

  @override
  List<Object?> get props => <Object>[verifyRequestId, walletAddress];
}