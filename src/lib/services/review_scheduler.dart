import 'package:drift/drift.dart';
import 'package:language_trainer/data/nouns.dart';
import 'package:language_trainer/data/verbs.dart';
import 'package:language_trainer/models/noun.dart';
import 'package:language_trainer/models/quiz_item.dart';
import 'package:language_trainer/models/verb.dart';
import 'package:language_trainer/services/database.dart';
import 'package:language_trainer/services/sm2.dart';

const _kDefaultLevels = 'a1,a2,b1,b2,c1,c2';
const _kLevelsKey = 'selected_levels';
const _kDefaultCardTypes =
    'noun,nounPlural,nounTranslation,verbPraesens,verbPraeteritum,verbPerfekt,verbPartizipII,verbAuxiliary,verbTranslation';
const _kCardTypesKey = 'selected_card_types';

class ReviewScheduler {
  ReviewScheduler(this._db);

  final AppDatabase _db;

  Future<Set<CefrLevel>> getSelectedLevels() async {
    final raw = await _db.getPreference(_kLevelsKey) ?? _kDefaultLevels;
    return raw.split(',').map(_parseLevel).toSet();
  }

  Future<void> setSelectedLevels(Set<CefrLevel> levels) =>
      _db.setPreference(_kLevelsKey, levels.map((l) => l.name).join(','));

  Future<Set<CardType>> getSelectedCardTypes() async {
    final raw = await _db.getPreference(_kCardTypesKey) ?? _kDefaultCardTypes;
    return raw.split(',').map(_parseCardType).toSet();
  }

  Future<void> setSelectedCardTypes(Set<CardType> types) =>
      _db.setPreference(_kCardTypesKey, types.map((t) => t.name).join(','));

  Future<List<QuizItem>> getDueItems() async {
    final levels = await getSelectedLevels();
    final cardTypes = await getSelectedCardTypes();
    final saved = await _db.getAllReviewEntries();
    final savedMap = {for (final e in saved) e.id: e};
    final due = <QuizItem>[];

    for (final noun in kNouns.where((n) => levels.contains(n.level))) {
      if (cardTypes.contains(CardType.noun)) {
        final sm2 = _sm2For(savedMap[noun.cardId]);
        if (Sm2Service.isDue(sm2)) {
          due.add(NounQuizItem(cardId: noun.cardId, sm2: sm2, entry: noun));
        }
      }
      if (cardTypes.contains(CardType.nounPlural) && noun.hasPlural) {
        final sm2 = _sm2For(savedMap[noun.pluralCardId]);
        if (Sm2Service.isDue(sm2)) {
          due.add(NounPluralQuizItem(
              cardId: noun.pluralCardId, sm2: sm2, entry: noun));
        }
      }
      if (cardTypes.contains(CardType.nounTranslation)) {
        final sm2 = _sm2For(savedMap[noun.translationCardId]);
        if (Sm2Service.isDue(sm2)) {
          due.add(NounTranslationQuizItem(
              cardId: noun.translationCardId, sm2: sm2, entry: noun));
        }
      }
    }

    for (final verb in kVerbs.where((v) => levels.contains(v.level))) {
      if (cardTypes.contains(CardType.verbTranslation)) {
        final sm2 = _sm2For(savedMap[verb.translationCardId]);
        if (Sm2Service.isDue(sm2)) {
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
        if (Sm2Service.isDue(sm2)) {
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
        if (Sm2Service.isDue(sm2)) {
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
          if (Sm2Service.isDue(sm2)) {
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

    due.shuffle();
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
    }

    for (final verb in kVerbs.where((v) => levels.contains(v.level))) {
      void _countVerb(CardType ct, String id) {
        if (!cardTypes.contains(ct)) return;
        totals[ct] = totals[ct]! + 1;
        final sm2 = _sm2For(savedMap[id]);
        if (Sm2Service.isDue(sm2)) dues[ct] = dues[ct]! + 1;
      }

      _countVerb(CardType.verbTranslation, verb.translationCardId);
      _countVerb(CardType.verbPartizipII, verb.partizip2CardId);
      _countVerb(CardType.verbAuxiliary, verb.auxiliaryCardId);
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

  static CardType _parseCardType(String s) => switch (s.trim()) {
        'noun' => CardType.noun,
        'nounPlural' => CardType.nounPlural,
        'nounTranslation' => CardType.nounTranslation,
        'verbPraesens' => CardType.verbPraesens,
        'verbPraeteritum' => CardType.verbPraeteritum,
        'verbPerfekt' => CardType.verbPerfekt,
        'verbPartizipII' => CardType.verbPartizipII,
        'verbAuxiliary' => CardType.verbAuxiliary,
        'verbTranslation' => CardType.verbTranslation,
        _ => CardType.noun,
      };

  static CefrLevel _parseLevel(String s) => switch (s.trim()) {
        'a1' => CefrLevel.a1,
        'a2' => CefrLevel.a2,
        'b1' => CefrLevel.b1,
        'b2' => CefrLevel.b2,
        'c1' => CefrLevel.c1,
        'c2' => CefrLevel.c2,
        _ => CefrLevel.a1,
      };
}
