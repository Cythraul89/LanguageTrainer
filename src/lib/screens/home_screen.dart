import 'package:flutter/material.dart';
import 'package:language_trainer/models/noun.dart';
import 'package:language_trainer/models/quiz_item.dart';
import 'package:language_trainer/screens/quiz_screen.dart';
import 'package:language_trainer/screens/stats_screen.dart';
import 'package:language_trainer/services/review_scheduler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.scheduler});
  final ReviewScheduler scheduler;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<_HomeData> _data;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _data = _load();
    });
  }

  Future<_HomeData> _load() async {
    final stats = await widget.scheduler.getStats();
    final levels = await widget.scheduler.getSelectedLevels();
    final totalDue = stats.values.fold(0, (sum, s) => sum + s.due);
    return _HomeData(stats: stats, levels: levels, totalDue: totalDue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Trainer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StatsScreen(scheduler: widget.scheduler),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<_HomeData>(
        future: _data,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final d = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _LevelSelector(
                  selected: d.levels,
                  onChanged: (levels) async {
                    await widget.scheduler.setSelectedLevels(levels);
                    _refresh();
                  },
                ),
                const SizedBox(height: 24),
                _DueSummary(stats: d.stats),
                const Spacer(),
                FilledButton.icon(
                  onPressed: d.totalDue == 0
                      ? null
                      : () async {
                          final items =
                              await widget.scheduler.getDueItems();
                          if (!context.mounted) return;
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuizScreen(
                                items: items,
                                scheduler: widget.scheduler,
                              ),
                            ),
                          );
                          _refresh();
                        },
                  icon: const Icon(Icons.play_arrow),
                  label: Text(
                    d.totalDue == 0
                        ? 'Nothing due'
                        : 'Start review (${d.totalDue})',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Level selector ────────────────────────────────────────────────────────────

class _LevelSelector extends StatelessWidget {
  const _LevelSelector({required this.selected, required this.onChanged});
  final Set<CefrLevel> selected;
  final void Function(Set<CefrLevel>) onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: CefrLevel.values.map((level) {
        final active = selected.contains(level);
        return FilterChip(
          label: Text(level.name.toUpperCase()),
          selected: active,
          onSelected: (on) {
            final next = Set<CefrLevel>.from(selected);
            on ? next.add(level) : next.remove(level);
            if (next.isNotEmpty) onChanged(next);
          },
        );
      }).toList(),
    );
  }
}

// ── Due summary ───────────────────────────────────────────────────────────────

class _DueSummary extends StatelessWidget {
  const _DueSummary({required this.stats});
  final Map<CardType, ({int total, int due})> stats;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Nouns', CardType.noun),
      ('Präsens', CardType.verbPraesens),
      ('Präteritum', CardType.verbPraeteritum),
      ('Perfekt', CardType.verbPerfekt),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Due today', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...rows.map((r) {
              final s = stats[r.$2]!;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Expanded(child: Text(r.$1)),
                    Text('${s.due} / ${s.total}',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _HomeData {
  final Map<CardType, ({int total, int due})> stats;
  final Set<CefrLevel> levels;
  final int totalDue;
  const _HomeData(
      {required this.stats, required this.levels, required this.totalDue});
}
