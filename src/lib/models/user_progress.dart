import 'dart:math';

import 'package:language_trainer/services/database.dart';

/// Derived value class — computed from the raw DB row.
///
/// Level N requires cumulative XP = 100·(N−1)·N/2.
/// Level from XP: N = floor((1 + sqrt(1 + 8·xp/100)) / 2), clamped ≥ 1.
class UserProgress {
  final int totalXp;
  final int totalCorrect;
  final int totalFirstCorrect;
  final int sessionsCompleted;
  final Set<String> unlockedAchievements;

  const UserProgress({
    required this.totalXp,
    required this.totalCorrect,
    required this.totalFirstCorrect,
    required this.sessionsCompleted,
    required this.unlockedAchievements,
  });

  static final initial = UserProgress(
    totalXp: 0,
    totalCorrect: 0,
    totalFirstCorrect: 0,
    sessionsCompleted: 0,
    unlockedAchievements: const <String>{},
  );

  factory UserProgress.fromEntry(UserProgressEntry e) => UserProgress(
        totalXp: e.totalXp,
        totalCorrect: e.totalCorrect,
        totalFirstCorrect: e.totalFirstCorrect,
        sessionsCompleted: e.sessionsCompleted,
        unlockedAchievements: e.unlockedAchievements.isEmpty
            ? const <String>{}
            : e.unlockedAchievements.split(',').toSet(),
      );

  int get level =>
      max(1, ((1 + sqrt(1 + 8 * totalXp / 100)) / 2).floor());

  /// XP accumulated within the current level.
  int get xpIntoLevel => totalXp - _cumulativeXp(level);

  /// XP needed to complete the current level (i.e. gap to next level).
  int get xpForNextLevel => level * 100;

  double get levelProgress =>
      xpForNextLevel == 0 ? 0.0 : xpIntoLevel / xpForNextLevel;

  static int _cumulativeXp(int level) => 100 * (level - 1) * level ~/ 2;
}
