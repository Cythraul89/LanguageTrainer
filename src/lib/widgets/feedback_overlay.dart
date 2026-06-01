import 'package:flutter/material.dart';

class FeedbackOverlay extends StatelessWidget {
  const FeedbackOverlay({
    super.key,
    required this.correct,
    required this.correctAnswer,
    required this.onNext,
    this.onOverride,
  });

  final bool correct;
  final String correctAnswer;
  final VoidCallback onNext;
  final VoidCallback? onOverride;

  @override
  Widget build(BuildContext context) {
    final color = correct ? Colors.green : Colors.red;
    final icon = correct ? Icons.check_circle : Icons.cancel;
    final label = correct ? 'Correct!' : 'Incorrect';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withAlpha(30),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withAlpha(120)),
          ),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: TextStyle(
                            color: color, fontWeight: FontWeight.bold)),
                    if (!correct)
                      Text('Answer: $correctAnswer',
                          style:
                              Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (onOverride != null)
          TextButton(
            onPressed: onOverride,
            child: const Text('Mark as correct (typo / keyboard issue)'),
          ),
        FilledButton(
          onPressed: onNext,
          child: const Text('Next'),
        ),
      ],
    );
  }
}
