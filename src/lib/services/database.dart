import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

// ── Tables ───────────────────────────────────────────────────────────────────

class ReviewEntries extends Table {
  TextColumn get id => text()();
  IntColumn get cardType => integer()();
  RealColumn get easeFactor => real()();
  IntColumn get intervalDays => integer()();
  IntColumn get repetitions => integer()();
  IntColumn get nextReviewMs => integer()(); // milliseconds since epoch

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AppPreferences extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

// Singleton row (id = 1). All counters default to 0.
class UserProgressEntries extends Table {
  IntColumn get id => integer()();
  IntColumn get totalXp => integer().withDefault(const Constant(0))();
  IntColumn get totalCorrect => integer().withDefault(const Constant(0))();
  IntColumn get totalFirstCorrect => integer().withDefault(const Constant(0))();
  IntColumn get sessionsCompleted => integer().withDefault(const Constant(0))();
  // Comma-separated unlocked achievement IDs, e.g. "first_correct,level_5".
  TextColumn get unlockedAchievements =>
      text().withDefault(const Constant(''))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

// ── Database ─────────────────────────────────────────────────────────────────

@DriftDatabase(tables: [ReviewEntries, AppPreferences, UserProgressEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'language_trainer.db'));
      return NativeDatabase.createInBackground(file);
    });
  }

  // ── Review entries ─────────────────────────────────────────────────────────

  Future<ReviewEntry?> getReviewEntry(String id) =>
      (select(reviewEntries)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<ReviewEntry>> getAllReviewEntries() =>
      select(reviewEntries).get();

  Future<void> upsertReviewEntry(ReviewEntriesCompanion entry) =>
      into(reviewEntries).insertOnConflictUpdate(entry);

  // ── Preferences ────────────────────────────────────────────────────────────

  Future<String?> getPreference(String key) async {
    final row = await (select(appPreferences)
          ..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> setPreference(String key, String value) =>
      into(appPreferences).insertOnConflictUpdate(
        AppPreferencesCompanion(key: Value(key), value: Value(value)),
      );

  // ── User progress ──────────────────────────────────────────────────────────

  /// Returns the singleton progress row, creating it on first call.
  Future<UserProgressEntry> getProgress() async {
    final row = await (select(userProgressEntries)
          ..where((t) => t.id.equals(1)))
        .getSingleOrNull();
    if (row != null) return row;
    await into(userProgressEntries).insert(
      const UserProgressEntriesCompanion(
        id: Value(1),
        totalXp: Value(0),
        totalCorrect: Value(0),
        totalFirstCorrect: Value(0),
        sessionsCompleted: Value(0),
        unlockedAchievements: Value(''),
      ),
    );
    return (await (select(userProgressEntries)..where((t) => t.id.equals(1)))
        .getSingleOrNull())!;
  }

  /// Partial update — only companion fields wrapped in Value() are written.
  Future<void> updateProgress(UserProgressEntriesCompanion companion) =>
      (update(userProgressEntries)..where((t) => t.id.equals(1)))
          .write(companion);
}
