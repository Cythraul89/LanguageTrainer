import 'package:flutter/material.dart';
import 'package:language_trainer/models/noun.dart';
import 'package:language_trainer/models/quiz_item.dart';
import 'package:language_trainer/models/verb.dart';
import 'package:language_trainer/services/review_scheduler.dart';
import 'package:language_trainer/services/sm2.dart';
import 'package:language_trainer/widgets/article_buttons.dart';
import 'package:language_trainer/widgets/conjugation_field.dart';
import 'package:language_trainer/widgets/feedback_overlay.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.items, required this.scheduler});
  final List<QuizItem> items;
  final ReviewScheduler scheduler;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final List<QuizItem> _queue;
  int _index = 0;
  bool _answered = false;
  bool _correct = false;
  // For verb cards, tracks whether the user overrode the result to correct.
  bool _overridden = false;

  @override
  void initState() {
    super.initState();
    _queue = List.of(widget.items);
  }

  QuizItem get _current => _queue[_index];

  bool get _done => _index >= _queue.length;

  Future<void> _onAnswer(bool correct) async {
    setState(() {
      _answered = true;
      _correct = correct;
      _overridden = false;
    });

    final grade = correct ? 5 : 0;
    final newSm2 = Sm2Service.applyGrade(_current.sm2, grade);
    await widget.scheduler.saveResult(
        _current.cardId, _current.cardType, newSm2);

    if (!correct) {
      // Re-queue wrong answers at the end for one extra attempt.
      _queue.add(_current);
    }
  }

  void _onOverride() {
    setState(() {
      _overridden = true;
      _correct = true;
    });
    final newSm2 = Sm2Service.applyGrade(_current.sm2, 5);
    widget.scheduler.saveResult(_current.cardId, _current.cardType, newSm2);
    // Remove the re-queued duplicate added by the wrong-answer path.
    if (_queue.length > _index + 1 && _queue.last.cardId == _current.cardId) {
      _queue.removeLast();
    }
  }

  void _next() {
    setState(() {
      _index++;
      _answered = false;
      _overridden = false;
    });
  }

  Future<bool> _confirmQuit() async {
    if (_done || !_answered) return true;
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Quit review?'),
        content: const Text('Progress so far is saved.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Continue')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Quit')),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (_done) {
      return Scaffold(
        appBar: AppBar(title: const Text('Done')),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outline, size: 72, color: Colors.green),
              SizedBox(height: 16),
              Text('Session complete!', style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        if (await _confirmQuit() && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('${_index + 1} / ${_queue.length}'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: LinearProgressIndicator(
              value: _index / _queue.length,
              minHeight: 4,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildPrompt(),
                const SizedBox(height: 32),
                if (!_answered) _buildAnswerWidget(),
                if (_answered)
                  FeedbackOverlay(
                    correct: _correct,
                    correctAnswer: _correctAnswer(),
                    onOverride: _current is VerbQuizItem && !_correct && !_overridden
                        ? _onOverride
                        : null,
                    onNext: _next,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrompt() {
    return switch (_current) {
      NounQuizItem(entry: final n) => Column(
          children: [
            Text(n.word,
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(n.english,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center),
            Text('(${n.plural})',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center),
          ],
        ),
      VerbQuizItem() => () {
          final v = _current as VerbQuizItem;
          final personLabel = _personLabel(v.person);
          final tenseLabel = _tenseLabel(v.tense);
          return Column(
            children: [
              Text('$personLabel ___ (${v.infinitive})',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: 4),
              Text(tenseLabel,
                  style: Theme.of(context).textTheme.labelLarge,
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(v.english,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center),
            ],
          );
        }(),
    };
  }

  Widget _buildAnswerWidget() {
    return switch (_current) {
      NounQuizItem(entry: final n) => ArticleButtons(
          onAnswer: (article) => _onAnswer(article == n.article),
        ),
      VerbQuizItem() => ConjugationField(
          onSubmit: (answer) {
            final v = _current as VerbQuizItem;
            _onAnswer(_normalise(answer) == _normalise(v.correctAnswer));
          },
        ),
    };
  }

  String _correctAnswer() => switch (_current) {
        NounQuizItem(entry: final n) =>
          '${n.article.name} ${n.word}',
        VerbQuizItem() => (_current as VerbQuizItem).correctAnswer,
      };

  static String _normalise(String s) =>
      s.trim().toLowerCase().replaceAll('ss', 'ß');

  static String _personLabel(GrammaticalPerson p) => switch (p) {
        GrammaticalPerson.ich => 'ich',
        GrammaticalPerson.du => 'du',
        GrammaticalPerson.er => 'er/sie/es',
        GrammaticalPerson.wir => 'wir',
        GrammaticalPerson.ihr => 'ihr',
        GrammaticalPerson.sie => 'sie/Sie',
      };

  static String _tenseLabel(Tense t) => switch (t) {
        Tense.praesens => 'Präsens',
        Tense.praeteritum => 'Präteritum',
        Tense.perfekt => 'Perfekt',
      };
}
