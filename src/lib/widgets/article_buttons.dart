import 'package:flutter/material.dart';
import 'package:language_trainer/models/noun.dart';

class ArticleButtons extends StatelessWidget {
  const ArticleButtons({super.key, required this.onAnswer});
  final void Function(Article) onAnswer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: Article.values
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
