import 'package:flutter/material.dart';
import 'package:language_trainer/screens/home_screen.dart';
import 'package:language_trainer/services/database.dart';
import 'package:language_trainer/services/review_scheduler.dart';

void main() {
  runApp(const LanguageTrainerApp());
}

class LanguageTrainerApp extends StatelessWidget {
  const LanguageTrainerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final db = AppDatabase();
    final scheduler = ReviewScheduler(db);
    return MaterialApp(
      title: 'Language Trainer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: HomeScreen(scheduler: scheduler),
    );
  }
}
