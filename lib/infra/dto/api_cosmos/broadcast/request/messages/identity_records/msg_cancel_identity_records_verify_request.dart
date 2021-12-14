import 'package:miro/infra/dto/api_cosmos/broadcast/request/messages/tx_msg.dart';

/// MsgEditIdentityRecord defines a proposal message to edit an identity record
class MsgCancelIdentityRecordsVerifyRequest extends TxMsg {
  /// The address of requester
  final String executor;

  /// The id of verification request
  final BigInt verifyRequestId;

  MsgCancelIdentityRecordsVerifyRequest({
    required this.executor,
    required this.verifyRequestId,
  });

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      '@type': '/kira.gov.MsgCancelIdentityRecordsVerifyRequest',
      'executor': executor,
      // TODO(dominik): That json param, probably will be changed to verify_request_id in future
      'verifyRequestId': verifyRequestId.toString(),
    };
  }

  @override
  Map<String, dynamic> toSignatureJson() {
    return <String, dynamic>{
      'type': 'kiraHub/MsgCancelIdentityRecordsVerifyRequest',
      'value': <String, dynamic>{
        'executor': executor,
        // TODO(dominik): That json param, probably will be changed to verify_request_id in future
        'verifyRequestId': verifyRequestId.toString(),
      },
    };
  }
}
