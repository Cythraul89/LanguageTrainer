import 'package:language_trainer/models/noun.dart';
import 'package:language_trainer/models/verb.dart';

enum CardType {
  noun,
  nounPlural,
  nounTranslation,
  nounReverse,
  verbPraesens,
  verbPraeteritum,
  verbPerfekt,
  verbPartizipII,
  verbAuxiliary,
  verbTranslation,
  verbReverse,
}

class Sm2State {
  final double easeFactor;
  final int intervalDays;
  final int repetitions;
  final DateTime nextReview;

  const Sm2State({
    required this.easeFactor,
    required this.intervalDays,
    required this.repetitions,
    required this.nextReview,
  });

  static Sm2State get initial => Sm2State(
        easeFactor: 2.5,
        intervalDays: 0,
        repetitions: 0,
        // epoch 0 → always due on first encounter
        nextReview: DateTime.fromMillisecondsSinceEpoch(0),
      );

  Sm2State copyWith({
    double? easeFactor,
    int? intervalDays,
    int? repetitions,
    DateTime? nextReview,
  }) =>
      Sm2State(
        easeFactor: easeFactor ?? this.easeFactor,
        intervalDays: intervalDays ?? this.intervalDays,
        repetitions: repetitions ?? this.repetitions,
        nextReview: nextReview ?? this.nextReview,
      );
}

sealed class QuizItem {
  const QuizItem({required this.cardId, required this.cardType, required this.sm2});
  final String cardId;
  final CardType cardType;
  final Sm2State sm2;
}

class NounQuizItem extends QuizItem {
  final NounEntry entry;

  const NounQuizItem({
    required super.cardId,
    required super.sm2,
    required this.entry,
  }) : super(cardType: CardType.noun);
}

class NounPluralQuizItem extends QuizItem {
  final NounEntry entry;

  const NounPluralQuizItem({
    required super.cardId,
    required super.sm2,
    required this.entry,
  }) : super(cardType: CardType.nounPlural);
}

class NounTranslationQuizItem extends QuizItem {
  final NounEntry entry;

  const NounTranslationQuizItem({
    required super.cardId,
    required super.sm2,
    required this.entry,
  }) : super(cardType: CardType.nounTranslation);
}

class VerbTranslationQuizItem extends QuizItem {
  final String infinitive;
  final String english;

  const VerbTranslationQuizItem({
    required super.cardId,
    required super.sm2,
    required this.infinitive,
    required this.english,
  }) : super(cardType: CardType.verbTranslation);
}

class VerbPartizipIIQuizItem extends QuizItem {
  final String infinitive;
  final String english;
  final String partizip2;

  const VerbPartizipIIQuizItem({
    required super.cardId,
    required super.sm2,
    required this.infinitive,
    required this.english,
    required this.partizip2,
  }) : super(cardType: CardType.verbPartizipII);
}

class NounReverseQuizItem extends QuizItem {
  final NounEntry entry;

  const NounReverseQuizItem({
    required super.cardId,
    required super.sm2,
    required this.entry,
  }) : super(cardType: CardType.nounReverse);
}

class VerbReverseQuizItem extends QuizItem {
  final String infinitive;
  final String english;

  const VerbReverseQuizItem({
    required super.cardId,
    required super.sm2,
    required this.infinitive,
    required this.english,
  }) : super(cardType: CardType.verbReverse);
}

class VerbAuxiliaryQuizItem extends QuizItem {
  final String infinitive;
  final String english;
  final Auxiliary auxiliary;

  const VerbAuxiliaryQuizItem({
    required super.cardId,
    required super.sm2,
    required this.infinitive,
    required this.english,
    required this.auxiliary,
  }) : super(cardType: CardType.verbAuxiliary);
}

class VerbQuizItem extends QuizItem {
  final String infinitive;
  final String english;
  final GrammaticalPerson person;
  final Tense tense;
  final String correctAnswer;

  const VerbQuizItem({
    required super.cardId,
    required super.cardType,
    required super.sm2,
    required this.infinitive,
    required this.english,
    required this.person,
    required this.tense,
    required this.correctAnswer,
  });
}
