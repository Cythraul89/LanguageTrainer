import 'package:flutter/material.dart';

class CaseButtons extends StatelessWidget {
  const CaseButtons({super.key, required this.onAnswer});

  final void Function(String caseLabel) onAnswer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final label in ['Akkusativ', 'Dativ', 'Genitiv'])
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: OutlinedButton(
              onPressed: () => onAnswer(label),
              child: Text(label),
            ),
          ),
      ],
    );
  }
}
