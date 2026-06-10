import 'package:language_trainer/models/noun.dart';

class AdjectiveEntry {
  final String word;
  final String english;
  final String comparative;
  final String superlative;
  final CefrLevel level;

  const AdjectiveEntry({
    required this.word,
    required this.english,
    required this.comparative,
    required this.superlative,
    required this.level,
  });

  String get translationCardId => 'adj_translation:$word';
  String get comparativeCardId => 'adj_comparative:$word';
  String get superlativeCardId => 'adj_superlative:$word';
  String get reverseCardId => 'adj_reverse:$word';
}
