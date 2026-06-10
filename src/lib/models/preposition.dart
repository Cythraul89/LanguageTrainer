import 'package:language_trainer/models/noun.dart';

class PrepositionEntry {
  final String word;
  final String english;
  final List<String> cases;
  final CefrLevel level;

  const PrepositionEntry({
    required this.word,
    required this.english,
    required this.cases,
    required this.level,
  });

  String get translationCardId => 'prep_translation:$word';
  String get caseCardId => 'prep_case:$word';

  String get casesDisplay => cases.join(' / ');
}
