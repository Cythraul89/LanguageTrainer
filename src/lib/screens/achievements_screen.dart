import 'package:flutter/material.dart';
import 'package:language_trainer/models/achievement.dart';
import 'package:language_trainer/models/user_progress.dart';
import 'package:language_trainer/services/gamification_service.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key, required this.gamification});
  final GamificationService gamification;

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  late Future<UserProgress> _data;

  @override
  void initState() {
    super.initState();
    _data = widget.gamification.getProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: FutureBuilder<UserProgress>(
        future: _data,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final progress = snapshot.data!;
          final unlocked = progress.unlockedAchievements;
          final total = kAchievements.length;
          final count = kAchievements
              .where((a) => unlocked.contains(a.id))
              .length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  '$count / $total unlocked',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: kAchievements.length,
                  itemBuilder: (context, i) {
                    final a = kAchievements[i];
                    final isUnlocked = unlocked.contains(a.id);
                    return _AchievementCard(
                        achievement: a, unlocked: isUnlocked);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({
    required this.achievement,
    required this.unlocked,
  });

  final Achievement achievement;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      color: unlocked ? scheme.primaryContainer : scheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              unlocked ? achievement.emoji : '🔒',
              style: TextStyle(
                fontSize: 36,
                color: unlocked ? null : scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              achievement.title,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: unlocked
                    ? scheme.onPrimaryContainer
                    : scheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              unlocked ? achievement.description : '???',
              style: theme.textTheme.bodySmall?.copyWith(
                color: unlocked
                    ? scheme.onPrimaryContainer.withAlpha(180)
                    : scheme.onSurfaceVariant.withAlpha(120),
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
