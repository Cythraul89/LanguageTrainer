import 'package:language_trainer/models/quiz_item.dart';

// SM-2 algorithm — Wozniak (1990).
// Grading is binary: correct = grade 5, wrong = grade 0.
class Sm2Service {
  static Sm2State applyGrade(Sm2State state, int grade) {
    assert(grade >= 0 && grade <= 5);

    if (grade < 3) {
      return state.copyWith(
        repetitions: 0,
        intervalDays: 1,
        nextReview: DateTime.now().add(const Duration(days: 1)),
      );
    }

    final newEF = (state.easeFactor +
            (0.1 - (5 - grade) * (0.08 + (5 - grade) * 0.02)))
        .clamp(1.3, double.infinity);

    final newReps = state.repetitions + 1;
    final int newInterval;
    if (state.repetitions == 0) {
      newInterval = 1;
    } else if (state.repetitions == 1) {
      newInterval = 6;
    } else {
      newInterval = (state.intervalDays * newEF).round();
    }

    return state.copyWith(
      easeFactor: newEF,
      intervalDays: newInterval,
      repetitions: newReps,
      nextReview: DateTime.now().add(Duration(days: newInterval)),
    );
  }

  static bool isDue(Sm2State state) =>
      DateTime.now().isAfter(state.nextReview);
}
