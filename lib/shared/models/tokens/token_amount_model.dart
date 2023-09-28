import 'package:decimal/decimal.dart';
import 'package:miro/shared/models/tokens/token_alias_model.dart';
import 'package:miro/shared/models/tokens/token_denomination_model.dart';

class TokenAmountModel {
  final TokenAliasModel tokenAliasModel;
  late Decimal _lowestDenominationAmount;

  TokenAmountModel({
    required Decimal lowestDenominationAmount,
    required this.tokenAliasModel,
  }) {
    if (lowestDenominationAmount < Decimal.zero) {
      _lowestDenominationAmount = Decimal.fromInt(-1);
    } else {
      _lowestDenominationAmount = lowestDenominationAmount;
    }
  }

  TokenAmountModel.zero({required this.tokenAliasModel}) : _lowestDenominationAmount = Decimal.zero;

  factory TokenAmountModel.fromString(String value) {
    RegExp regExpPattern = RegExp(r'(\d+)([a-zA-Z0-9/]+)');
    RegExpMatch regExpMatch = regExpPattern.firstMatch(value)!;

    Decimal amount = Decimal.parse(regExpMatch.group(1)!);
    String denom = regExpMatch.group(2)!;

    return TokenAmountModel(
      lowestDenominationAmount: amount,
      tokenAliasModel: TokenAliasModel.local(denom),
    );
  }

  TokenAmountModel copy() {
    return TokenAmountModel(
      lowestDenominationAmount: _lowestDenominationAmount,
      tokenAliasModel: tokenAliasModel,
    );
  }

  int compareTo(TokenAmountModel tokenAmountModel) {
    return tokenAmountModel._lowestDenominationAmount.compareTo(_lowestDenominationAmount);
  }

  Decimal getAmountInLowestDenomination() {
    return _lowestDenominationAmount;
  }

  Decimal getAmountInDefaultDenomination() {
    return getAmountInDenomination(tokenAliasModel.defaultTokenDenominationModel);
  }

  Decimal getAmountInDenomination(TokenDenominationModel tokenDenominationModel) {
    bool isLowestTokenDenomination = tokenDenominationModel == tokenAliasModel.lowestTokenDenominationModel;
    if (isLowestTokenDenomination) {
      return _lowestDenominationAmount;
    }
    int decimalsDifference = tokenAliasModel.lowestTokenDenominationModel.decimals - tokenDenominationModel.decimals;
    Decimal calculatedAmount = _lowestDenominationAmount.shift(decimalsDifference);
    return calculatedAmount;
  }

  void setAmount(Decimal amount, {TokenDenominationModel? tokenDenominationModel}) {
    if (amount < Decimal.zero) {
      throw ArgumentError('Amount must be greater than zero');
    }
    TokenDenominationModel lowestTokenDenomination = tokenAliasModel.lowestTokenDenominationModel;

    bool isLowestTokenDenomination = tokenDenominationModel == null || tokenDenominationModel == lowestTokenDenomination;
    if (isLowestTokenDenomination) {
      _lowestDenominationAmount = amount;
    } else {
      int decimalsDifference = tokenDenominationModel.decimals - lowestTokenDenomination.decimals;
      _lowestDenominationAmount = amount.shift(decimalsDifference);
    }
  }

  TokenAmountModel operator +(TokenAmountModel tokenAmountModel) {
    if (tokenAmountModel.tokenAliasModel != tokenAliasModel) {
      return this;
    }
    Decimal newAmount = _lowestDenominationAmount + tokenAmountModel._lowestDenominationAmount;
    return TokenAmountModel(
      lowestDenominationAmount: newAmount,
      tokenAliasModel: tokenAliasModel,
    );
  }

  TokenAmountModel operator -(TokenAmountModel tokenAmountModel) {
    if (tokenAmountModel.tokenAliasModel != tokenAliasModel) {
      return this;
    }
    Decimal newAmount = _lowestDenominationAmount - tokenAmountModel._lowestDenominationAmount;
    return TokenAmountModel(
      lowestDenominationAmount: newAmount < Decimal.zero ? Decimal.zero : newAmount,
      tokenAliasModel: tokenAliasModel,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TokenAmountModel &&
          runtimeType == other.runtimeType &&
          _lowestDenominationAmount == other._lowestDenominationAmount &&
          tokenAliasModel == other.tokenAliasModel;

  @override
  int get hashCode => _lowestDenominationAmount.hashCode ^ tokenAliasModel.hashCode;

  @override
  String toString() {
    return '${_lowestDenominationAmount} ${tokenAliasModel.lowestTokenDenominationModel.name}';
  }
}
