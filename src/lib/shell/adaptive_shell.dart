import 'package:flutter/material.dart';
import 'package:language_trainer/app.dart';
import 'package:language_trainer/screens/achievements_screen.dart';
import 'package:language_trainer/screens/home_screen.dart';
import 'package:language_trainer/screens/settings_screen.dart';
import 'package:language_trainer/screens/stats_screen.dart';
import 'package:language_trainer/shell/desktop_shell.dart';
import 'package:language_trainer/shell/mobile_shell.dart';

// Below this width the app uses the mobile bottom-nav layout.
const double kDesktopBreakpoint = 600;

class AdaptiveShell extends StatefulWidget {
  const AdaptiveShell({super.key, required this.services});
  final AppServices services;

  @override
  State<AdaptiveShell> createState() => _AdaptiveShellState();
}

class _AdaptiveShellState extends State<AdaptiveShell> {
  int _index = 0;

  void _select(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    // Rebuild the active screen on every index change so FutureBuilders
    // reflect the latest DB state (e.g. after a quiz session).
    final screens = [
      HomeScreen(
        scheduler: widget.services.scheduler,
        gamification: widget.services.gamification,
      ),
      StatsScreen(scheduler: widget.services.scheduler),
      AchievementsScreen(gamification: widget.services.gamification),
      SettingsScreen(scheduler: widget.services.scheduler, db: widget.services.db),
    ];

    final width = MediaQuery.sizeOf(context).width;
    return width >= kDesktopBreakpoint
        ? DesktopShell(
            index: _index,
            onDestinationSelected: _select,
            child: screens[_index],
          )
        : MobileShell(
            index: _index,
            onDestinationSelected: _select,
            child: screens[_index],
          );
  }
}
