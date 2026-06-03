import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:language_trainer/models/achievement.dart';
import 'package:language_trainer/models/quiz_item.dart';
import 'package:language_trainer/models/verb.dart';
import 'package:language_trainer/services/gamification_service.dart';
import 'package:language_trainer/services/review_scheduler.dart';
import 'package:language_trainer/services/sm2.dart';
import 'package:language_trainer/widgets/article_buttons.dart';
import 'package:language_trainer/widgets/auxiliary_buttons.dart';
import 'package:language_trainer/widgets/conjugation_field.dart';
import 'package:language_trainer/widgets/feedback_overlay.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({
    super.key,
    required this.items,
    required this.scheduler,
    required this.gamification,
  });
  final List<QuizItem> items;
  final ReviewScheduler scheduler;
  final GamificationService gamification;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final List<QuizItem> _queue;
  final Set<String> _seenThisSession = {};
  int _index = 0;
  bool _answered = false;
  bool _correct = false;
  bool _overridden = false;
  bool _lastWasFirstAttempt = false;

  // Set once the queue is exhausted.
  Future<SessionSummary>? _summaryFuture;

  @override
  void initState() {
    super.initState();
    _queue = List.of(widget.items);
    widget.gamification.startSession();
  }

  QuizItem get _current => _queue[_index];
  bool get _done => _index >= _queue.length;
  bool get _isFirstAttempt => !_seenThisSession.contains(_current.cardId);

  Future<void> _onAnswer(bool correct) async {
    final firstAttempt = _isFirstAttempt;
    _lastWasFirstAttempt = firstAttempt;
    _seenThisSession.add(_current.cardId);

    setState(() {
      _answered = true;
      _correct = correct;
      _overridden = false;
    });

    final grade = correct ? 5 : 0;
    final newSm2 = Sm2Service.applyGrade(_current.sm2, grade);
    await widget.scheduler.saveResult(
        _current.cardId, _current.cardType, newSm2);
    await widget.gamification
        .processAnswer(isCorrect: correct, isFirstAttempt: firstAttempt);

    if (!correct) _queue.add(_current);
  }

  void _onOverride() {
    setState(() {
      _overridden = true;
      _correct = true;
    });
    final newSm2 = Sm2Service.applyGrade(_current.sm2, 5);
    widget.scheduler.saveResult(_current.cardId, _current.cardType, newSm2);
    widget.gamification.processAnswer(isCorrect: true, isFirstAttempt: _lastWasFirstAttempt);
    if (_queue.last.cardId == _current.cardId) {
      _queue.removeLast();
    }
  }

  void _next() {
    final nextIndex = _index + 1;
    if (nextIndex >= _queue.length) {
      // Trigger session completion before rebuilding.
      _summaryFuture = widget.gamification.completeSession();
    }
    setState(() {
      _index = nextIndex;
      _answered = false;
      _overridden = false;
    });
  }

  Future<bool> _confirmQuit() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Quit review?'),
        content: const Text('Progress so far is saved.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Continue')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Quit')),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (_done) return _SessionCompleteScreen(summaryFuture: _summaryFuture!);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
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
                    onOverride: _isTextInput(_current) && !_correct && !_overridden
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
    final labelStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant);
    final subStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant);
    return switch (_current) {
      NounQuizItem(entry: final n) => _promptColumn(
          headline: n.word,
          sub: n.english,
          hint: '(${n.plural})',
          hintStyle: subStyle,
        ),
      NounPluralQuizItem(entry: final n) => _promptColumn(
          headline: '${n.article.name} ${n.word}',
          sub: n.english,
          hint: 'Plural?',
          hintStyle: labelStyle,
        ),
      NounTranslationQuizItem(entry: final n) => _promptColumn(
          headline: '${n.article.name} ${n.word}',
          hint: 'Was bedeutet dieses Wort?',
          hintStyle: labelStyle,
        ),
      VerbTranslationQuizItem(infinitive: final inf) => _promptColumn(
          headline: inf,
          hint: 'Was bedeutet dieses Verb?',
          hintStyle: labelStyle,
        ),
      VerbPartizipIIQuizItem(infinitive: final inf, english: final en) =>
        _promptColumn(
          headline: inf,
          sub: en,
          hint: 'Partizip II?',
          hintStyle: labelStyle,
        ),
      VerbAuxiliaryQuizItem(infinitive: final inf, english: final en) =>
        _promptColumn(
          headline: inf,
          sub: en,
          hint: 'haben oder sein?',
          hintStyle: labelStyle,
        ),
      NounReverseQuizItem(entry: final n) => _promptColumn(
          headline: n.english,
          hint: 'Wie heißt das Substantiv? (mit Artikel)',
          hintStyle: labelStyle,
        ),
      VerbReverseQuizItem(english: final en) => _promptColumn(
          headline: en,
          hint: 'Wie heißt das Verb?',
          hintStyle: labelStyle,
        ),
      VerbQuizItem() => () {
          final v = _current as VerbQuizItem;
          return Column(
            children: [
              Text('${_personLabel(v.person)} ___ (${v.infinitive})',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: 4),
              Text(_tenseLabel(v.tense), style: labelStyle,
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

  Widget _promptColumn({
    required String headline,
    String? sub,
    String? hint,
    TextStyle? hintStyle,
  }) =>
      Column(
        children: [
          Text(headline,
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center),
          if (sub != null) ...[
            const SizedBox(height: 8),
            Text(sub,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center),
          ],
          if (hint != null) ...[
            const SizedBox(height: 4),
            Text(hint, style: hintStyle, textAlign: TextAlign.center),
          ],
        ],
      );

  Widget _buildAnswerWidget() => switch (_current) {
        NounQuizItem(entry: final n) => ArticleButtons(
            onAnswer: (article) => _onAnswer(article == n.article),
          ),
        VerbAuxiliaryQuizItem(auxiliary: final aux) => AuxiliaryButtons(
            onAnswer: (picked) => _onAnswer(picked == aux),
          ),
        NounPluralQuizItem(entry: final n) => ConjugationField(
            hintText: 'Plural eingeben…',
            onSubmit: (answer) =>
                _onAnswer(_normalise(answer) == _normalise(n.plural)),
          ),
        NounTranslationQuizItem(entry: final n) => ConjugationField(
            hintText: 'English translation…',
            onSubmit: (answer) => _onAnswer(_acceptsTranslation(answer, n.english)),
          ),
        VerbTranslationQuizItem(english: final en) => ConjugationField(
            hintText: 'English translation…',
            onSubmit: (answer) => _onAnswer(_acceptsTranslation(answer, en)),
          ),
        VerbPartizipIIQuizItem(partizip2: final p2) => ConjugationField(
            hintText: 'Partizip II eingeben…',
            onSubmit: (answer) =>
                _onAnswer(_normalise(answer) == _normalise(p2)),
          ),
        NounReverseQuizItem(entry: final n) => ConjugationField(
            hintText: 'z. B. der Hund…',
            onSubmit: (answer) {
              final correct = '${n.article.name} ${n.word}';
              _onAnswer(_normalise(answer) == _normalise(correct));
            },
          ),
        VerbReverseQuizItem(infinitive: final inf) => ConjugationField(
            hintText: 'Infinitiv eingeben…',
            onSubmit: (answer) =>
                _onAnswer(_normalise(answer) == _normalise(inf)),
          ),
        VerbQuizItem() => ConjugationField(
            onSubmit: (answer) {
              final v = _current as VerbQuizItem;
              _onAnswer(_normalise(answer) == _normalise(v.correctAnswer));
            },
          ),
      };

  String _correctAnswer() => switch (_current) {
        NounQuizItem(entry: final n) => '${n.article.name} ${n.word}',
        NounPluralQuizItem(entry: final n) => n.plural,
        NounTranslationQuizItem(entry: final n) => n.english,
        VerbTranslationQuizItem(english: final en) => en,
        VerbPartizipIIQuizItem(partizip2: final p2) => p2,
        VerbAuxiliaryQuizItem(auxiliary: final aux) => aux.name,
        NounReverseQuizItem(entry: final n) => '${n.article.name} ${n.word}',
        VerbReverseQuizItem(infinitive: final inf) => inf,
        VerbQuizItem() => (_current as VerbQuizItem).correctAnswer,
      };

  // Whether the current card uses free-text input (override available).
  static bool _isTextInput(QuizItem item) => item is! NounQuizItem && item is! VerbAuxiliaryQuizItem;

  // Accept any slash-separated variant; strip leading "to " for verb translations.
  static bool _acceptsTranslation(String answer, String expected) {
    String norm(String s) => s.trim().toLowerCase().replaceFirst(RegExp(r'^to '), '');
    final a = norm(answer);
    return expected.split(RegExp(r'\s*/\s*')).any((v) => norm(v) == a);
  }

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

// ── Session complete screen ───────────────────────────────────────────────────

class _SessionCompleteScreen extends StatefulWidget {
  const _SessionCompleteScreen({required this.summaryFuture});
  final Future<SessionSummary> summaryFuture;

  @override
  State<_SessionCompleteScreen> createState() => _SessionCompleteScreenState();
}

class _SessionCompleteScreenState extends State<_SessionCompleteScreen> {
  late final ConfettiController _confetti;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 3));
    widget.summaryFuture.then((s) {
      if (s.leveledUp && mounted) _confetti.play();
    });
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Session Complete')),
      body: Stack(
        children: [
          FutureBuilder<SessionSummary>(
            future: widget.summaryFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final s = snapshot.data!;
              return ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const Icon(Icons.check_circle_outline,
                      size: 72, color: Colors.green),
                  const SizedBox(height: 16),
                  Text('Session complete!',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text('+${s.sessionXp} XP earned',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  _XpSummaryCard(summary: s),
                  if (s.unlocked.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text('Achievements unlocked!',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ...s.unlocked.map((a) => _AchievementUnlockedTile(a: a)),
                  ],
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back to Home'),
                  ),
                ],
              );
            },
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 40,
              gravity: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _XpSummaryCard extends StatelessWidget {
  const _XpSummaryCard({required this.summary});
  final SessionSummary summary;

  @override
  Widget build(BuildContext context) {
    final p = summary.progress;
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Level ${p.level}',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                if (summary.leveledUp) ...[
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(
                        'Level up! ${summary.previousLevel} → ${summary.newLevel}'),
                    backgroundColor:
                        theme.colorScheme.primaryContainer,
                  ),
                ],
                const Spacer(),
                Text('${p.xpIntoLevel} / ${p.xpForNextLevel} XP',
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: p.levelProgress,
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementUnlockedTile extends StatelessWidget {
  const _AchievementUnlockedTile({required this.a});
  final Achievement a;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: ListTile(
        leading: Text(a.emoji, style: const TextStyle(fontSize: 28)),
        title: Text(a.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(a.description),
      ),
    );
  }
}
