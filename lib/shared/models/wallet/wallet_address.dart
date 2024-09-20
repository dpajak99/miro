import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:miro/shared/models/wallet/cosmos_wallet_address.dart';
import 'package:miro/shared/models/wallet/ethereum_wallet_address.dart';

/// Represents an wallet address.
/// Source: https://github.com/LmFlutterSDK/web3dart/blob/master/lib/src/credentials/address.dart
abstract class WalletAddress extends Equatable {
  /// Stores raw address bytes.
  const WalletAddress({
    required this.addressBytes,
  }) : assert(addressBytes.length == addressByteLength, 'Address should be $addressByteLength bytes length');

  factory WalletAddress.fromAddress(String address) {
    if (address.substring(0, 4) == 'kira') {
      return CosmosWalletAddress.fromBech32(address);
    } else if (address.substring(0, 2) == '0x') {
      return EthereumWalletAddress.fromHash(address);
    }
    throw Exception('Invalid address');
  }

  factory WalletAddress.fromValidatorString(String address) {
    if (address.substring(0, 4) == 'kira') {
      return CosmosWalletAddress.fromBech32Validators(address);
    } else if (address.substring(0, 2) == '0x') {
      return EthereumWalletAddress.fromHash(address);
    }
    throw Exception('Invalid address');
  }

  final Uint8List addressBytes;

  String get address;

  /// The length of a wallet address, in bytes.
  static const int addressByteLength = 20;

  /// Returns the associated [address] as a string.
  String buildShortAddress({required String delimiter}) {
    String ad = address;
    String firstPart = ad.substring(0, 8);
    String lastPart = ad.substring(ad.length - 4, ad.length);
    return '${firstPart}$delimiter$lastPart';
  }

  @override
  List<Object?> get props => <Object>[addressBytes];
}
