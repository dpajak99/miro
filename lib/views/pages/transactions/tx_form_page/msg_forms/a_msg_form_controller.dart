import 'package:flutter/material.dart';
import 'package:miro/shared/models/transactions/messages/a_tx_msg_model.dart';

abstract class AMsgFormController {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _formFilledNotifier = ValueNotifier<bool>(false);

  GlobalKey<FormState> get formKey => _formKey;

  ValueNotifier<bool> get formFilledNotifier => _formFilledNotifier;

  String get memo;

  /// Method [buildTxMsgModel] throws [Exception] if cannot create ATxMsgModel
  /// Broader explanation about reason of thrown exception should be described in specific implementations of this method
  ATxMsgModel buildTxMsgModel();
}
