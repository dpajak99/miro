import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miro/config/locator.dart';
import 'package:miro/config/theme/design_colors.dart';
import 'package:miro/providers/wallet_provider.dart';
import 'package:miro/shared/router/router.gr.dart';
import 'package:miro/views/widgets/generic/mouse_state_listener.dart';

class AccountMenuList extends StatelessWidget {
  final VoidCallback? onItemTap;

  const AccountMenuList({
    this.onItemTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        _MenuListTile(
          onTap: () => _onNavigateToMyAccountPressed(context),
          title: 'My account',
        ),
        _MenuListTile(
          onTap: () {},
          title: 'Settings',
        ),
        _MenuListTile(
          onTap: () => _onLogout(context),
          title: 'Log Out',
          color: DesignColors.red_100,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  void _onNavigateToMyAccountPressed(BuildContext context) {
    if (onItemTap != null) {
      onItemTap!();
    }
    AutoRouter.of(context).navigate(const MyAccountRoute());
  }

  void _onLogout(BuildContext context) {
    if (onItemTap != null) {
      onItemTap!();
    }
    globalLocator<WalletProvider>().logout(context);
    AutoRouter.of(context).replace(const DashboardRoute());
  }
}

class _MenuListTile extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final Color? color;

  const _MenuListTile({
    required this.onTap,
    required this.title,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return MouseStateListener(
      onTap: onTap,
      childBuilder: (Set<MaterialState> states) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            title,
            style: textTheme.bodyText2!.copyWith(
              color: _selectColor(states),
            ),
          ),
        );
      },
    );
  }

  Color _selectColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.hovered)) {
      return DesignColors.white_100;
    } else if (color != null) {
      return color!;
    } else {
      return DesignColors.gray2_100;
    }
  }
}
