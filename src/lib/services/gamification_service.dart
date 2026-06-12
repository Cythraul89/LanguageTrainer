import 'package:drift/drift.dart';
import 'package:language_trainer/models/achievement.dart';
import 'package:language_trainer/models/user_progress.dart';
import 'package:language_trainer/services/database.dart';

const _kXpCorrect = 10;
const _kXpFirstTimeBonus = 5;

class AnswerReward {
  final int xpEarned;
  final List<Achievement> unlocked;
  const AnswerReward({required this.xpEarned, required this.unlocked});
}

class SessionSummary {
  final int sessionXp;
  final int previousLevel;
  final int newLevel;
  final List<Achievement> unlocked;
  final UserProgress progress;

  const SessionSummary({
    required this.sessionXp,
    required this.previousLevel,
    required this.newLevel,
    required this.unlocked,
    required this.progress,
  });

  bool get leveledUp => newLevel > previousLevel;
}

class GamificationService {
  GamificationService(this._db);

  final AppDatabase _db;

  // ── Session-local state (reset by startSession) ───────────────────────────
  int _sessionXp = 0;
  int _consecutiveCorrect = 0;
  int _preWrongConsecutive = 0;
  final List<Achievement> _sessionUnlocked = [];
  int _sessionStartLevel = 1;

  // ── Public API ─────────────────────────────────────────────────────────────

  Future<UserProgress> getProgress() async =>
      UserProgress.fromEntry(await _db.getProgress());

  Future<void> startSession() async {
    _sessionXp = 0;
    _consecutiveCorrect = 0;
    _sessionUnlocked.clear();
    _sessionStartLevel = (await getProgress()).level;
  }

  /// Call once per card, immediately after the SM-2 result is saved.
  ///
  /// [isFirstAttempt] should be true when the card has not yet been seen in
  /// this session (regardless of its SM-2 repetition count).
  Future<AnswerReward> processAnswer({
    required bool isCorrect,
    required bool isFirstAttempt,
  }) async {
    int xp = 0;

    if (isCorrect) {
      xp = _kXpCorrect + (isFirstAttempt ? _kXpFirstTimeBonus : 0);
      _sessionXp += xp;
      _consecutiveCorrect++;
    } else {
      _preWrongConsecutive = _consecutiveCorrect;
      _consecutiveCorrect = 0;
    }

    final newlyUnlocked = <Achievement>[];
    await _db.transaction(() async {
      final row = await _db.getProgress();
      await _db.updateProgress(UserProgressEntriesCompanion(
        totalXp: Value(row.totalXp + xp),
        totalCorrect: Value(row.totalCorrect + (isCorrect ? 1 : 0)),
        totalFirstCorrect: Value(
            row.totalFirstCorrect + (isCorrect && isFirstAttempt ? 1 : 0)),
      ));
      newlyUnlocked.addAll(await _checkAndUnlock());
    });

    _sessionUnlocked.addAll(newlyUnlocked);
    return AnswerReward(xpEarned: xp, unlocked: newlyUnlocked);
  }

  /// Call instead of a second processAnswer when the user overrides a wrong
  /// answer as a typo. Undoes the streak damage and awards correct-answer XP
  /// without double-counting the card.
  Future<void> overrideLastAnswer({required bool isFirstAttempt}) async {
    // Restore the streak to what it was before the wrong answer, then credit
    // the correct answer.
    _consecutiveCorrect = _preWrongConsecutive + 1;
    final xp = _kXpCorrect + (isFirstAttempt ? _kXpFirstTimeBonus : 0);
    _sessionXp += xp;

    await _db.transaction(() async {
      final row = await _db.getProgress();
      await _db.updateProgress(UserProgressEntriesCompanion(
        totalXp: Value(row.totalXp + xp),
        totalCorrect: Value(row.totalCorrect + 1),
        totalFirstCorrect: Value(
            row.totalFirstCorrect + (isFirstAttempt ? 1 : 0)),
      ));
      _sessionUnlocked.addAll(await _checkAndUnlock());
    });
  }

  /// Call when the session queue is exhausted.
  Future<SessionSummary> completeSession() async {
    final newlyUnlocked = <Achievement>[];
    await _db.transaction(() async {
      final row = await _db.getProgress();
      await _db.updateProgress(UserProgressEntriesCompanion(
        sessionsCompleted: Value(row.sessionsCompleted + 1),
      ));
      newlyUnlocked.addAll(await _checkAndUnlock());
    });

    _sessionUnlocked.addAll(newlyUnlocked);

    final progress = await getProgress();
    return SessionSummary(
      sessionXp: _sessionXp,
      previousLevel: _sessionStartLevel,
      newLevel: progress.level,
      unlocked: List.unmodifiable(_sessionUnlocked),
      progress: progress,
    );
  }

  // ── Internals ──────────────────────────────────────────────────────────────

  Future<List<Achievement>> _checkAndUnlock() async {
    final row = await _db.getProgress();
    final already = row.unlockedAchievements.isEmpty
        ? <String>{}
        : row.unlockedAchievements.split(',').toSet();
    final progress = UserProgress.fromEntry(row);
    final newIds = <String>[];
    final newAchievements = <Achievement>[];

    for (final a in kAchievements) {
      if (already.contains(a.id)) continue;
      if (_isMet(a, progress)) {
        already.add(a.id);
        newIds.add(a.id);
        newAchievements.add(a);
      }
    }

    if (newIds.isNotEmpty) {
      await _db.updateProgress(UserProgressEntriesCompanion(
        unlockedAchievements: Value(already.join(',')),
      ));
    }

    return newAchievements;
  }

  bool _isMet(Achievement a, UserProgress p) => switch (a.trigger) {
        AchievementTrigger.firstCorrect => p.totalCorrect >= 1,
        AchievementTrigger.correct50 => p.totalCorrect >= 50,
        AchievementTrigger.correct100 => p.totalCorrect >= 100,
        AchievementTrigger.correct500 => p.totalCorrect >= 500,
        AchievementTrigger.firstCorrect100 => p.totalFirstCorrect >= 100,
        AchievementTrigger.level5 => p.level >= 5,
        AchievementTrigger.level10 => p.level >= 10,
        AchievementTrigger.level20 => p.level >= 20,
        AchievementTrigger.consecutive10 => _consecutiveCorrect >= 10,
        AchievementTrigger.firstSession => p.sessionsCompleted >= 1,
      };
}
