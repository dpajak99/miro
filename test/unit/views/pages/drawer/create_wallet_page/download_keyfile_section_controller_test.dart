import 'package:flutter_test/flutter_test.dart';
import 'package:miro/views/pages/drawer/create_wallet_page/download_keyfile_section/download_keyfile_section_controller.dart';

// To run this test type in console:
// fvm flutter test test/unit/views/pages/drawer/create_wallet_page/download_keyfile_section_controller_test.dart --platform chrome --null-assertions
void main() {
  group('Tests of [DownloadKeyfileSectionController.clear]', () {
    test('Should reset [DownloadKeyfileSectionController] state after [clear] method is called', () {
      // Arrange
      DownloadKeyfileSectionController actualDownloadKeyfileSectionController = DownloadKeyfileSectionController();
      actualDownloadKeyfileSectionController.passwordTextController.textController.text = 'password';
      actualDownloadKeyfileSectionController.repeatedPasswordTextController.textController.text = 'password';
      actualDownloadKeyfileSectionController.downloadEnabledNotifier.value = true;

      // Act
      actualDownloadKeyfileSectionController.clear();
      bool actualDownloadEnabledBool = actualDownloadKeyfileSectionController.downloadEnabledNotifier.value;

      String actualPasswordValue = actualDownloadKeyfileSectionController.passwordTextController.textController.text;
      String actualRepeatedPasswordValue = actualDownloadKeyfileSectionController.repeatedPasswordTextController.textController.text;

      // Assert
      expect(actualDownloadEnabledBool, false);

      expect(actualPasswordValue, '');
      expect(actualRepeatedPasswordValue, '');
    });
  });

  group('Tests of [DownloadKeyfileSectionController.validatePassword]', () {
    test('Should set [downloadEnabledNotifier] value to "true" if passwords are valid', () {
      // Arrange
      DownloadKeyfileSectionController actualDownloadKeyfileSectionController = DownloadKeyfileSectionController();
      actualDownloadKeyfileSectionController.passwordTextController.textController.text = 'password';
      actualDownloadKeyfileSectionController.repeatedPasswordTextController.textController.text = 'password';

      // Act
      actualDownloadKeyfileSectionController.validatePassword();
      bool downloadEnabledBool = actualDownloadKeyfileSectionController.downloadEnabledNotifier.value;

      // Assert
      expect(downloadEnabledBool, true);
    });

    test('Should set [downloadEnabledNotifier] value to "false" if passwords are different', () {
      // Arrange
      DownloadKeyfileSectionController actualDownloadKeyfileSectionController = DownloadKeyfileSectionController();
      actualDownloadKeyfileSectionController.passwordTextController.textController.text = 'pass';
      actualDownloadKeyfileSectionController.repeatedPasswordTextController.textController.text = 'word';

      // Act
      actualDownloadKeyfileSectionController.validatePassword();
      bool downloadEnabledBool = actualDownloadKeyfileSectionController.downloadEnabledNotifier.value;

      // Assert
      expect(downloadEnabledBool, false);
    });

    test('Should set [downloadEnabledNotifier] value to "false" if passwords are empty', () {
      // Arrange
      DownloadKeyfileSectionController actualDownloadKeyfileSectionController = DownloadKeyfileSectionController();
      actualDownloadKeyfileSectionController.passwordTextController.textController.text = '';
      actualDownloadKeyfileSectionController.repeatedPasswordTextController.textController.text = '';

      // Act
      actualDownloadKeyfileSectionController.validatePassword();
      bool downloadEnabledBool = actualDownloadKeyfileSectionController.downloadEnabledNotifier.value;

      // Assert
      expect(downloadEnabledBool, false);
    });
  });

  group('Tests of [DownloadKeyfileSectionController.arePasswordsValid]', () {
    test('Should return "true" if passwords are valid', () {
      // Arrange
      DownloadKeyfileSectionController actualDownloadKeyfileSectionController = DownloadKeyfileSectionController();
      actualDownloadKeyfileSectionController.passwordTextController.textController.text = 'password';
      actualDownloadKeyfileSectionController.repeatedPasswordTextController.textController.text = 'password';

      // Act
      bool actualPasswordsValidBool = actualDownloadKeyfileSectionController.arePasswordsValid;

      // Assert
      expect(actualPasswordsValidBool, true);
    });

    test('Should return "false" if passwords are different', () {
      // Arrange
      DownloadKeyfileSectionController actualDownloadKeyfileSectionController = DownloadKeyfileSectionController();
      actualDownloadKeyfileSectionController.passwordTextController.textController.text = 'pass';
      actualDownloadKeyfileSectionController.repeatedPasswordTextController.textController.text = 'word';

      // Act
      bool actualPasswordsValidBool = actualDownloadKeyfileSectionController.arePasswordsValid;

      // Assert
      expect(actualPasswordsValidBool, false);
    });

    test('Should return "false" if passwords are empty', () {
      // Arrange
      DownloadKeyfileSectionController actualDownloadKeyfileSectionController = DownloadKeyfileSectionController();
      actualDownloadKeyfileSectionController.passwordTextController.textController.text = '';
      actualDownloadKeyfileSectionController.repeatedPasswordTextController.textController.text = '';

      // Act
      bool actualPasswordsValidBool = actualDownloadKeyfileSectionController.arePasswordsValid;

      // Assert
      expect(actualPasswordsValidBool, false);
    });
  });

  group('Tests of [DownloadKeyfileSectionController.isRepeatedPasswordEmpty]', () {
    test('Should return "true" if repeated password is empty', () {
      // Arrange
      DownloadKeyfileSectionController actualDownloadKeyfileSectionController = DownloadKeyfileSectionController();
      actualDownloadKeyfileSectionController.repeatedPasswordTextController.textController.text = '';

      // Act
      bool actualPasswordEmptyBool = actualDownloadKeyfileSectionController.isRepeatedPasswordEmpty;

      // Assert
      expect(actualPasswordEmptyBool, true);
    });

    test('Should return "false" if repeated password is not empty', () {
      // Arrange
      DownloadKeyfileSectionController actualDownloadKeyfileSectionController = DownloadKeyfileSectionController();
      actualDownloadKeyfileSectionController.repeatedPasswordTextController.textController.text = 'password';

      // Act
      bool actualPasswordEmptyBool = actualDownloadKeyfileSectionController.isRepeatedPasswordEmpty;

      // Assert
      expect(actualPasswordEmptyBool, false);
    });
  });
}
