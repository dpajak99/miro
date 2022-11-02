import 'package:flutter/material.dart';
import 'package:miro/config/theme/design_colors.dart';
import 'package:miro/views/widgets/kira/kira_tooltip.dart';
import 'package:miro/views/widgets/network_list/network_custom_section/network_custom_section.dart';
import 'package:miro/views/widgets/network_list/network_list.dart';

class NetworkDrawerPage extends StatefulWidget {
  const NetworkDrawerPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NetworkDrawerPage();
}

class _NetworkDrawerPage extends State<NetworkDrawerPage> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Center(
      child: SizedBox(
        height: 1500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Text(
                  'Choose network',
                  style: textTheme.headline3!.copyWith(
                    color: DesignColors.white_100,
                  ),
                ),
                // TODO(dominik): Add tooltip message
                const KiraToolTip(message: 'Sth about networks'),
              ],
            ),
            const SizedBox(height: 28),
            const NetworkList(),
            const NetworkCustomSection(),
          ],
        ),
      ),
    );
  }
}