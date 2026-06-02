import 'package:flutter_test/flutter_test.dart';
import 'package:language_trainer/models/user_progress.dart';

void main() {
  group('UserProgress.level', () {
    test('0 XP is level 1', () {
      expect(UserProgress.initial.level, 1);
    });

    test('99 XP is still level 1', () {
      final p = UserProgress.initial.copyWith(totalXp: 99);
      expect(p.level, 1);
    });

    test('100 XP reaches level 2', () {
      final p = UserProgress.initial.copyWith(totalXp: 100);
      expect(p.level, 2);
    });

    test('300 XP reaches level 3 (cumulative: 100+200)', () {
      final p = UserProgress.initial.copyWith(totalXp: 300);
      expect(p.level, 3);
    });

    test('level 4 threshold is 600 XP (100+200+300)', () {
      expect(UserProgress.initial.copyWith(totalXp: 599).level, 3);
      expect(UserProgress.initial.copyWith(totalXp: 600).level, 4);
    });

    test('very high XP produces level > 1', () {
      final p = UserProgress.initial.copyWith(totalXp: 10000);
      expect(p.level, greaterThan(10));
    });
  });

  group('UserProgress.xpIntoLevel', () {
    test('0 XP → 0 into level 1', () {
      expect(UserProgress.initial.xpIntoLevel, 0);
    });

    test('50 XP → 50 into level 1', () {
      final p = UserProgress.initial.copyWith(totalXp: 50);
      expect(p.xpIntoLevel, 50);
    });

    test('at level 2 start → 0 into level 2', () {
      // Level 2 starts at 100 XP
      final p = UserProgress.initial.copyWith(totalXp: 100);
      expect(p.xpIntoLevel, 0);
    });

    test('150 XP → 50 into level 2', () {
      final p = UserProgress.initial.copyWith(totalXp: 150);
      expect(p.xpIntoLevel, 50);
    });
  });

  group('UserProgress.xpForNextLevel', () {
    test('level 1 needs 100 XP', () {
      expect(UserProgress.initial.xpForNextLevel, 100);
    });

    test('level 2 needs 200 XP', () {
      final p = UserProgress.initial.copyWith(totalXp: 100);
      expect(p.level, 2);
      expect(p.xpForNextLevel, 200);
    });
  });

  group('UserProgress.levelProgress', () {
    test('0 XP → 0.0 progress', () {
      expect(UserProgress.initial.levelProgress, 0.0);
    });

    test('50 XP → 0.5 progress through level 1 (needs 100)', () {
      final p = UserProgress.initial.copyWith(totalXp: 50);
      expect(p.levelProgress, closeTo(0.5, 0.001));
    });

    test('at level boundary → 0.0 progress', () {
      final p = UserProgress.initial.copyWith(totalXp: 100);
      expect(p.levelProgress, 0.0);
    });
  });
}

// Minimal copyWith helper for tests — UserProgress is const so we build new.
extension _UserProgressCopyWith on UserProgress {
  UserProgress copyWith({int? totalXp}) => UserProgress(
        totalXp: totalXp ?? this.totalXp,
        totalCorrect: totalCorrect,
        totalFirstCorrect: totalFirstCorrect,
        sessionsCompleted: sessionsCompleted,
        unlockedAchievements: unlockedAchievements,
      );
}
