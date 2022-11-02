import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miro/blocs/specific_blocs/transactions/token_form/token_form_cubit.dart';

class TokenAmountTextFieldActions extends StatefulWidget {
  final bool disabled;

  const TokenAmountTextFieldActions({
    required this.disabled,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TokenAmountTextFieldActions();
}

class _TokenAmountTextFieldActions extends State<TokenAmountTextFieldActions> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TextButton(
          onPressed: widget.disabled ? null : _handleSendAllPressed,
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
          ),
          child: const Text('Send all'),
        ),
        TextButton(
          onPressed: widget.disabled ? null : _handleClearPressed,
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
          ),
          child: const Text('Clear'),
        )
      ],
    );
  }

  void _handleSendAllPressed() {
    BlocProvider.of<TokenFormCubit>(context).setAllAvailableAmount();
  }

  void _handleClearPressed() {
    BlocProvider.of<TokenFormCubit>(context).clearTokenAmount();
  }
}