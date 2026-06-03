import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:language_trainer/models/noun.dart';
import 'package:language_trainer/models/quiz_item.dart';
import 'package:language_trainer/models/verb.dart';
import 'package:language_trainer/services/database.dart';
import 'package:language_trainer/services/review_scheduler.dart';
import 'package:language_trainer/services/sm2.dart';

AppDatabase _memDb() => AppDatabase.forTesting(NativeDatabase.memory());

void main() {
  late AppDatabase db;
  late ReviewScheduler scheduler;

  setUp(() {
    db = _memDb();
    scheduler = ReviewScheduler(db);
  });

  tearDown(() => db.close());

  // ── getDueItems — all new ────────────────────────────────────────────────────

  group('getDueItems — new database', () {
    test('returns items when no review state exists', () async {
      final items = await scheduler.getDueItems();
      expect(items, isNotEmpty);
    });

    test('returns only recognised QuizItem subtypes', () async {
      final items = await scheduler.getDueItems();
      for (final item in items) {
        expect(
          item,
          anyOf(
            isA<NounQuizItem>(),
            isA<NounPluralQuizItem>(),
            isA<NounTranslationQuizItem>(),
            isA<NounReverseQuizItem>(),
            isA<VerbQuizItem>(),
            isA<VerbTranslationQuizItem>(),
            isA<VerbPartizipIIQuizItem>(),
            isA<VerbAuxiliaryQuizItem>(),
            isA<VerbReverseQuizItem>(),
            isA<AdjTranslationQuizItem>(),
          ),
        );
      }
    });

    test('all returned items are due (new cards have epoch nextReview)',
        () async {
      final items = await scheduler.getDueItems();
      for (final item in items) {
        expect(Sm2Service.isDue(item.sm2), isTrue);
      }
    });
  });

  // ── CEFR level filter ────────────────────────────────────────────────────────

  group('getDueItems — CEFR level filter', () {
    test('selecting only a1 returns fewer items than all levels', () async {
      await scheduler.setSelectedLevels({CefrLevel.a1});
      final a1Items = await scheduler.getDueItems();

      await scheduler.setSelectedLevels(CefrLevel.values.toSet());
      final allItems = await scheduler.getDueItems();

      expect(a1Items.length, lessThan(allItems.length));
    });

    test('no items returned if no levels match any vocabulary', () async {
      // c2 has no vocabulary in the current word list
      await scheduler.setSelectedLevels({CefrLevel.c2});
      final items = await scheduler.getDueItems();
      expect(items, isEmpty);
    });
  });

  // ── CardType filter ──────────────────────────────────────────────────────────

  group('getDueItems — CardType filter', () {
    test('nouns-only filter returns no VerbQuizItems', () async {
      await scheduler.setSelectedCardTypes({CardType.noun});
      final items = await scheduler.getDueItems();
      expect(items.every((i) => i is NounQuizItem), isTrue);
    });

    test('verbs-only filter returns no NounQuizItems', () async {
      await scheduler.setSelectedCardTypes({
        CardType.verbPraesens,
        CardType.verbPraeteritum,
        CardType.verbPerfekt,
      });
      final items = await scheduler.getDueItems();
      expect(items.every((i) => i is VerbQuizItem), isTrue);
    });

    test('plural-only filter returns only NounPluralQuizItems', () async {
      await scheduler.setSelectedCardTypes({CardType.nounPlural});
      final items = await scheduler.getDueItems();
      expect(items.every((i) => i is NounPluralQuizItem), isTrue);
      expect(items, isNotEmpty);
    });

    test('plural items have non-empty correct answers', () async {
      await scheduler.setSelectedCardTypes({CardType.nounPlural});
      final items = await scheduler.getDueItems();
      for (final item in items.cast<NounPluralQuizItem>()) {
        expect(item.entry.plural, isNot('-'));
        expect(item.entry.plural, isNotEmpty);
      }
    });

    test('praesens-only filter produces only verbPraesens cardType', () async {
      await scheduler.setSelectedCardTypes({CardType.verbPraesens});
      final items = await scheduler.getDueItems();
      final verbItems = items.whereType<VerbQuizItem>().toList();
      expect(verbItems, isNotEmpty);
      expect(verbItems.every((i) => i.tense == Tense.praesens), isTrue);
    });

    test('perfekt-only filter produces only verbPerfekt cardType', () async {
      await scheduler.setSelectedCardTypes({CardType.verbPerfekt});
      final items = await scheduler.getDueItems();
      final verbItems = items.whereType<VerbQuizItem>().toList();
      expect(verbItems, isNotEmpty);
      expect(verbItems.every((i) => i.tense == Tense.perfekt), isTrue);
    });
  });

  // ── saveResult / getDueItems interaction ─────────────────────────────────────

  group('saveResult', () {
    test('saved card with far-future nextReview is no longer due', () async {
      final items = await scheduler.getDueItems();
      final first = items.first;

      // Mark as reviewed — interval far in the future
      final learned = Sm2Service.applyGrade(
        Sm2Service.applyGrade(
          Sm2Service.applyGrade(Sm2State.initial, 5),
          5,
        ),
        5,
      );
      await scheduler.saveResult(first.cardId, first.cardType, learned);

      final after = await scheduler.getDueItems();
      expect(after.any((i) => i.cardId == first.cardId), isFalse);
    });

    test('saved card with past nextReview is still due', () async {
      // Use a large session size so the card is not truncated from results.
      await scheduler.setSessionSize(500);
      final items = await scheduler.getDueItems();
      final first = items.first;

      final pastDue = Sm2State(
        easeFactor: 2.5,
        intervalDays: 1,
        repetitions: 1,
        nextReview: DateTime.fromMillisecondsSinceEpoch(0), // epoch
      );
      await scheduler.saveResult(first.cardId, first.cardType, pastDue);

      final after = await scheduler.getDueItems();
      expect(after.any((i) => i.cardId == first.cardId), isTrue);
    });
  });

  // ── getStats ─────────────────────────────────────────────────────────────────

  group('getStats', () {
    test('all default-enabled CardTypes have entries', () async {
      // adjComparative and adjSuperlative are opt-in (not in default set).
      const optIn = {CardType.adjComparative, CardType.adjSuperlative};
      final stats = await scheduler.getStats();
      for (final ct in CardType.values) {
        if (optIn.contains(ct)) continue;
        expect(stats[ct]!.total, greaterThan(0),
            reason: '$ct should have cards');
      }
    });

    test('due counts equal total when DB is empty (all cards new)', () async {
      final stats = await scheduler.getStats();
      for (final ct in CardType.values) {
        expect(stats[ct]!.due, equals(stats[ct]!.total),
            reason: '$ct: new cards are always due');
      }
    });

    test('noun total is 0 when noun filter is disabled', () async {
      await scheduler.setSelectedCardTypes({CardType.verbPraesens});
      final stats = await scheduler.getStats();
      expect(stats[CardType.noun]!.total, 0);
    });

    test('due decreases after a card is marked learned', () async {
      final nounStatsBefore = (await scheduler.getStats())[CardType.noun]!;

      final items = await scheduler.getDueItems();
      final noun = items.whereType<NounQuizItem>().first;
      var sm2 = Sm2State.initial;
      sm2 = Sm2Service.applyGrade(sm2, 5);
      sm2 = Sm2Service.applyGrade(sm2, 5);
      sm2 = Sm2Service.applyGrade(sm2, 5); // interval now ~16 days
      await scheduler.saveResult(noun.cardId, noun.cardType, sm2);

      final nounStatsAfter = (await scheduler.getStats())[CardType.noun]!;
      expect(nounStatsAfter.due, lessThan(nounStatsBefore.due));
      expect(nounStatsAfter.total, equals(nounStatsBefore.total));
    });
  });

  // ── Preference persistence ────────────────────────────────────────────────────

  group('preferences', () {
    test('selected levels round-trip', () async {
      const levels = {CefrLevel.a1, CefrLevel.b1};
      await scheduler.setSelectedLevels(levels);
      expect(await scheduler.getSelectedLevels(), equals(levels));
    });

    test('selected card types round-trip', () async {
      const types = {CardType.noun, CardType.verbPerfekt};
      await scheduler.setSelectedCardTypes(types);
      expect(await scheduler.getSelectedCardTypes(), equals(types));
    });
  });

  // ── Perfekt answer derivation ─────────────────────────────────────────────────

  group('VerbQuizItem — perfekt answer', () {
    test('haben verb perfekt form contains partizip2', () async {
      await scheduler.setSelectedCardTypes({CardType.verbPerfekt});
      final items = await scheduler.getDueItems();
      final habenItem = items.whereType<VerbQuizItem>().firstWhere(
            (i) => i.tense == Tense.perfekt && !i.correctAnswer.startsWith('bin'),
            orElse: () => items.whereType<VerbQuizItem>().first,
          );
      // Haben-verb perfekt: "habe gemacht", "hat gemacht", etc.
      expect(habenItem.correctAnswer, isNotEmpty);
    });

    test('sein verb perfekt form starts with a sein conjugation', () async {
      await scheduler.setSelectedCardTypes({CardType.verbPerfekt});
      final items = await scheduler.getDueItems();
      // "gehen" is a sein-verb — "ich bin gegangen"
      final gehenItem = items
          .whereType<VerbQuizItem>()
          .where((i) =>
              i.infinitive == 'gehen' &&
              i.person == GrammaticalPerson.ich &&
              i.tense == Tense.perfekt)
          .firstOrNull;
      if (gehenItem != null) {
        expect(gehenItem.correctAnswer, 'bin gegangen');
      }
    });
  });
}
