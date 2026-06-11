import 'package:flutter/material.dart';
import 'package:language_trainer/models/quiz_item.dart';
import 'package:language_trainer/services/review_scheduler.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key, required this.scheduler});
  final ReviewScheduler scheduler;

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  late Future<Map<CardType, ({int total, int due})>> _data;

  @override
  void initState() {
    super.initState();
    _data = widget.scheduler.getStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: FutureBuilder<Map<CardType, ({int total, int due})>>(
        future: _data,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final stats = snapshot.data!;

          const groups = [
            ('Substantive', [
              ('Artikel', CardType.noun),
              ('Plural', CardType.nounPlural),
              ('Übersetzung', CardType.nounTranslation),
              ('DE schreiben', CardType.nounReverse),
            ]),
            ('Verben', [
              ('Präsens', CardType.verbPraesens),
              ('Präteritum', CardType.verbPraeteritum),
              ('Perfekt', CardType.verbPerfekt),
              ('Partizip II', CardType.verbPartizipII),
              ('Hilfsverb', CardType.verbAuxiliary),
              ('Bedeutung', CardType.verbTranslation),
              ('Verb schreiben', CardType.verbReverse),
              ('Trennbar', CardType.verbSeparable),
            ]),
            ('Adjektive', [
              ('Adj. Bedeutung', CardType.adjTranslation),
              ('Komparativ', CardType.adjComparative),
              ('Superlativ', CardType.adjSuperlative),
              ('Adj. DE schreiben', CardType.adjReverse),
            ]),
            ('Präpositionen', [
              ('Präp. Bedeutung', CardType.prepTranslation),
              ('Kasus', CardType.prepCase),
            ]),
          ];

          // Totals only count types that are enabled (total > 0).
          final totalCards = stats.values
              .where((v) => v.total > 0)
              .fold(0, (s, v) => s + v.total);
          final totalDue = stats.entries
              .where((e) => stats[e.key]!.total > 0)
              .fold(0, (s, e) => s + e.value.due);

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _StatTile(label: 'Total deck size', value: '$totalCards cards'),
              _StatTile(label: 'Due now', value: '$totalDue cards'),
              for (final group in groups) ...[
                const Divider(height: 32),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(group.$1,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          )),
                ),
                for (final row in group.$2)
                  if (stats[row.$2]!.total > 0)
                    _StatTile(
                      label: row.$1,
                      value: '${stats[row.$2]!.due} due / ${stats[row.$2]!.total} total',
                    ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
              child: Text(label,
                  style: Theme.of(context).textTheme.bodyLarge)),
          Text(value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary)),
        ],
      ),
    );
  }
}
