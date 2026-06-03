import 'package:flutter/material.dart';
import 'package:language_trainer/models/noun.dart';
import 'package:language_trainer/models/quiz_item.dart';
import 'package:language_trainer/models/user_progress.dart';
import 'package:language_trainer/screens/quiz_screen.dart';
import 'package:language_trainer/services/gamification_service.dart';
import 'package:language_trainer/services/review_scheduler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.scheduler,
    required this.gamification,
  });
  final ReviewScheduler scheduler;
  final GamificationService gamification;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<_HomeData> _data;

  @override
  void initState() {
    super.initState();
    _refresh();
    _maybShowBirthdayGreeting();
  }

  void _maybShowBirthdayGreeting() {
    final now = DateTime.now();
    if (now.month == 6 && now.day == 3) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('🎂 Alles Gute zum Geburtstag Nkule! ❤️'),
            content: const Text(
              'Ich wünsche dir einen wunderschönen Geburtstag! 🎉',
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Danke! 😊'),
              ),
            ],
          ),
        );
      });
    }
  }

  void _refresh() => setState(() { _data = _load(); });

  Future<_HomeData> _load() async {
    final results = await Future.wait([
      widget.scheduler.getStats(),
      widget.scheduler.getSelectedLevels(),
      widget.scheduler.getSelectedCardTypes(),
      widget.gamification.getProgress(),
    ]);
    final stats     = results[0] as Map<CardType, ({int total, int due})>;
    final levels    = results[1] as Set<CefrLevel>;
    final cardTypes = results[2] as Set<CardType>;
    final progress  = results[3] as UserProgress;
    final totalDue  = stats.entries
        .where((e) => cardTypes.contains(e.key))
        .fold(0, (s, e) => s + e.value.due);
    return _HomeData(
        stats: stats, levels: levels, cardTypes: cardTypes,
        progress: progress, totalDue: totalDue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Language Trainer')),
      body: FutureBuilder<_HomeData>(
        future: _data,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final d = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _XpCard(progress: d.progress),
              const SizedBox(height: 16),
              _LevelSelector(
                selected: d.levels,
                onChanged: (levels) async {
                  await widget.scheduler.setSelectedLevels(levels);
                  _refresh();
                },
              ),
              const SizedBox(height: 16),
              _CategorySelector(
                selected: d.cardTypes,
                onChanged: (types) async {
                  await widget.scheduler.setSelectedCardTypes(types);
                  _refresh();
                },
              ),
              const SizedBox(height: 16),
              _DueSummaryCard(stats: d.stats, selectedTypes: d.cardTypes),
              const SizedBox(height: 24),
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
                              gamification: widget.gamification,
                            ),
                          ),
                        );
                        _refresh();
                      },
                icon: const Icon(Icons.play_arrow),
                label: Text(
                  d.totalDue == 0
                      ? 'Nothing due'
                      : 'Start Review (${d.totalDue})',
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── XP progress card ──────────────────────────────────────────────────────────

class _XpCard extends StatelessWidget {
  const _XpCard({required this.progress});
  final UserProgress progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Level ${progress.level}',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  '${progress.xpIntoLevel} / ${progress.xpForNextLevel} XP',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress.levelProgress,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${progress.totalCorrect} correct answers total',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
              onSelected: (on) {
                if (!on && selected.length == 1) return; // keep ≥ 1
                final next = Set<CefrLevel>.from(selected);
                on ? next.add(level) : next.remove(level);
                onChanged(next);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ── Category selector ─────────────────────────────────────────────────────────

class _CategorySelector extends StatelessWidget {
  const _CategorySelector({required this.selected, required this.onChanged});
  final Set<CardType> selected;
  final void Function(Set<CardType>) onChanged;

  static const _labels = {
    CardType.noun: 'Artikel',
    CardType.nounPlural: 'Plural',
    CardType.nounTranslation: 'Übersetzung',
    CardType.nounReverse: 'DE schreiben',
    CardType.verbPraesens: 'Präsens',
    CardType.verbPraeteritum: 'Präteritum',
    CardType.verbPerfekt: 'Perfekt',
    CardType.verbPartizipII: 'Partizip II',
    CardType.verbAuxiliary: 'Hilfsverb',
    CardType.verbTranslation: 'Bedeutung',
    CardType.verbReverse: 'Verb schreiben',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Practice category',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: CardType.values.map((type) {
            final active = selected.contains(type);
            return FilterChip(
              label: Text(_labels[type]!),
              selected: active,
              onSelected: (on) {
                if (!on && selected.length == 1) return; // keep ≥ 1
                final next = Set<CardType>.from(selected);
                on ? next.add(type) : next.remove(type);
                onChanged(next);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ── Due summary card ──────────────────────────────────────────────────────────

class _DueSummaryCard extends StatelessWidget {
  const _DueSummaryCard({required this.stats, required this.selectedTypes});
  final Map<CardType, ({int total, int due})> stats;
  final Set<CardType> selectedTypes;

  @override
  Widget build(BuildContext context) {
    const rows = [
      ('Artikel', CardType.noun),
      ('Plural', CardType.nounPlural),
      ('Übersetzung (N)', CardType.nounTranslation),
      ('DE schreiben (N)', CardType.nounReverse),
      ('Präsens', CardType.verbPraesens),
      ('Präteritum', CardType.verbPraeteritum),
      ('Perfekt', CardType.verbPerfekt),
      ('Partizip II', CardType.verbPartizipII),
      ('Hilfsverb', CardType.verbAuxiliary),
      ('Bedeutung (V)', CardType.verbTranslation),
      ('Verb schreiben', CardType.verbReverse),
    ];
    final totalDue = stats.entries
        .where((e) => selectedTypes.contains(e.key))
        .fold(0, (s, e) => s + e.value.due);
    final totalAll = stats.entries
        .where((e) => selectedTypes.contains(e.key))
        .fold(0, (s, e) => s + e.value.total);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Due today',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...rows.map((r) {
              final active = selectedTypes.contains(r.$2);
              final s = stats[r.$2]!;
              return _StatRow(
                label: r.$1,
                due: s.due,
                total: s.total,
                dimmed: !active,
              );
            }),
            const Divider(height: 16),
            _StatRow(label: 'Total', due: totalDue, total: totalAll, bold: true),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.due,
    required this.total,
    this.bold = false,
    this.dimmed = false,
  });
  final String label;
  final int due;
  final int total;
  final bool bold;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final baseStyle = bold
        ? Theme.of(context).textTheme.bodyMedium
            ?.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.bodyMedium;
    final style = dimmed
        ? baseStyle?.copyWith(color: scheme.onSurfaceVariant.withAlpha(100))
        : baseStyle;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(
            '$due / $total',
            style: style?.copyWith(
              color: dimmed
                  ? scheme.onSurfaceVariant.withAlpha(100)
                  : scheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeData {
  final Map<CardType, ({int total, int due})> stats;
  final Set<CefrLevel> levels;
  final Set<CardType> cardTypes;
  final UserProgress progress;
  final int totalDue;
  const _HomeData({
    required this.stats,
    required this.levels,
    required this.cardTypes,
    required this.progress,
    required this.totalDue,
  });
}
