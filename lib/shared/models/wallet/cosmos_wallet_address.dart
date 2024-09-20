import 'dart:typed_data';

import 'package:miro/blocs/generic/network_module/network_module_bloc.dart';
import 'package:miro/config/locator.dart';
import 'package:miro/shared/models/wallet/wallet_address.dart';
import 'package:miro/shared/utils/cryptography/bech32/bech32.dart';
import 'package:miro/shared/utils/cryptography/bech32/bech32_pair.dart';
import 'package:miro/shared/utils/cryptography/secp256k1.dart';

class CosmosWalletAddress extends WalletAddress {
  final String? _bech32Hrp;

  /// Stores raw address bytes and allows to create bech32Address based on hrp (human readable part).
  const CosmosWalletAddress({
    required Uint8List addressBytes,
    String? bech32Hrp,
  })  : _bech32Hrp = bech32Hrp,
        super(addressBytes: addressBytes);

  /// Constructs a wallet address from a public key. The address is formed by
  /// the last 20 bytes of the keccak hash of the public key.
  factory CosmosWalletAddress.fromPublicKey(Uint8List publicKey) {
    return CosmosWalletAddress(addressBytes: Secp256k1.publicKeyToAddress(publicKey));
  }

  // Hrp data extracted from QueryTokenAliases
  factory CosmosWalletAddress.fromBech32(String bech32Address) {
    final Bech32Pair bech32pair = Bech32.decode(bech32Address);
    return CosmosWalletAddress(addressBytes: bech32pair.data);
  }

  // Hrp data extracted from QueryValidators
  factory CosmosWalletAddress.fromBech32Validators(String bech32Address) {
    final Bech32Pair bech32pair = Bech32.decode(bech32Address);
    return CosmosWalletAddress(addressBytes: bech32pair.data, bech32Hrp: bech32pair.hrp);
  }

  /// Returns the associated [address] as a Bech32 string.
  @override
  String get address {
    String bech32Hrp = _bech32Hrp ?? globalLocator<NetworkModuleBloc>().tokenDefaultDenomModel.bech32AddressPrefix!;
    return Bech32.encode(bech32Hrp, addressBytes);
  }

  @override
  List<Object?> get props => <Object?>[_bech32Hrp, ...super.props];
}
