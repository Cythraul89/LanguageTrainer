import 'package:flutter/material.dart';
import 'package:language_trainer/models/noun.dart';
import 'package:language_trainer/services/review_scheduler.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.scheduler});
  final ReviewScheduler scheduler;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Future<Set<CefrLevel>> _levels;

  @override
  void initState() {
    super.initState();
    _levels = widget.scheduler.getSelectedLevels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: FutureBuilder<Set<CefrLevel>>(
        future: _levels,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final selected = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Practice level',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: CefrLevel.values.map((level) {
                  final active = selected.contains(level);
                  return FilterChip(
                    label: Text(level.name.toUpperCase()),
                    selected: active,
                    onSelected: (on) async {
                      if (!on && selected.length == 1) return;
                      final next = Set<CefrLevel>.from(selected);
                      on ? next.add(level) : next.remove(level);
                      await widget.scheduler.setSelectedLevels(next);
                      setState(
                          () => _levels = widget.scheduler.getSelectedLevels());
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const ListTile(
                title: const Text('Theme'),
                subtitle: const Text('Follows system setting'),
                trailing: const Icon(Icons.brightness_auto_outlined),
                enabled: false, // theme toggle planned for a future release
              ),
            ],
          );
        },
      ),
    );
  }
}
