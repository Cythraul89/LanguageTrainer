import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:language_trainer/services/database.dart';
import 'package:language_trainer/services/gamification_service.dart';

AppDatabase _memDb() => AppDatabase.forTesting(NativeDatabase.memory());

void main() {
  late AppDatabase db;
  late GamificationService svc;

  setUp(() {
    db = _memDb();
    svc = GamificationService(db);
  });

  tearDown(() => db.close());

  // ── XP ──────────────────────────────────────────────────────────────────────

  group('processAnswer — XP', () {
    test('correct first-attempt awards 15 XP', () async {
      await svc.startSession();
      final reward =
          await svc.processAnswer(isCorrect: true, isFirstAttempt: true);
      expect(reward.xpEarned, 15);
    });

    test('correct non-first-attempt awards 10 XP', () async {
      await svc.startSession();
      final reward =
          await svc.processAnswer(isCorrect: true, isFirstAttempt: false);
      expect(reward.xpEarned, 10);
    });

    test('wrong answer awards 0 XP', () async {
      await svc.startSession();
      final reward =
          await svc.processAnswer(isCorrect: false, isFirstAttempt: true);
      expect(reward.xpEarned, 0);
    });

    test('XP accumulates in the database', () async {
      await svc.startSession();
      await svc.processAnswer(isCorrect: true, isFirstAttempt: true); // +15
      await svc.processAnswer(isCorrect: true, isFirstAttempt: false); // +10
      final progress = await svc.getProgress();
      expect(progress.totalXp, 25);
    });

    test('wrong answer does not change stored XP', () async {
      await svc.startSession();
      await svc.processAnswer(isCorrect: false, isFirstAttempt: true);
      final progress = await svc.getProgress();
      expect(progress.totalXp, 0);
    });
  });

  // ── Correct counters ─────────────────────────────────────────────────────────

  group('processAnswer — counters', () {
    test('correct answer increments totalCorrect', () async {
      await svc.startSession();
      await svc.processAnswer(isCorrect: true, isFirstAttempt: false);
      expect((await svc.getProgress()).totalCorrect, 1);
    });

    test('wrong answer does not increment totalCorrect', () async {
      await svc.startSession();
      await svc.processAnswer(isCorrect: false, isFirstAttempt: false);
      expect((await svc.getProgress()).totalCorrect, 0);
    });

    test('first-attempt correct increments totalFirstCorrect', () async {
      await svc.startSession();
      await svc.processAnswer(isCorrect: true, isFirstAttempt: true);
      expect((await svc.getProgress()).totalFirstCorrect, 1);
    });

    test('non-first-attempt correct does not increment totalFirstCorrect',
        () async {
      await svc.startSession();
      await svc.processAnswer(isCorrect: true, isFirstAttempt: false);
      expect((await svc.getProgress()).totalFirstCorrect, 0);
    });
  });

  // ── Session XP ───────────────────────────────────────────────────────────────

  group('completeSession — session XP', () {
    test('sessionXp reflects answers given in session', () async {
      await svc.startSession();
      await svc.processAnswer(isCorrect: true, isFirstAttempt: true); // +15
      await svc.processAnswer(isCorrect: true, isFirstAttempt: false); // +10
      await svc.processAnswer(isCorrect: false, isFirstAttempt: true); // +0
      final summary = await svc.completeSession();
      expect(summary.sessionXp, 25);
    });

    test('startSession resets session XP counter', () async {
      await svc.startSession();
      await svc.processAnswer(isCorrect: true, isFirstAttempt: false); // +10
      await svc.completeSession();

      await svc.startSession();
      final summary = await svc.completeSession();
      expect(summary.sessionXp, 0);
    });

    test('completeSession increments sessionsCompleted', () async {
      await svc.startSession();
      await svc.completeSession();
      expect((await svc.getProgress()).sessionsCompleted, 1);
    });

    test('level-up is detected in session summary', () async {
      await svc.startSession();
      // 100 XP needed for level 2: 7 first-attempt correct (105 XP)
      for (var i = 0; i < 7; i++) {
        await svc.processAnswer(isCorrect: true, isFirstAttempt: true);
      }
      final summary = await svc.completeSession();
      expect(summary.leveledUp, isTrue);
      expect(summary.newLevel, greaterThan(summary.previousLevel));
    });
  });

  // ── Achievements ─────────────────────────────────────────────────────────────

  group('achievements', () {
    test('first_correct unlocked after first correct answer', () async {
      await svc.startSession();
      final reward =
          await svc.processAnswer(isCorrect: true, isFirstAttempt: false);
      expect(reward.unlocked.map((a) => a.id), contains('first_correct'));
    });

    test('first_correct not awarded on wrong answer', () async {
      await svc.startSession();
      final reward =
          await svc.processAnswer(isCorrect: false, isFirstAttempt: false);
      expect(reward.unlocked, isEmpty);
    });

    test('first_correct not re-awarded on second correct answer', () async {
      await svc.startSession();
      await svc.processAnswer(isCorrect: true, isFirstAttempt: false);
      final reward =
          await svc.processAnswer(isCorrect: true, isFirstAttempt: false);
      expect(reward.unlocked.map((a) => a.id), isNot(contains('first_correct')));
    });

    test('first_session awarded in completeSession', () async {
      await svc.startSession();
      final summary = await svc.completeSession();
      expect(summary.unlocked.map((a) => a.id), contains('first_session'));
    });

    test('first_session not re-awarded on second session', () async {
      await svc.startSession();
      await svc.completeSession();

      await svc.startSession();
      final summary2 = await svc.completeSession();
      expect(
          summary2.unlocked.map((a) => a.id), isNot(contains('first_session')));
    });

    test('consecutive_10 awarded after 10 correct in a row', () async {
      await svc.startSession();
      AnswerReward? last;
      for (var i = 0; i < 10; i++) {
        last = await svc.processAnswer(isCorrect: true, isFirstAttempt: false);
      }
      expect(last!.unlocked.map((a) => a.id), contains('consecutive_10'));
    });

    test('wrong answer resets consecutive streak', () async {
      await svc.startSession();
      for (var i = 0; i < 9; i++) {
        await svc.processAnswer(isCorrect: true, isFirstAttempt: false);
      }
      await svc.processAnswer(isCorrect: false, isFirstAttempt: false);
      // One more correct — streak is 1, not 10
      final reward =
          await svc.processAnswer(isCorrect: true, isFirstAttempt: false);
      expect(
          reward.unlocked.map((a) => a.id), isNot(contains('consecutive_10')));
    });

    test('session summary includes all achievements unlocked during session',
        () async {
      await svc.startSession();
      await svc.processAnswer(isCorrect: true, isFirstAttempt: false);
      final summary = await svc.completeSession();
      final ids = summary.unlocked.map((a) => a.id).toList();
      expect(ids, containsAll(['first_correct', 'first_session']));
    });
  });
}
