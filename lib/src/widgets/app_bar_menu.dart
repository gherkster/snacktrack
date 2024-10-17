import 'package:flutter/material.dart';
import 'package:snacktrack/src/styles/layout.dart';

class AppBarMenu extends StatelessWidget {
  const AppBarMenu({super.key, required this.menuItems});

  final List<Widget> menuItems;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder: (context, controller, child) {
        return Padding(
          padding: const EdgeInsets.only(right: Spacing.small),
          child: IconButton(
            onPressed: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            icon: const Icon(Icons.more_vert),
          ),
        );
      },
      menuChildren: menuItems,
    );
  }
}
