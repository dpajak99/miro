import 'package:flutter/material.dart';
import 'package:miro/config/theme/design_colors.dart';
import 'package:miro/providers/wallet_provider.dart';
import 'package:miro/shared/models/wallet/wallet.dart';
import 'package:miro/views/layout/app_bar/account_button/account_menu_list.dart';
import 'package:miro/views/layout/scaffold/kira_scaffold.dart';
import 'package:miro/views/pages/menu/my_account_page/account_tile.dart';
import 'package:provider/provider.dart';

class AccountDrawerPage extends StatelessWidget {
  const AccountDrawerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(
      builder: (BuildContext context, WalletProvider walletProvider, _) {
        Wallet? wallet = walletProvider.currentWallet;
        if(wallet == null) {
          return const SizedBox();
        }

        return Column(
          children: <Widget>[
            AccountTile(walletAddress: wallet.address),
            const Divider(color: DesignColors.blue1_20),
            SizedBox(
              height: 500,
              child: AccountMenuList(onItemTap: () => KiraScaffold.of(context).closeEndDrawer()),
            ),
          ],
        );
      },
    );
  }
}
