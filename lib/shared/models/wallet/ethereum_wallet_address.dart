import 'dart:convert';
import 'dart:typed_data';

import 'package:miro/shared/models/wallet/wallet_address.dart';
import 'package:miro/shared/utils/cryptography/bech32/bech32.dart';
import 'package:miro/shared/utils/cryptography/bech32/bech32_pair.dart';
import 'package:miro/shared/utils/cryptography/keccak256.dart';

class EthereumWalletAddress extends WalletAddress {
  const EthereumWalletAddress({required Uint8List addressBytes}) : super(addressBytes: addressBytes);

  EthereumWalletAddress.fromHash(String address) : super(addressBytes: utf8.encode(address));

  factory EthereumWalletAddress.fromBech32(String bech32Address) {
    final Bech32Pair bech32pair = Bech32.decode(bech32Address);
    return EthereumWalletAddress(
      addressBytes: Keccak256.encode(bech32pair.data),
    );
  }

  /// Returns the associated [address] as a Hash string.
  @override
  String get address => utf8.decode(addressBytes);
}
