import 'package:flutter/material.dart';
import 'package:miro/views/widgets/generic/filled_scroll_view.dart';

class KiraDrawer extends StatelessWidget {
  final Widget child;
  final Widget? popButton;
  final double width;
  final Function onClose;
  final WillPopCallback? onWillPop;
  final Color? drawerColor;

  const KiraDrawer({
    required this.onClose,
    required this.child,
    this.popButton,
    this.onWillPop,
    this.drawerColor,
    this.width = 400,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: WillPopScope(
        onWillPop: onWillPop != null ? () => onWillPop!() : null,
        child: SizedBox(
          width: width,
          height: double.infinity,
          child: Drawer(
            child: Container(
              color: drawerColor,
              height: double.infinity,
              width: width,
              child: FilledScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (popButton != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 30, left: 20),
                        child: popButton,
                      ),
                    const SizedBox(height: 40),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: child,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
