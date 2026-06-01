import 'package:flutter_test/flutter_test.dart';
import 'package:language_trainer/models/quiz_item.dart';
import 'package:language_trainer/services/sm2.dart';

void main() {
  group('Sm2Service', () {
    test('new card is always due', () {
      expect(Sm2Service.isDue(Sm2State.initial), isTrue);
    });

    test('far-future card is not due', () {
      final state = Sm2State.initial.copyWith(
        nextReview: DateTime.now().add(const Duration(days: 30)),
      );
      expect(Sm2Service.isDue(state), isFalse);
    });

    test('grade 5 on new card: reps=1, interval=1', () {
      final s = Sm2Service.applyGrade(Sm2State.initial, 5);
      expect(s.repetitions, 1);
      expect(s.intervalDays, 1);
      expect(s.easeFactor, closeTo(2.6, 0.001));
    });

    test('grade 5 twice: reps=2, interval=6', () {
      final s1 = Sm2Service.applyGrade(Sm2State.initial, 5);
      final s2 = Sm2Service.applyGrade(s1, 5);
      expect(s2.repetitions, 2);
      expect(s2.intervalDays, 6);
    });

    test('grade 5 three times: interval grows by EF', () {
      var s = Sm2Service.applyGrade(Sm2State.initial, 5);
      s = Sm2Service.applyGrade(s, 5);
      s = Sm2Service.applyGrade(s, 5);
      // interval = round(6 * ~2.7) = 16
      expect(s.intervalDays, greaterThan(10));
      expect(s.repetitions, 3);
    });

    test('grade 0 resets repetitions and interval to 1', () {
      var s = Sm2Service.applyGrade(Sm2State.initial, 5);
      s = Sm2Service.applyGrade(s, 5);
      final ef = s.easeFactor;
      s = Sm2Service.applyGrade(s, 0);
      expect(s.repetitions, 0);
      expect(s.intervalDays, 1);
      expect(s.easeFactor, closeTo(ef, 0.001)); // EF unchanged on failure
    });

    test('EF never drops below 1.3', () {
      var s = Sm2State.initial.copyWith(easeFactor: 1.31);
      s = Sm2Service.applyGrade(s, 3); // grade 3 decreases EF
      expect(s.easeFactor, greaterThanOrEqualTo(1.3));
    });

    test('grade 3 produces correct EF delta', () {
      // EF delta for grade 3 = 0.1 - (5-3)*(0.08 + (5-3)*0.02) = 0.1 - 2*0.12 = -0.14
      final s = Sm2Service.applyGrade(Sm2State.initial, 3);
      expect(s.easeFactor, closeTo(2.36, 0.001));
    });

    test('nextReview is in the future after grade 5', () {
      final before = DateTime.now();
      final s = Sm2Service.applyGrade(Sm2State.initial, 5);
      expect(s.nextReview.isAfter(before), isTrue);
    });
  });
}
