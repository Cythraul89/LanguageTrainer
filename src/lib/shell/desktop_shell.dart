import 'package:flutter/material.dart';
import 'shell_items.dart';

const double _kExtendedBreakpoint = 1200;

class DesktopShell extends StatelessWidget {
  const DesktopShell({
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
    final theme = Theme.of(context);
    final extended =
        MediaQuery.sizeOf(context).width >= _kExtendedBreakpoint;

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              extended: extended,
              selectedIndex: index,
              onDestinationSelected: onDestinationSelected,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  extended ? 'Language Trainer' : 'LT',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              destinations: kShellItems
                  .map(
                    (item) => NavigationRailDestination(
                      icon: Icon(item.icon),
                      label: Text(item.label),
                    ),
                  )
                  .toList(),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
