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

// ── Database ─────────────────────────────────────────────────────────────────

@DriftDatabase(tables: [ReviewEntries, AppPreferences])
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
}
