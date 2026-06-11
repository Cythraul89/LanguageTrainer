import 'package:drift/drift.dart';
import 'package:language_trainer/data/adjectives.dart';
import 'package:language_trainer/data/nouns.dart';
import 'package:language_trainer/data/prepositions.dart';
import 'package:language_trainer/data/verbs.dart';
import 'package:language_trainer/models/noun.dart';
import 'package:language_trainer/models/quiz_item.dart';
import 'package:language_trainer/models/verb.dart';
import 'package:language_trainer/services/database.dart';
import 'package:language_trainer/services/sm2.dart';

const _kDefaultLevels = 'a1,a2,b1,b2,c1,c2';
const _kLevelsKey = 'selected_levels';
const _kDefaultCardTypes =
    'noun,nounPlural,nounTranslation,nounReverse,verbPraesens,verbPraeteritum,verbPerfekt,verbPartizipII,verbAuxiliary,verbTranslation,verbReverse,adjTranslation';
const _kCardTypesKey = 'selected_card_types';
const _kSessionSizeKey = 'session_size';
const _kDefaultSessionSize = 10;

class ReviewScheduler {
  ReviewScheduler(this._db);

  final AppDatabase _db;

  Future<Set<CefrLevel>> getSelectedLevels() async {
    final raw = await _db.getPreference(_kLevelsKey) ?? _kDefaultLevels;
    final parsed = raw.split(',').map(_parseLevel).whereType<CefrLevel>().toSet();
    if (parsed.isEmpty) {
      return _kDefaultLevels.split(',').map(_parseLevel).whereType<CefrLevel>().toSet();
    }
    return parsed;
  }

  Future<void> setSelectedLevels(Set<CefrLevel> levels) =>
      _db.setPreference(_kLevelsKey, levels.map((l) => l.name).join(','));

  Future<Set<CardType>> getSelectedCardTypes() async {
    final raw = await _db.getPreference(_kCardTypesKey) ?? _kDefaultCardTypes;
    final parsed = raw.split(',').map(_parseCardType).whereType<CardType>().toSet();
    if (parsed.isEmpty) {
      return _kDefaultCardTypes.split(',').map(_parseCardType).whereType<CardType>().toSet();
    }
    return parsed;
  }

  Future<void> setSelectedCardTypes(Set<CardType> types) =>
      _db.setPreference(_kCardTypesKey, types.map((t) => t.name).join(','));

  Future<int> getSessionSize() async {
    final raw = await _db.getPreference(_kSessionSizeKey);
    if (raw == null) return _kDefaultSessionSize;
    return int.tryParse(raw) ?? _kDefaultSessionSize;
  }

  Future<void> setSessionSize(int size) =>
      _db.setPreference(_kSessionSizeKey, size.toString());

  /// Cards the user has seen but is struggling with (easeFactor < 2.0).
  /// Ignores the SM-2 due date — useful for targeted practice.
  Future<List<QuizItem>> getDifficultItems() => _queryItems(
        eligible: (sm2) => sm2.repetitions > 0 && sm2.easeFactor < 2.0,
      );

  Future<int> getDifficultCount() async {
    final items = await _queryItems(
      eligible: (sm2) => sm2.repetitions > 0 && sm2.easeFactor < 2.0,
      cap: null,
    );
    return items.length;
  }

  Future<List<QuizItem>> getDueItems() =>
      _queryItems(eligible: (sm2) => Sm2Service.isDue(sm2));

  Future<List<QuizItem>> _queryItems({
    required bool Function(Sm2State) eligible,
    Object? cap = const _UseSessionSize(),
  }) async {
    final levels = await getSelectedLevels();
    final cardTypes = await getSelectedCardTypes();
    final saved = await _db.getAllReviewEntries();
    final savedMap = {for (final e in saved) e.id: e};
    final due = <QuizItem>[];

    for (final noun in kNouns.where((n) => levels.contains(n.level))) {
      if (cardTypes.contains(CardType.noun)) {
        final sm2 = _sm2For(savedMap[noun.cardId]);
        if (eligible(sm2)) {
          due.add(NounQuizItem(cardId: noun.cardId, sm2: sm2, entry: noun));
        }
      }
      if (cardTypes.contains(CardType.nounPlural) && noun.hasPlural) {
        final sm2 = _sm2For(savedMap[noun.pluralCardId]);
        if (eligible(sm2)) {
          due.add(NounPluralQuizItem(
              cardId: noun.pluralCardId, sm2: sm2, entry: noun));
        }
      }
      if (cardTypes.contains(CardType.nounTranslation)) {
        final sm2 = _sm2For(savedMap[noun.translationCardId]);
        if (eligible(sm2)) {
          due.add(NounTranslationQuizItem(
              cardId: noun.translationCardId, sm2: sm2, entry: noun));
        }
      }
      if (cardTypes.contains(CardType.nounReverse)) {
        final sm2 = _sm2For(savedMap[noun.reverseCardId]);
        if (eligible(sm2)) {
          due.add(NounReverseQuizItem(
              cardId: noun.reverseCardId, sm2: sm2, entry: noun));
        }
      }
    }

    for (final verb in kVerbs.where((v) => levels.contains(v.level))) {
      if (cardTypes.contains(CardType.verbReverse)) {
        final sm2 = _sm2For(savedMap[verb.reverseCardId]);
        if (eligible(sm2)) {
          due.add(VerbReverseQuizItem(
            cardId: verb.reverseCardId,
            sm2: sm2,
            infinitive: verb.infinitive,
            english: verb.english,
          ));
        }
      }
      if (cardTypes.contains(CardType.verbTranslation)) {
        final sm2 = _sm2For(savedMap[verb.translationCardId]);
        if (eligible(sm2)) {
          due.add(VerbTranslationQuizItem(
            cardId: verb.translationCardId,
            sm2: sm2,
            infinitive: verb.infinitive,
            english: verb.english,
          ));
        }
      }
      if (cardTypes.contains(CardType.verbPartizipII)) {
        final sm2 = _sm2For(savedMap[verb.partizip2CardId]);
        if (eligible(sm2)) {
          due.add(VerbPartizipIIQuizItem(
            cardId: verb.partizip2CardId,
            sm2: sm2,
            infinitive: verb.infinitive,
            english: verb.english,
            partizip2: verb.partizip2,
          ));
        }
      }
      if (cardTypes.contains(CardType.verbAuxiliary)) {
        final sm2 = _sm2For(savedMap[verb.auxiliaryCardId]);
        if (eligible(sm2)) {
          due.add(VerbAuxiliaryQuizItem(
            cardId: verb.auxiliaryCardId,
            sm2: sm2,
            infinitive: verb.infinitive,
            english: verb.english,
            auxiliary: verb.auxiliary,
          ));
        }
      }
    }

    for (final verb in kVerbs.where((v) => levels.contains(v.level))) {
      for (final person in GrammaticalPerson.values) {
        for (final tense in Tense.values) {
          final ct = _cardTypeFor(tense);
          if (!cardTypes.contains(ct)) continue;
          final id = verb.cardId(person, tense);
          final sm2 = _sm2For(savedMap[id]);
          if (eligible(sm2)) {
            due.add(VerbQuizItem(
              cardId: id,
              cardType: ct,
              sm2: sm2,
              infinitive: verb.infinitive,
              english: verb.english,
              person: person,
              tense: tense,
              correctAnswer: _answer(verb, person, tense),
            ));
          }
        }
      }
    }

    for (final adj in kAdjectives.where((a) => levels.contains(a.level))) {
      if (cardTypes.contains(CardType.adjTranslation)) {
        final sm2 = _sm2For(savedMap[adj.translationCardId]);
        if (eligible(sm2)) {
          due.add(AdjTranslationQuizItem(
              cardId: adj.translationCardId, sm2: sm2, entry: adj));
        }
      }
      if (cardTypes.contains(CardType.adjComparative)) {
        final sm2 = _sm2For(savedMap[adj.comparativeCardId]);
        if (eligible(sm2)) {
          due.add(AdjComparativeQuizItem(
              cardId: adj.comparativeCardId, sm2: sm2, entry: adj));
        }
      }
      if (cardTypes.contains(CardType.adjSuperlative)) {
        final sm2 = _sm2For(savedMap[adj.superlativeCardId]);
        if (eligible(sm2)) {
          due.add(AdjSuperlativeQuizItem(
              cardId: adj.superlativeCardId, sm2: sm2, entry: adj));
        }
      }
      if (cardTypes.contains(CardType.adjReverse)) {
        final sm2 = _sm2For(savedMap[adj.reverseCardId]);
        if (eligible(sm2)) {
          due.add(AdjReverseQuizItem(cardId: adj.reverseCardId, sm2: sm2, entry: adj));
        }
      }
    }

    for (final verb in kVerbs.where((v) => levels.contains(v.level) && v.isSeparable)) {
      if (cardTypes.contains(CardType.verbSeparable)) {
        final sm2 = _sm2For(savedMap[verb.separableCardId]);
        if (eligible(sm2)) {
          due.add(VerbSeparableQuizItem(
            cardId: verb.separableCardId,
            sm2: sm2,
            infinitive: verb.infinitive,
            english: verb.english,
            prefix: verb.prefix!,
          ));
        }
      }
    }

    for (final prep in kPrepositions.where((p) => levels.contains(p.level))) {
      if (cardTypes.contains(CardType.prepTranslation)) {
        final sm2 = _sm2For(savedMap[prep.translationCardId]);
        if (eligible(sm2)) {
          due.add(PrepTranslationQuizItem(
              cardId: prep.translationCardId, sm2: sm2, entry: prep));
        }
      }
      if (cardTypes.contains(CardType.prepCase)) {
        final sm2 = _sm2For(savedMap[prep.caseCardId]);
        if (eligible(sm2)) {
          due.add(PrepCaseQuizItem(
              cardId: prep.caseCardId, sm2: sm2, entry: prep));
        }
      }
    }

    due.shuffle();
    final int? limit = cap is _UseSessionSize ? await getSessionSize() : cap as int?;
    if (limit != null && due.length > limit) return due.sublist(0, limit);
    return due;
  }

  Future<Map<CardType, ({int total, int due})>> getStats() async {
    final levels = await getSelectedLevels();
    final cardTypes = await getSelectedCardTypes();
    final saved = await _db.getAllReviewEntries();
    final savedMap = {for (final e in saved) e.id: e};

    final totals = <CardType, int>{for (final t in CardType.values) t: 0};
    final dues = <CardType, int>{for (final t in CardType.values) t: 0};

    for (final noun in kNouns.where((n) => levels.contains(n.level))) {
      if (cardTypes.contains(CardType.noun)) {
        totals[CardType.noun] = totals[CardType.noun]! + 1;
        final sm2 = _sm2For(savedMap[noun.cardId]);
        if (Sm2Service.isDue(sm2)) dues[CardType.noun] = dues[CardType.noun]! + 1;
      }
      if (cardTypes.contains(CardType.nounPlural) && noun.hasPlural) {
        totals[CardType.nounPlural] = totals[CardType.nounPlural]! + 1;
        final sm2 = _sm2For(savedMap[noun.pluralCardId]);
        if (Sm2Service.isDue(sm2)) {
          dues[CardType.nounPlural] = dues[CardType.nounPlural]! + 1;
        }
      }
      if (cardTypes.contains(CardType.nounTranslation)) {
        totals[CardType.nounTranslation] = totals[CardType.nounTranslation]! + 1;
        final sm2 = _sm2For(savedMap[noun.translationCardId]);
        if (Sm2Service.isDue(sm2)) {
          dues[CardType.nounTranslation] = dues[CardType.nounTranslation]! + 1;
        }
      }
      if (cardTypes.contains(CardType.nounReverse)) {
        totals[CardType.nounReverse] = totals[CardType.nounReverse]! + 1;
        final sm2 = _sm2For(savedMap[noun.reverseCardId]);
        if (Sm2Service.isDue(sm2)) {
          dues[CardType.nounReverse] = dues[CardType.nounReverse]! + 1;
        }
      }
    }

    for (final verb in kVerbs.where((v) => levels.contains(v.level))) {
      void countVerb(CardType ct, String id) {
        if (!cardTypes.contains(ct)) return;
        totals[ct] = totals[ct]! + 1;
        final sm2 = _sm2For(savedMap[id]);
        if (Sm2Service.isDue(sm2)) dues[ct] = dues[ct]! + 1;
      }

      countVerb(CardType.verbTranslation, verb.translationCardId);
      countVerb(CardType.verbPartizipII, verb.partizip2CardId);
      countVerb(CardType.verbAuxiliary, verb.auxiliaryCardId);
      countVerb(CardType.verbReverse, verb.reverseCardId);
    }

    for (final verb in kVerbs.where((v) => levels.contains(v.level))) {
      for (final person in GrammaticalPerson.values) {
        for (final tense in Tense.values) {
          final ct = _cardTypeFor(tense);
          if (!cardTypes.contains(ct)) continue;
          totals[ct] = totals[ct]! + 1;
          final sm2 = _sm2For(savedMap[verb.cardId(person, tense)]);
          if (Sm2Service.isDue(sm2)) dues[ct] = dues[ct]! + 1;
        }
      }
    }

    for (final adj in kAdjectives.where((a) => levels.contains(a.level))) {
      void countAdj(CardType ct, String id) {
        if (!cardTypes.contains(ct)) return;
        totals[ct] = totals[ct]! + 1;
        final sm2 = _sm2For(savedMap[id]);
        if (Sm2Service.isDue(sm2)) dues[ct] = dues[ct]! + 1;
      }

      countAdj(CardType.adjTranslation, adj.translationCardId);
      countAdj(CardType.adjComparative, adj.comparativeCardId);
      countAdj(CardType.adjSuperlative, adj.superlativeCardId);
      countAdj(CardType.adjReverse, adj.reverseCardId);
    }

    for (final verb in kVerbs.where((v) => levels.contains(v.level) && v.isSeparable)) {
      if (cardTypes.contains(CardType.verbSeparable)) {
        totals[CardType.verbSeparable] = totals[CardType.verbSeparable]! + 1;
        final sm2 = _sm2For(savedMap[verb.separableCardId]);
        if (Sm2Service.isDue(sm2)) {
          dues[CardType.verbSeparable] = dues[CardType.verbSeparable]! + 1;
        }
      }
    }

    for (final prep in kPrepositions.where((p) => levels.contains(p.level))) {
      void countPrep(CardType ct, String id) {
        if (!cardTypes.contains(ct)) return;
        totals[ct] = totals[ct]! + 1;
        final sm2 = _sm2For(savedMap[id]);
        if (Sm2Service.isDue(sm2)) dues[ct] = dues[ct]! + 1;
      }

      countPrep(CardType.prepTranslation, prep.translationCardId);
      countPrep(CardType.prepCase, prep.caseCardId);
    }

    return {
      for (final t in CardType.values)
        t: (total: totals[t]!, due: dues[t]!),
    };
  }

  Future<void> saveResult(String cardId, CardType cardType, Sm2State sm2) =>
      _db.upsertReviewEntry(ReviewEntriesCompanion(
        id: Value(cardId),
        cardType: Value(cardType.index),
        easeFactor: Value(sm2.easeFactor),
        intervalDays: Value(sm2.intervalDays),
        repetitions: Value(sm2.repetitions),
        nextReviewMs: Value(sm2.nextReview.millisecondsSinceEpoch),
      ));

  // ── Helpers ────────────────────────────────────────────────────────────────

  static Sm2State _sm2For(ReviewEntry? entry) {
    if (entry == null) return Sm2State.initial;
    return Sm2State(
      easeFactor: entry.easeFactor,
      intervalDays: entry.intervalDays,
      repetitions: entry.repetitions,
      nextReview: DateTime.fromMillisecondsSinceEpoch(entry.nextReviewMs),
    );
  }

  static String _answer(VerbEntry verb, GrammaticalPerson person, Tense tense) =>
      switch (tense) {
        Tense.praesens => verb.praesens[person]!,
        Tense.praeteritum => verb.praeteritum[person]!,
        Tense.perfekt => verb.perfektForm(person),
      };

  static CardType _cardTypeFor(Tense tense) => switch (tense) {
        Tense.praesens => CardType.verbPraesens,
        Tense.praeteritum => CardType.verbPraeteritum,
        Tense.perfekt => CardType.verbPerfekt,
      };

  static CardType? _parseCardType(String s) => switch (s.trim()) {
        'noun' => CardType.noun,
        'nounPlural' => CardType.nounPlural,
        'nounTranslation' => CardType.nounTranslation,
        'verbPraesens' => CardType.verbPraesens,
        'verbPraeteritum' => CardType.verbPraeteritum,
        'verbPerfekt' => CardType.verbPerfekt,
        'verbPartizipII' => CardType.verbPartizipII,
        'verbAuxiliary' => CardType.verbAuxiliary,
        'verbTranslation' => CardType.verbTranslation,
        'nounReverse' => CardType.nounReverse,
        'verbReverse' => CardType.verbReverse,
        'adjTranslation' => CardType.adjTranslation,
        'adjComparative' => CardType.adjComparative,
        'adjSuperlative' => CardType.adjSuperlative,
        'adjReverse' => CardType.adjReverse,
        'verbSeparable' => CardType.verbSeparable,
        'prepTranslation' => CardType.prepTranslation,
        'prepCase' => CardType.prepCase,
        _ => null,
      };

  static CefrLevel? _parseLevel(String s) => switch (s.trim()) {
        'a1' => CefrLevel.a1,
        'a2' => CefrLevel.a2,
        'b1' => CefrLevel.b1,
        'b2' => CefrLevel.b2,
        'c1' => CefrLevel.c1,
        'c2' => CefrLevel.c2,
        _ => null,
      };
}

// Sentinel used as the default value for the `cap` parameter of _queryItems.
// Distinct from `null` (which means no cap) and `int` (explicit cap).
class _UseSessionSize {
  const _UseSessionSize();
}
