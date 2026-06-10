import 'package:language_trainer/models/noun.dart';

enum GrammaticalPerson { ich, du, er, wir, ihr, sie }

enum Tense { praesens, praeteritum, perfekt }

enum Auxiliary { haben, sein }

const _haben = {
  GrammaticalPerson.ich: 'habe',
  GrammaticalPerson.du: 'hast',
  GrammaticalPerson.er: 'hat',
  GrammaticalPerson.wir: 'haben',
  GrammaticalPerson.ihr: 'habt',
  GrammaticalPerson.sie: 'haben',
};

const _sein = {
  GrammaticalPerson.ich: 'bin',
  GrammaticalPerson.du: 'bist',
  GrammaticalPerson.er: 'ist',
  GrammaticalPerson.wir: 'sind',
  GrammaticalPerson.ihr: 'seid',
  GrammaticalPerson.sie: 'sind',
};

class VerbEntry {
  final String infinitive;
  final String english;
  final Auxiliary auxiliary;
  final Map<GrammaticalPerson, String> praesens;
  final Map<GrammaticalPerson, String> praeteritum;
  final String partizip2;
  final CefrLevel level;
  final String? prefix;

  const VerbEntry({
    required this.infinitive,
    required this.english,
    required this.auxiliary,
    required this.praesens,
    required this.praeteritum,
    required this.partizip2,
    required this.level,
    this.prefix,
  });

  bool get isSeparable => prefix != null;

  // Perfekt = auxiliary (Präsens) + Partizip II, derived at runtime.
  String perfektForm(GrammaticalPerson person) {
    final auxMap = auxiliary == Auxiliary.haben ? _haben : _sein;
    return '${auxMap[person]!} $partizip2';
  }

  String cardId(GrammaticalPerson person, Tense tense) =>
      'verb:$infinitive:${person.name}:${tense.name}';
  String get translationCardId => 'verb_translation:$infinitive';
  String get partizip2CardId => 'verb_partizip2:$infinitive';
  String get auxiliaryCardId => 'verb_auxiliary:$infinitive';
  String get reverseCardId => 'verb_reverse:$infinitive';
  String get separableCardId => 'verb_separable:$infinitive';
}
