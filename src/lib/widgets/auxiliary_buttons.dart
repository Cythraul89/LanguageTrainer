import 'package:flutter/material.dart';
import 'package:language_trainer/models/verb.dart';

class AuxiliaryButtons extends StatelessWidget {
  const AuxiliaryButtons({super.key, required this.onAnswer});
  final void Function(Auxiliary) onAnswer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: Auxiliary.values
          .map(
            (a) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: FilledButton.tonal(
                  onPressed: () => onAnswer(a),
                  child: Text(a.name,
                      style: const TextStyle(fontSize: 18)),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
