import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:language_trainer/data/prepositions.dart';
import 'package:language_trainer/data/verbs.dart';
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
      // Enable all types so every subtype can appear.
      await scheduler.setSelectedCardTypes(CardType.values.toSet());
      final items = await scheduler.getDueItems();
      for (final item in items) {
        expect(
          item,
          anyOf([
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
            isA<AdjComparativeQuizItem>(),
            isA<AdjSuperlativeQuizItem>(),
            isA<AdjReverseQuizItem>(),
            isA<VerbSeparableQuizItem>(),
            isA<PrepTranslationQuizItem>(),
            isA<PrepCaseQuizItem>(),
          ]),
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
      // Use getStats (no session cap) so the comparison is not truncated.
      await scheduler.setSelectedLevels({CefrLevel.a1});
      final a1Stats = await scheduler.getStats();
      final a1Total = a1Stats.values.fold(0, (s, v) => s + v.total);

      await scheduler.setSelectedLevels(CefrLevel.values.toSet());
      final allStats = await scheduler.getStats();
      final allTotal = allStats.values.fold(0, (s, v) => s + v.total);

      expect(a1Total, lessThan(allTotal));
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
      await scheduler.setSessionSize(50000);
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
      // These types are opt-in (not in the default selected set).
      const optIn = {
        CardType.adjComparative,
        CardType.adjSuperlative,
        CardType.adjReverse,
        CardType.verbSeparable,
        CardType.prepTranslation,
        CardType.prepCase,
      };
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

      await scheduler.setSessionSize(50000);
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
    test('haben verb perfekt form is "habe/hat/... <partizip2>"', () async {
      await scheduler.setSelectedCardTypes({CardType.verbPerfekt});
      await scheduler.setSessionSize(50000);
      final items = await scheduler.getDueItems();
      // machen (haben-verb, ich): "habe gemacht"
      final machenIch = items
          .whereType<VerbQuizItem>()
          .where((i) =>
              i.infinitive == 'machen' &&
              i.person == GrammaticalPerson.ich &&
              i.tense == Tense.perfekt)
          .firstOrNull;
      expect(machenIch, isNotNull,
          reason: 'machen/ich/perfekt must be in items');
      expect(machenIch!.correctAnswer, 'habe gemacht');
    });

    test('sein verb perfekt form is "bin/bist/... <partizip2>"', () async {
      await scheduler.setSelectedCardTypes({CardType.verbPerfekt});
      await scheduler.setSessionSize(50000);
      final items = await scheduler.getDueItems();
      // gehen (sein-verb, ich): "bin gegangen"
      final gehenItem = items
          .whereType<VerbQuizItem>()
          .where((i) =>
              i.infinitive == 'gehen' &&
              i.person == GrammaticalPerson.ich &&
              i.tense == Tense.perfekt)
          .firstOrNull;
      expect(gehenItem, isNotNull,
          reason: 'gehen/ich/perfekt must be in items with large session size');
      expect(gehenItem!.correctAnswer, 'bin gegangen');
    });
  });

  // ── Adjective reverse ─────────────────────────────────────────────────────────

  group('adjReverse', () {
    test('filter returns only AdjReverseQuizItems', () async {
      await scheduler.setSelectedCardTypes({CardType.adjReverse});
      final items = await scheduler.getDueItems();
      expect(items, isNotEmpty);
      expect(items.every((i) => i is AdjReverseQuizItem), isTrue);
    });

    test('cardId uses reverseCardId getter (adj_reverse: prefix)', () async {
      await scheduler.setSelectedCardTypes({CardType.adjReverse});
      final items = await scheduler.getDueItems();
      for (final item in items.cast<AdjReverseQuizItem>()) {
        expect(item.cardId, startsWith('adj_reverse:'));
        expect(item.cardId, 'adj_reverse:${item.entry.word}');
      }
    });

    test('getStats counts adjReverse when enabled', () async {
      await scheduler.setSelectedCardTypes({CardType.adjReverse});
      final stats = await scheduler.getStats();
      expect(stats[CardType.adjReverse]!.total, greaterThan(0));
      expect(stats[CardType.adjReverse]!.due,
          equals(stats[CardType.adjReverse]!.total));
    });

    test('adjReverse cardId round-trips through saveResult', () async {
      await scheduler.setSelectedCardTypes({CardType.adjReverse});
      await scheduler.setSessionSize(50000);
      final items = await scheduler.getDueItems();
      final item = items.whereType<AdjReverseQuizItem>().first;
      final learned = Sm2Service.applyGrade(
          Sm2Service.applyGrade(Sm2State.initial, 5), 5);
      await scheduler.saveResult(item.cardId, item.cardType, learned);
      final after = await scheduler.getDueItems();
      expect(after.any((i) => i.cardId == item.cardId), isFalse);
    });
  });

  // ── Separable verb prefix ─────────────────────────────────────────────────────

  group('verbSeparable', () {
    test('filter returns only VerbSeparableQuizItems', () async {
      await scheduler.setSelectedCardTypes({CardType.verbSeparable});
      final items = await scheduler.getDueItems();
      expect(items, isNotEmpty);
      expect(items.every((i) => i is VerbSeparableQuizItem), isTrue);
    });

    test('all VerbSeparableQuizItems have non-empty prefix', () async {
      await scheduler.setSelectedCardTypes({CardType.verbSeparable});
      final items = await scheduler.getDueItems();
      for (final item in items.cast<VerbSeparableQuizItem>()) {
        expect(item.prefix, isNotEmpty);
      }
    });

    test('separable items correspond to verbs flagged isSeparable in data',
        () async {
      await scheduler.setSelectedCardTypes({CardType.verbSeparable});
      final items = await scheduler.getDueItems();
      final separableInfinitives =
          kVerbs.where((v) => v.isSeparable).map((v) => v.infinitive).toSet();
      for (final item in items.cast<VerbSeparableQuizItem>()) {
        expect(separableInfinitives, contains(item.infinitive));
      }
    });

    test('known separable verb einkaufen has prefix ein', () async {
      await scheduler.setSelectedCardTypes({CardType.verbSeparable});
      await scheduler.setSelectedLevels({CefrLevel.a1});
      await scheduler.setSessionSize(50000);
      final items = await scheduler.getDueItems();
      final einkaufen = items
          .whereType<VerbSeparableQuizItem>()
          .where((i) => i.infinitive == 'einkaufen')
          .firstOrNull;
      expect(einkaufen, isNotNull);
      expect(einkaufen!.prefix, 'ein');
    });

    test('getStats counts verbSeparable when enabled', () async {
      await scheduler.setSelectedCardTypes({CardType.verbSeparable});
      final stats = await scheduler.getStats();
      expect(stats[CardType.verbSeparable]!.total, greaterThan(0));
    });
  });

  // ── Preposition translation ───────────────────────────────────────────────────

  group('prepTranslation', () {
    test('filter returns only PrepTranslationQuizItems', () async {
      await scheduler.setSelectedCardTypes({CardType.prepTranslation});
      final items = await scheduler.getDueItems();
      expect(items, isNotEmpty);
      expect(items.every((i) => i is PrepTranslationQuizItem), isTrue);
    });

    test('all PrepTranslationQuizItems have non-empty english', () async {
      await scheduler.setSelectedCardTypes({CardType.prepTranslation});
      final items = await scheduler.getDueItems();
      for (final item in items.cast<PrepTranslationQuizItem>()) {
        expect(item.entry.english, isNotEmpty);
      }
    });

    test('getStats counts prepTranslation when enabled', () async {
      await scheduler.setSelectedCardTypes({CardType.prepTranslation});
      final stats = await scheduler.getStats();
      expect(stats[CardType.prepTranslation]!.total,
          equals(kPrepositions.length));
    });

    test('prepTranslation cardId uses translationCardId getter', () async {
      await scheduler.setSelectedCardTypes({CardType.prepTranslation});
      final items = await scheduler.getDueItems();
      for (final item in items.cast<PrepTranslationQuizItem>()) {
        expect(item.cardId, 'prep_translation:${item.entry.word}');
      }
    });
  });

  // ── Preposition case ──────────────────────────────────────────────────────────

  group('prepCase', () {
    test('filter returns only PrepCaseQuizItems', () async {
      await scheduler.setSelectedCardTypes({CardType.prepCase});
      final items = await scheduler.getDueItems();
      expect(items, isNotEmpty);
      expect(items.every((i) => i is PrepCaseQuizItem), isTrue);
    });

    test('all PrepCaseQuizItems have at least one case', () async {
      await scheduler.setSelectedCardTypes({CardType.prepCase});
      final items = await scheduler.getDueItems();
      for (final item in items.cast<PrepCaseQuizItem>()) {
        expect(item.entry.cases, isNotEmpty);
      }
    });

    test('two-way prepositions list both Dativ and Akkusativ', () {
      final twoWay =
          kPrepositions.where((p) => p.cases.length > 1).toList();
      expect(twoWay, isNotEmpty);
      for (final p in twoWay) {
        expect(p.cases, containsAll(['Dativ', 'Akkusativ']));
      }
    });

    test('casesDisplay joins cases with " / "', () {
      final twoWay = kPrepositions.firstWhere((p) => p.cases.length > 1);
      expect(twoWay.casesDisplay, contains(' / '));
    });

    test('Akkusativ-only preps (durch, für) have single case', () {
      final durch =
          kPrepositions.firstWhere((p) => p.word == 'durch');
      expect(durch.cases, equals(['Akkusativ']));
      final fuer =
          kPrepositions.firstWhere((p) => p.word == 'für');
      expect(fuer.cases, equals(['Akkusativ']));
    });

    test('Dativ-only prep (mit) has single case Dativ', () {
      final mit = kPrepositions.firstWhere((p) => p.word == 'mit');
      expect(mit.cases, equals(['Dativ']));
    });

    test('getStats counts prepCase when enabled', () async {
      await scheduler.setSelectedCardTypes({CardType.prepCase});
      final stats = await scheduler.getStats();
      expect(
          stats[CardType.prepCase]!.total, equals(kPrepositions.length));
    });

    test('prepCase cardId round-trips through saveResult', () async {
      await scheduler.setSelectedCardTypes({CardType.prepCase});
      await scheduler.setSessionSize(50000);
      final items = await scheduler.getDueItems();
      final item = items.whereType<PrepCaseQuizItem>().first;
      final learned = Sm2Service.applyGrade(
          Sm2Service.applyGrade(Sm2State.initial, 5), 5);
      await scheduler.saveResult(item.cardId, item.cardType, learned);
      final after = await scheduler.getDueItems();
      expect(after.any((i) => i.cardId == item.cardId), isFalse);
    });
  });

  // ── VerbEntry.isSeparable / prefix data integrity ─────────────────────────────

  group('VerbEntry separable data', () {
    test('isSeparable is true iff prefix is non-null', () {
      for (final v in kVerbs) {
        if (v.prefix != null) {
          expect(v.isSeparable, isTrue, reason: '${v.infinitive} has prefix');
        } else {
          expect(v.isSeparable, isFalse,
              reason: '${v.infinitive} has no prefix');
        }
      }
    });

    test('separableCardId contains infinitive', () {
      for (final v in kVerbs.where((v) => v.isSeparable)) {
        expect(v.separableCardId, contains(v.infinitive));
      }
    });

    test('known separable verbs are flagged', () {
      const expected = {
        'einladen', 'anrufen', 'aufstehen', 'abholen', 'ankommen',
        'abfahren', 'einkaufen', 'anfangen', 'aufräumen', 'ausgehen',
        'aufhören', 'mitnehmen', 'vorstellen', 'zurückkommen',
      };
      final actual =
          kVerbs.where((v) => v.isSeparable).map((v) => v.infinitive).toSet();
      expect(actual, containsAll(expected));
    });
  });
}
