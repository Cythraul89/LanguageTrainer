import 'package:flutter/material.dart';

class ShellItem {
  final String label;
  final IconData icon;
  const ShellItem(this.label, this.icon);
}

const kShellItems = [
  ShellItem('Home', Icons.home_outlined),
  ShellItem('Stats', Icons.bar_chart_outlined),
  ShellItem('Achievements', Icons.emoji_events_outlined),
  ShellItem('Settings', Icons.settings_outlined),
];
