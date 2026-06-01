import 'package:flutter/material.dart';
import 'package:language_trainer/models/quiz_item.dart';
import 'package:language_trainer/services/review_scheduler.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key, required this.scheduler});
  final ReviewScheduler scheduler;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: FutureBuilder<Map<CardType, ({int total, int due})>>(
        future: scheduler.getStats(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final stats = snapshot.data!;
          final rows = [
            ('Nouns', CardType.noun),
            ('Verbs — Präsens', CardType.verbPraesens),
            ('Verbs — Präteritum', CardType.verbPraeteritum),
            ('Verbs — Perfekt', CardType.verbPerfekt),
          ];
          final totalCards = stats.values.fold(0, (s, v) => s + v.total);
          final totalDue = stats.values.fold(0, (s, v) => s + v.due);

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _StatTile(
                  label: 'Total deck size',
                  value: '$totalCards cards'),
              _StatTile(
                  label: 'Due now',
                  value: '$totalDue cards'),
              const Divider(height: 32),
              ...rows.map((r) {
                final s = stats[r.$2]!;
                return _StatTile(
                  label: r.$1,
                  value: '${s.due} due / ${s.total} total',
                );
              }),
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
