import 'package:miro/infra/dto/api_cosmos/broadcast/request/coin.dart';
import 'package:miro/infra/dto/api_cosmos/broadcast/request/messages/i_tx_msg.dart';
import 'package:miro/infra/dto/api_cosmos/broadcast/request/transaction/components/tx_fee.dart';
import 'package:miro/shared/models/transactions/tx_local_info_model.dart';
import 'package:miro/shared/models/transactions/tx_remote_info_model.dart';
import 'package:miro/shared/models/transactions/unsigned_tx_model.dart';

/// StdSignDoc is replay-prevention structure.
///
/// https://docs.cosmos.network/master/core/transactions.html
class StdSignDoc {
  /// The account number of the account in state
  final String accountNumber;

  /// Sequence of the account, which describes the number
  /// of committed transactions signed by a given address.
  /// It is used to prevent replay attacks.
  final String sequence;

  /// The unique identifier of the chain this transaction targets.
  /// It prevents signed transactions from being used on another chain by an attacker
  final String chainId;

  /// Any arbitrary note/comment to be added to the transaction.
  final String memo;

  /// Fee includes the amount of coins paid in fees to be used by the transaction.
  final TxFee fee;

  /// List of messages to be executed.
  final List<ITxMsg> messages;

  const StdSignDoc({
    required this.accountNumber,
    required this.sequence,
    required this.chainId,
    required this.memo,
    required this.fee,
    required this.messages,
  });

  factory StdSignDoc.fromUnsignedTxModel(UnsignedTxModel unsignedTxModel) {
    TxRemoteInfoModel txRemoteInfoModel = unsignedTxModel.txRemoteInfoModel;
    TxLocalInfoModel txLocalInfoModel = unsignedTxModel.txLocalInfoModel;

    return StdSignDoc(
      accountNumber: txRemoteInfoModel.accountNumber,
      sequence: txRemoteInfoModel.sequence,
      chainId: txRemoteInfoModel.chainId,
      memo: txLocalInfoModel.memo,
      fee: TxFee(
        amount: <Coin>[Coin.fromTokenAmountModel(txLocalInfoModel.feeTokenAmountModel)],
      ),
      messages: <ITxMsg>[txLocalInfoModel.txMsgModel.toMsgDto()],
    );
  }

  Map<String, dynamic> toSignatureJson() {
    return <String, dynamic>{
      'account_number': accountNumber,
      'sequence': sequence,
      'chain_id': chainId,
      'memo': memo,
      'fee': fee.toSignatureJson(),
      'msgs': messages.map((ITxMsg txMsg) => txMsg.toSignatureJson()).toList(),
    };
  }
}