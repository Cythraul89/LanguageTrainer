import 'package:flutter/material.dart';
import 'package:language_trainer/services/database.dart';
import 'package:language_trainer/services/gamification_service.dart';
import 'package:language_trainer/services/review_scheduler.dart';
import 'package:language_trainer/shell/adaptive_shell.dart';

/// Bundles all singleton services so they are created once and passed down.
class AppServices {
  final AppDatabase db;
  final ReviewScheduler scheduler;
  final GamificationService gamification;

  const AppServices({
    required this.db,
    required this.scheduler,
    required this.gamification,
  });
}

class LanguageTrainerApp extends StatefulWidget {
  const LanguageTrainerApp({super.key});

  @override
  State<LanguageTrainerApp> createState() => _LanguageTrainerAppState();
}

class _LanguageTrainerAppState extends State<LanguageTrainerApp> {
  late final AppServices _services;

  @override
  void initState() {
    super.initState();
    final db = AppDatabase();
    _services = AppServices(
      db: db,
      scheduler: ReviewScheduler(db),
      gamification: GamificationService(db),
    );
  }

  @override
  void dispose() {
    _services.db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Language Trainer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: AdaptiveShell(services: _services),
    );
  }
}
