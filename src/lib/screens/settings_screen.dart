import 'package:flutter/material.dart';
import 'package:language_trainer/models/noun.dart';
import 'package:language_trainer/screens/about_screen.dart';
import 'package:language_trainer/services/database.dart';
import 'package:language_trainer/services/review_scheduler.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.scheduler, required this.db});
  final ReviewScheduler scheduler;
  final AppDatabase db;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Future<_SettingsData> _data;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() => setState(() { _data = _load(); });

  Future<_SettingsData> _load() async {
    final results = await Future.wait([
      widget.scheduler.getSelectedLevels(),
      widget.scheduler.getSessionSize(),
    ]);
    return _SettingsData(
      levels: results[0] as Set<CefrLevel>,
      sessionSize: results[1] as int,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: FutureBuilder<_SettingsData>(
        future: _data,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final d = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ── Practice level ───────────────────────────────────────────
              Text('Practice level',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: CefrLevel.values.map((level) {
                  final active = d.levels.contains(level);
                  return FilterChip(
                    label: Text(level.name.toUpperCase()),
                    selected: active,
                    onSelected: (on) async {
                      if (!on && d.levels.length == 1) return;
                      final next = Set<CefrLevel>.from(d.levels);
                      on ? next.add(level) : next.remove(level);
                      await widget.scheduler.setSelectedLevels(next);
                      _reload();
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              const Divider(),
              // ── Session size ─────────────────────────────────────────────
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text('Cards per session',
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Text(
                    '${d.sessionSize}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              Slider(
                value: d.sessionSize.toDouble(),
                min: 5,
                max: 50,
                divisions: 9,
                label: '${d.sessionSize}',
                onChanged: (v) async {
                  await widget.scheduler.setSessionSize(v.round());
                  _reload();
                },
              ),
              const SizedBox(height: 8),
              const Divider(),
              // ── Theme ────────────────────────────────────────────────────
              const ListTile(
                title: Text('Theme'),
                subtitle: Text('Follows system setting'),
                trailing: Icon(Icons.brightness_auto_outlined),
                enabled: false,
              ),
              const Divider(),
              // ── About ────────────────────────────────────────────────────
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About'),
                subtitle: const Text('Version, licence, log export'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AboutScreen(db: widget.db),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SettingsData {
  final Set<CefrLevel> levels;
  final int sessionSize;
  const _SettingsData({required this.levels, required this.sessionSize});
}
