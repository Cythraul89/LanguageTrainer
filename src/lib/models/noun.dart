enum Article { der, die, das }

enum CefrLevel { a1, a2, b1, b2, c1, c2 }

class NounEntry {
  final String word;
  final Article article;
  final String plural;
  final String english;
  final CefrLevel level;

  const NounEntry({
    required this.word,
    required this.article,
    required this.plural,
    required this.english,
    required this.level,
  });

  String get cardId => 'noun:$word';
  String get pluralCardId => 'noun_plural:$word';
  String get translationCardId => 'noun_translation:$word';
  String get reverseCardId => 'noun_reverse:$word';
  bool get hasPlural => plural != '-';
}
