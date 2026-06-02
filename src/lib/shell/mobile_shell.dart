import 'package:flutter/material.dart';
import 'shell_items.dart';

class MobileShell extends StatelessWidget {
  const MobileShell({
    super.key,
    required this.index,
    required this.onDestinationSelected,
    required this.child,
  });

  final int index;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: onDestinationSelected,
        destinations: kShellItems
            .map(
              (item) => NavigationDestination(
                icon: Icon(item.icon),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }
}
