import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miro/blocs/generic/auth/auth_cubit.dart';
import 'package:miro/config/locator.dart';
import 'package:miro/generated/l10n.dart';
import 'package:miro/shared/exceptions/invalid_keyfile_exception.dart';
import 'package:miro/shared/exceptions/invalid_password_exception.dart';
import 'package:miro/shared/models/wallet/keyfile.dart';
import 'package:miro/shared/models/wallet/wallet.dart';
import 'package:miro/shared/utils/logger/app_logger.dart';
import 'package:miro/shared/utils/logger/log_level.dart';
import 'package:miro/shared/utils/string_utils.dart';
import 'package:miro/views/layout/drawer/drawer_subtitle.dart';
import 'package:miro/views/layout/scaffold/kira_scaffold.dart';
import 'package:miro/views/pages/drawer/sign_in_drawer_page/create_wallet_link_button.dart';
import 'package:miro/views/pages/drawer/sign_in_drawer_page/sign_in_keyfile_drawer_page/keyfile_dropzone.dart';
import 'package:miro/views/pages/drawer/sign_in_drawer_page/sign_in_keyfile_drawer_page/keyfile_dropzone_controller.dart';
import 'package:miro/views/widgets/buttons/kira_elevated_button.dart';
import 'package:miro/views/widgets/kira/kira_dropzone/models/dropzone_file.dart';
import 'package:miro/views/widgets/kira/kira_text_field/kira_text_field.dart';
import 'package:miro/views/widgets/kira/kira_text_field/kira_text_field_controller.dart';

class SignInKeyfileDrawerPage extends StatefulWidget {
  const SignInKeyfileDrawerPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignInKeyfileDrawerPage();
}

class _SignInKeyfileDrawerPage extends State<SignInKeyfileDrawerPage> {
  final AuthCubit authCubit = globalLocator<AuthCubit>();
  final KiraTextFieldController keyfilePasswordController = KiraTextFieldController();
  final KeyfileDropzoneController dropZoneController = KeyfileDropzoneController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DrawerTitle(
          title: S.of(context).keyfileSignIn,
          subtitle: S.of(context).keyfileToDropzone,
          tooltipMessage: S.of(context).keyfileTipSecretData,
        ),
        const SizedBox(height: 37),
        KeyfileDropzone(
          controller: dropZoneController,
          validate: _validateKeyFile,
        ),
        const SizedBox(height: 16),
        KiraTextField(
          controller: keyfilePasswordController,
          hint: S.of(context).keyfileEnterPassword,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.deny(StringUtils.whitespacesRegExp),
          ],
          obscureText: true,
          validator: (_) => _validateKeyFilePassword(),
        ),
        const SizedBox(height: 24),
        KiraElevatedButton(
          onPressed: _pressSignInButton,
          title: S.of(context).connectWalletButtonSignIn,
        ),
        const SizedBox(height: 32),
        const CreateWalletLinkButton(),
        const SizedBox(height: 32),
      ],
    );
  }

  String? _validateKeyFile(DropzoneFile? file) {
    if (file == null) {
      String errorMessage = S.of(context).keyfileErrorCannotBeEmpty;
      AppLogger().log(message: errorMessage, logLevel: LogLevel.warning);
      return errorMessage;
    }
    try {
      _getWalletFromKeyFileString(file.content);
      return null;
    } on InvalidKeyFileException catch (_) {
      String errorMessage = S.of(context).keyfileInvalid;
      AppLogger().log(message: errorMessage, logLevel: LogLevel.warning);
      return errorMessage;
    } catch (e) {
      AppLogger().log(message: 'Unknown error: ${e.toString()}', logLevel: LogLevel.terribleFailure);
      return null;
    }
  }

  String? _validateKeyFilePassword() {
    DropzoneFile? file = dropZoneController.dropzoneController.currentFile;
    if (file == null) {
      String errorMessage = S.of(context).keyfileErrorCannotBeEmpty;
      AppLogger().log(message: errorMessage, logLevel: LogLevel.warning);
      dropZoneController.setErrorMessage(errorMessage);
    }
    try {
      _getWalletFromKeyFileString(file!.content);
    } on InvalidPasswordException {
      String errorMessage = S.of(context).keyfileWrongPassword;
      AppLogger().log(message: errorMessage, logLevel: LogLevel.warning);
      return errorMessage;
    }
    return null;
  }

  void _pressSignInButton() {
    bool keyfileValid = dropZoneController.validate() == null;
    keyfilePasswordController.reloadErrorMessage();
    bool passwordValid = keyfilePasswordController.errorNotifier.value == null;

    if (keyfileValid && passwordValid) {
      Wallet wallet = _getWalletFromKeyFileString(dropZoneController.dropzoneController.currentFile!.content);
      authCubit.signIn(wallet);
      KiraScaffold.of(context).closeEndDrawer();
    }
  }

  Wallet _getWalletFromKeyFileString(String keyFileEncryptedContent) {
    try {
      String password = keyfilePasswordController.textController.text;
      KeyFile keyFile = KeyFile.decode(keyFileEncryptedContent, password);
      return keyFile.wallet;
    } catch (e) {
      AppLogger().log(message: 'Unknown error: ${e.toString()}', logLevel: LogLevel.terribleFailure);
      rethrow;
    }
  }
}