import 'package:language_trainer/models/noun.dart';
import 'package:language_trainer/models/verb.dart';

const kVerbs = <VerbEntry>[
  // ── A1 ──────────────────────────────────────────────────────────────────────
  VerbEntry(
    infinitive: 'sein', english: 'to be', auxiliary: Auxiliary.sein, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'bin',   GrammaticalPerson.du: 'bist',
      GrammaticalPerson.er: 'ist',    GrammaticalPerson.wir: 'sind',
      GrammaticalPerson.ihr: 'seid',  GrammaticalPerson.sie: 'sind',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'war',   GrammaticalPerson.du: 'warst',
      GrammaticalPerson.er: 'war',    GrammaticalPerson.wir: 'waren',
      GrammaticalPerson.ihr: 'wart',  GrammaticalPerson.sie: 'waren',
    },
    partizip2: 'gewesen',
  ),
  VerbEntry(
    infinitive: 'haben', english: 'to have', auxiliary: Auxiliary.haben, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'habe',  GrammaticalPerson.du: 'hast',
      GrammaticalPerson.er: 'hat',    GrammaticalPerson.wir: 'haben',
      GrammaticalPerson.ihr: 'habt',  GrammaticalPerson.sie: 'haben',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'hatte',   GrammaticalPerson.du: 'hattest',
      GrammaticalPerson.er: 'hatte',    GrammaticalPerson.wir: 'hatten',
      GrammaticalPerson.ihr: 'hattet',  GrammaticalPerson.sie: 'hatten',
    },
    partizip2: 'gehabt',
  ),
  VerbEntry(
    infinitive: 'werden', english: 'to become', auxiliary: Auxiliary.sein, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'werde',  GrammaticalPerson.du: 'wirst',
      GrammaticalPerson.er: 'wird',    GrammaticalPerson.wir: 'werden',
      GrammaticalPerson.ihr: 'werdet', GrammaticalPerson.sie: 'werden',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'wurde',    GrammaticalPerson.du: 'wurdest',
      GrammaticalPerson.er: 'wurde',     GrammaticalPerson.wir: 'wurden',
      GrammaticalPerson.ihr: 'wurdet',   GrammaticalPerson.sie: 'wurden',
    },
    partizip2: 'geworden',
  ),
  VerbEntry(
    infinitive: 'können', english: 'can / to be able to', auxiliary: Auxiliary.haben, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'kann',   GrammaticalPerson.du: 'kannst',
      GrammaticalPerson.er: 'kann',    GrammaticalPerson.wir: 'können',
      GrammaticalPerson.ihr: 'könnt',  GrammaticalPerson.sie: 'können',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'konnte',   GrammaticalPerson.du: 'konntest',
      GrammaticalPerson.er: 'konnte',    GrammaticalPerson.wir: 'konnten',
      GrammaticalPerson.ihr: 'konntet',  GrammaticalPerson.sie: 'konnten',
    },
    partizip2: 'gekonnt',
  ),
  VerbEntry(
    infinitive: 'müssen', english: 'must / to have to', auxiliary: Auxiliary.haben, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'muss',   GrammaticalPerson.du: 'musst',
      GrammaticalPerson.er: 'muss',    GrammaticalPerson.wir: 'müssen',
      GrammaticalPerson.ihr: 'müsst',  GrammaticalPerson.sie: 'müssen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'musste',   GrammaticalPerson.du: 'musstest',
      GrammaticalPerson.er: 'musste',    GrammaticalPerson.wir: 'mussten',
      GrammaticalPerson.ihr: 'musstet',  GrammaticalPerson.sie: 'mussten',
    },
    partizip2: 'gemusst',
  ),
  VerbEntry(
    infinitive: 'machen', english: 'to do / make', auxiliary: Auxiliary.haben, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'mache',  GrammaticalPerson.du: 'machst',
      GrammaticalPerson.er: 'macht',   GrammaticalPerson.wir: 'machen',
      GrammaticalPerson.ihr: 'macht',  GrammaticalPerson.sie: 'machen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'machte',   GrammaticalPerson.du: 'machtest',
      GrammaticalPerson.er: 'machte',    GrammaticalPerson.wir: 'machten',
      GrammaticalPerson.ihr: 'machtet',  GrammaticalPerson.sie: 'machten',
    },
    partizip2: 'gemacht',
  ),
  VerbEntry(
    infinitive: 'gehen', english: 'to go', auxiliary: Auxiliary.sein, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'gehe',  GrammaticalPerson.du: 'gehst',
      GrammaticalPerson.er: 'geht',   GrammaticalPerson.wir: 'gehen',
      GrammaticalPerson.ihr: 'geht',  GrammaticalPerson.sie: 'gehen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'ging',   GrammaticalPerson.du: 'gingst',
      GrammaticalPerson.er: 'ging',    GrammaticalPerson.wir: 'gingen',
      GrammaticalPerson.ihr: 'gingt',  GrammaticalPerson.sie: 'gingen',
    },
    partizip2: 'gegangen',
  ),
  VerbEntry(
    infinitive: 'kommen', english: 'to come', auxiliary: Auxiliary.sein, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'komme',  GrammaticalPerson.du: 'kommst',
      GrammaticalPerson.er: 'kommt',   GrammaticalPerson.wir: 'kommen',
      GrammaticalPerson.ihr: 'kommt',  GrammaticalPerson.sie: 'kommen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'kam',   GrammaticalPerson.du: 'kamst',
      GrammaticalPerson.er: 'kam',    GrammaticalPerson.wir: 'kamen',
      GrammaticalPerson.ihr: 'kamt',  GrammaticalPerson.sie: 'kamen',
    },
    partizip2: 'gekommen',
  ),
  VerbEntry(
    infinitive: 'sagen', english: 'to say', auxiliary: Auxiliary.haben, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'sage',  GrammaticalPerson.du: 'sagst',
      GrammaticalPerson.er: 'sagt',   GrammaticalPerson.wir: 'sagen',
      GrammaticalPerson.ihr: 'sagt',  GrammaticalPerson.sie: 'sagen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'sagte',   GrammaticalPerson.du: 'sagtest',
      GrammaticalPerson.er: 'sagte',    GrammaticalPerson.wir: 'sagten',
      GrammaticalPerson.ihr: 'sagtet',  GrammaticalPerson.sie: 'sagten',
    },
    partizip2: 'gesagt',
  ),
  VerbEntry(
    infinitive: 'wollen', english: 'to want', auxiliary: Auxiliary.haben, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'will',   GrammaticalPerson.du: 'willst',
      GrammaticalPerson.er: 'will',    GrammaticalPerson.wir: 'wollen',
      GrammaticalPerson.ihr: 'wollt',  GrammaticalPerson.sie: 'wollen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'wollte',   GrammaticalPerson.du: 'wolltest',
      GrammaticalPerson.er: 'wollte',    GrammaticalPerson.wir: 'wollten',
      GrammaticalPerson.ihr: 'wolltet',  GrammaticalPerson.sie: 'wollten',
    },
    partizip2: 'gewollt',
  ),
  VerbEntry(
    infinitive: 'kaufen', english: 'to buy', auxiliary: Auxiliary.haben, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'kaufe',  GrammaticalPerson.du: 'kaufst',
      GrammaticalPerson.er: 'kauft',   GrammaticalPerson.wir: 'kaufen',
      GrammaticalPerson.ihr: 'kauft',  GrammaticalPerson.sie: 'kaufen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'kaufte',   GrammaticalPerson.du: 'kauftest',
      GrammaticalPerson.er: 'kaufte',    GrammaticalPerson.wir: 'kauften',
      GrammaticalPerson.ihr: 'kauftet',  GrammaticalPerson.sie: 'kauften',
    },
    partizip2: 'gekauft',
  ),
  VerbEntry(
    infinitive: 'spielen', english: 'to play', auxiliary: Auxiliary.haben, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'spiele',  GrammaticalPerson.du: 'spielst',
      GrammaticalPerson.er: 'spielt',   GrammaticalPerson.wir: 'spielen',
      GrammaticalPerson.ihr: 'spielt',  GrammaticalPerson.sie: 'spielen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'spielte',   GrammaticalPerson.du: 'spieltest',
      GrammaticalPerson.er: 'spielte',    GrammaticalPerson.wir: 'spielten',
      GrammaticalPerson.ihr: 'spieltet',  GrammaticalPerson.sie: 'spielten',
    },
    partizip2: 'gespielt',
  ),
  VerbEntry(
    infinitive: 'trinken', english: 'to drink', auxiliary: Auxiliary.haben, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'trinke',  GrammaticalPerson.du: 'trinkst',
      GrammaticalPerson.er: 'trinkt',   GrammaticalPerson.wir: 'trinken',
      GrammaticalPerson.ihr: 'trinkt',  GrammaticalPerson.sie: 'trinken',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'trank',   GrammaticalPerson.du: 'trankst',
      GrammaticalPerson.er: 'trank',    GrammaticalPerson.wir: 'tranken',
      GrammaticalPerson.ihr: 'trankt',  GrammaticalPerson.sie: 'tranken',
    },
    partizip2: 'getrunken',
  ),
  VerbEntry(
    infinitive: 'essen', english: 'to eat', auxiliary: Auxiliary.haben, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'esse',  GrammaticalPerson.du: 'isst',
      GrammaticalPerson.er: 'isst',   GrammaticalPerson.wir: 'essen',
      GrammaticalPerson.ihr: 'esst',  GrammaticalPerson.sie: 'essen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'aß',   GrammaticalPerson.du: 'aßest',
      GrammaticalPerson.er: 'aß',    GrammaticalPerson.wir: 'aßen',
      GrammaticalPerson.ihr: 'aßt',  GrammaticalPerson.sie: 'aßen',
    },
    partizip2: 'gegessen',
  ),
  VerbEntry(
    infinitive: 'wohnen', english: 'to live / reside', auxiliary: Auxiliary.haben, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'wohne',  GrammaticalPerson.du: 'wohnst',
      GrammaticalPerson.er: 'wohnt',   GrammaticalPerson.wir: 'wohnen',
      GrammaticalPerson.ihr: 'wohnt',  GrammaticalPerson.sie: 'wohnen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'wohnte',   GrammaticalPerson.du: 'wohntest',
      GrammaticalPerson.er: 'wohnte',    GrammaticalPerson.wir: 'wohnten',
      GrammaticalPerson.ihr: 'wohntet',  GrammaticalPerson.sie: 'wohnten',
    },
    partizip2: 'gewohnt',
  ),
  VerbEntry(
    infinitive: 'lernen', english: 'to learn', auxiliary: Auxiliary.haben, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'lerne',  GrammaticalPerson.du: 'lernst',
      GrammaticalPerson.er: 'lernt',   GrammaticalPerson.wir: 'lernen',
      GrammaticalPerson.ihr: 'lernt',  GrammaticalPerson.sie: 'lernen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'lernte',   GrammaticalPerson.du: 'lerntest',
      GrammaticalPerson.er: 'lernte',    GrammaticalPerson.wir: 'lernten',
      GrammaticalPerson.ihr: 'lerntet',  GrammaticalPerson.sie: 'lernten',
    },
    partizip2: 'gelernt',
  ),
  VerbEntry(
    infinitive: 'heißen', english: 'to be called', auxiliary: Auxiliary.haben, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'heiße',  GrammaticalPerson.du: 'heißt',
      GrammaticalPerson.er: 'heißt',   GrammaticalPerson.wir: 'heißen',
      GrammaticalPerson.ihr: 'heißt',  GrammaticalPerson.sie: 'heißen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'hieß',    GrammaticalPerson.du: 'hießt',
      GrammaticalPerson.er: 'hieß',     GrammaticalPerson.wir: 'hießen',
      GrammaticalPerson.ihr: 'hießt',   GrammaticalPerson.sie: 'hießen',
    },
    partizip2: 'geheißen',
  ),
  VerbEntry(
    infinitive: 'schlafen', english: 'to sleep', auxiliary: Auxiliary.haben, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'schlafe',  GrammaticalPerson.du: 'schläfst',
      GrammaticalPerson.er: 'schläft',   GrammaticalPerson.wir: 'schlafen',
      GrammaticalPerson.ihr: 'schlaft',  GrammaticalPerson.sie: 'schlafen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'schlief',    GrammaticalPerson.du: 'schliefst',
      GrammaticalPerson.er: 'schlief',     GrammaticalPerson.wir: 'schliefen',
      GrammaticalPerson.ihr: 'schlieft',   GrammaticalPerson.sie: 'schliefen',
    },
    partizip2: 'geschlafen',
  ),
  VerbEntry(
    infinitive: 'laufen', english: 'to run / walk', auxiliary: Auxiliary.sein, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'laufe',  GrammaticalPerson.du: 'läufst',
      GrammaticalPerson.er: 'läuft',   GrammaticalPerson.wir: 'laufen',
      GrammaticalPerson.ihr: 'lauft',  GrammaticalPerson.sie: 'laufen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'lief',    GrammaticalPerson.du: 'liefst',
      GrammaticalPerson.er: 'lief',     GrammaticalPerson.wir: 'liefen',
      GrammaticalPerson.ihr: 'lieft',   GrammaticalPerson.sie: 'liefen',
    },
    partizip2: 'gelaufen',
  ),
  VerbEntry(
    infinitive: 'suchen', english: 'to look for / search', auxiliary: Auxiliary.haben, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'suche',  GrammaticalPerson.du: 'suchst',
      GrammaticalPerson.er: 'sucht',   GrammaticalPerson.wir: 'suchen',
      GrammaticalPerson.ihr: 'sucht',  GrammaticalPerson.sie: 'suchen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'suchte',   GrammaticalPerson.du: 'suchtest',
      GrammaticalPerson.er: 'suchte',    GrammaticalPerson.wir: 'suchten',
      GrammaticalPerson.ihr: 'suchtet',  GrammaticalPerson.sie: 'suchten',
    },
    partizip2: 'gesucht',
  ),
  VerbEntry(
    infinitive: 'fragen', english: 'to ask', auxiliary: Auxiliary.haben, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'frage',  GrammaticalPerson.du: 'fragst',
      GrammaticalPerson.er: 'fragt',   GrammaticalPerson.wir: 'fragen',
      GrammaticalPerson.ihr: 'fragt',  GrammaticalPerson.sie: 'fragen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'fragte',   GrammaticalPerson.du: 'fragtest',
      GrammaticalPerson.er: 'fragte',    GrammaticalPerson.wir: 'fragten',
      GrammaticalPerson.ihr: 'fragtet',  GrammaticalPerson.sie: 'fragten',
    },
    partizip2: 'gefragt',
  ),
  VerbEntry(
    infinitive: 'arbeiten', english: 'to work', auxiliary: Auxiliary.haben, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'arbeite',  GrammaticalPerson.du: 'arbeitest',
      GrammaticalPerson.er: 'arbeitet',  GrammaticalPerson.wir: 'arbeiten',
      GrammaticalPerson.ihr: 'arbeitet', GrammaticalPerson.sie: 'arbeiten',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'arbeitete',   GrammaticalPerson.du: 'arbeitetest',
      GrammaticalPerson.er: 'arbeitete',    GrammaticalPerson.wir: 'arbeiteten',
      GrammaticalPerson.ihr: 'arbeitetet',  GrammaticalPerson.sie: 'arbeiteten',
    },
    partizip2: 'gearbeitet',
  ),
  VerbEntry(
    infinitive: 'hören', english: 'to hear / listen', auxiliary: Auxiliary.haben, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'höre',  GrammaticalPerson.du: 'hörst',
      GrammaticalPerson.er: 'hört',   GrammaticalPerson.wir: 'hören',
      GrammaticalPerson.ihr: 'hört',  GrammaticalPerson.sie: 'hören',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'hörte',   GrammaticalPerson.du: 'hörtest',
      GrammaticalPerson.er: 'hörte',    GrammaticalPerson.wir: 'hörten',
      GrammaticalPerson.ihr: 'hörtet',  GrammaticalPerson.sie: 'hörten',
    },
    partizip2: 'gehört',
  ),
  VerbEntry(
    infinitive: 'kennen', english: 'to know (a person/place)', auxiliary: Auxiliary.haben, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'kenne',  GrammaticalPerson.du: 'kennst',
      GrammaticalPerson.er: 'kennt',   GrammaticalPerson.wir: 'kennen',
      GrammaticalPerson.ihr: 'kennt',  GrammaticalPerson.sie: 'kennen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'kannte',   GrammaticalPerson.du: 'kanntest',
      GrammaticalPerson.er: 'kannte',    GrammaticalPerson.wir: 'kannten',
      GrammaticalPerson.ihr: 'kanntet',  GrammaticalPerson.sie: 'kannten',
    },
    partizip2: 'gekannt',
  ),
  VerbEntry(
    infinitive: 'bringen', english: 'to bring', auxiliary: Auxiliary.haben, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'bringe',  GrammaticalPerson.du: 'bringst',
      GrammaticalPerson.er: 'bringt',   GrammaticalPerson.wir: 'bringen',
      GrammaticalPerson.ihr: 'bringt',  GrammaticalPerson.sie: 'bringen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'brachte',   GrammaticalPerson.du: 'brachtest',
      GrammaticalPerson.er: 'brachte',    GrammaticalPerson.wir: 'brachten',
      GrammaticalPerson.ihr: 'brachtet',  GrammaticalPerson.sie: 'brachten',
    },
    partizip2: 'gebracht',
  ),
  VerbEntry(
    infinitive: 'liegen', english: 'to lie / be situated', auxiliary: Auxiliary.haben, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'liege',  GrammaticalPerson.du: 'liegst',
      GrammaticalPerson.er: 'liegt',   GrammaticalPerson.wir: 'liegen',
      GrammaticalPerson.ihr: 'liegt',  GrammaticalPerson.sie: 'liegen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'lag',   GrammaticalPerson.du: 'lagst',
      GrammaticalPerson.er: 'lag',    GrammaticalPerson.wir: 'lagen',
      GrammaticalPerson.ihr: 'lagt',  GrammaticalPerson.sie: 'lagen',
    },
    partizip2: 'gelegen',
  ),
  VerbEntry(
    infinitive: 'helfen', english: 'to help', auxiliary: Auxiliary.haben, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'helfe',  GrammaticalPerson.du: 'hilfst',
      GrammaticalPerson.er: 'hilft',   GrammaticalPerson.wir: 'helfen',
      GrammaticalPerson.ihr: 'helft',  GrammaticalPerson.sie: 'helfen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'half',    GrammaticalPerson.du: 'halfst',
      GrammaticalPerson.er: 'half',     GrammaticalPerson.wir: 'halfen',
      GrammaticalPerson.ihr: 'halft',   GrammaticalPerson.sie: 'halfen',
    },
    partizip2: 'geholfen',
  ),
  VerbEntry(
    infinitive: 'finden', english: 'to find', auxiliary: Auxiliary.haben, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'finde',  GrammaticalPerson.du: 'findest',
      GrammaticalPerson.er: 'findet',  GrammaticalPerson.wir: 'finden',
      GrammaticalPerson.ihr: 'findet', GrammaticalPerson.sie: 'finden',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'fand',    GrammaticalPerson.du: 'fandst',
      GrammaticalPerson.er: 'fand',     GrammaticalPerson.wir: 'fanden',
      GrammaticalPerson.ihr: 'fandet',  GrammaticalPerson.sie: 'fanden',
    },
    partizip2: 'gefunden',
  ),
  VerbEntry(
    infinitive: 'brauchen', english: 'to need', auxiliary: Auxiliary.haben, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'brauche',  GrammaticalPerson.du: 'brauchst',
      GrammaticalPerson.er: 'braucht',   GrammaticalPerson.wir: 'brauchen',
      GrammaticalPerson.ihr: 'braucht',  GrammaticalPerson.sie: 'brauchen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'brauchte',   GrammaticalPerson.du: 'brauchtest',
      GrammaticalPerson.er: 'brauchte',    GrammaticalPerson.wir: 'brauchten',
      GrammaticalPerson.ihr: 'brauchtet',  GrammaticalPerson.sie: 'brauchten',
    },
    partizip2: 'gebraucht',
  ),
  VerbEntry(
    infinitive: 'bezahlen', english: 'to pay', auxiliary: Auxiliary.haben, level: CefrLevel.a1,
    praesens: {
      GrammaticalPerson.ich: 'bezahle',  GrammaticalPerson.du: 'bezahlst',
      GrammaticalPerson.er: 'bezahlt',   GrammaticalPerson.wir: 'bezahlen',
      GrammaticalPerson.ihr: 'bezahlt',  GrammaticalPerson.sie: 'bezahlen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'bezahlte',   GrammaticalPerson.du: 'bezahltest',
      GrammaticalPerson.er: 'bezahlte',    GrammaticalPerson.wir: 'bezahlten',
      GrammaticalPerson.ihr: 'bezahltet',  GrammaticalPerson.sie: 'bezahlten',
    },
    partizip2: 'bezahlt',
  ),

  // ── A2 ──────────────────────────────────────────────────────────────────────
  VerbEntry(
    infinitive: 'sollen', english: 'should / to be supposed to', auxiliary: Auxiliary.haben, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'soll',   GrammaticalPerson.du: 'sollst',
      GrammaticalPerson.er: 'soll',    GrammaticalPerson.wir: 'sollen',
      GrammaticalPerson.ihr: 'sollt',  GrammaticalPerson.sie: 'sollen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'sollte',   GrammaticalPerson.du: 'solltest',
      GrammaticalPerson.er: 'sollte',    GrammaticalPerson.wir: 'sollten',
      GrammaticalPerson.ihr: 'solltet',  GrammaticalPerson.sie: 'sollten',
    },
    partizip2: 'gesollt',
  ),
  VerbEntry(
    infinitive: 'dürfen', english: 'may / to be allowed to', auxiliary: Auxiliary.haben, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'darf',   GrammaticalPerson.du: 'darfst',
      GrammaticalPerson.er: 'darf',    GrammaticalPerson.wir: 'dürfen',
      GrammaticalPerson.ihr: 'dürft',  GrammaticalPerson.sie: 'dürfen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'durfte',   GrammaticalPerson.du: 'durftest',
      GrammaticalPerson.er: 'durfte',    GrammaticalPerson.wir: 'durften',
      GrammaticalPerson.ihr: 'durftet',  GrammaticalPerson.sie: 'durften',
    },
    partizip2: 'gedurft',
  ),
  VerbEntry(
    infinitive: 'mögen', english: 'to like', auxiliary: Auxiliary.haben, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'mag',    GrammaticalPerson.du: 'magst',
      GrammaticalPerson.er: 'mag',     GrammaticalPerson.wir: 'mögen',
      GrammaticalPerson.ihr: 'mögt',   GrammaticalPerson.sie: 'mögen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'mochte',   GrammaticalPerson.du: 'mochtest',
      GrammaticalPerson.er: 'mochte',    GrammaticalPerson.wir: 'mochten',
      GrammaticalPerson.ihr: 'mochtet',  GrammaticalPerson.sie: 'mochten',
    },
    partizip2: 'gemocht',
  ),
  VerbEntry(
    infinitive: 'sehen', english: 'to see', auxiliary: Auxiliary.haben, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'sehe',  GrammaticalPerson.du: 'siehst',
      GrammaticalPerson.er: 'sieht',  GrammaticalPerson.wir: 'sehen',
      GrammaticalPerson.ihr: 'seht',  GrammaticalPerson.sie: 'sehen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'sah',   GrammaticalPerson.du: 'sahst',
      GrammaticalPerson.er: 'sah',    GrammaticalPerson.wir: 'sahen',
      GrammaticalPerson.ihr: 'saht',  GrammaticalPerson.sie: 'sahen',
    },
    partizip2: 'gesehen',
  ),
  VerbEntry(
    infinitive: 'wissen', english: 'to know (a fact)', auxiliary: Auxiliary.haben, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'weiß',   GrammaticalPerson.du: 'weißt',
      GrammaticalPerson.er: 'weiß',    GrammaticalPerson.wir: 'wissen',
      GrammaticalPerson.ihr: 'wisst',  GrammaticalPerson.sie: 'wissen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'wusste',   GrammaticalPerson.du: 'wusstest',
      GrammaticalPerson.er: 'wusste',    GrammaticalPerson.wir: 'wussten',
      GrammaticalPerson.ihr: 'wusstet',  GrammaticalPerson.sie: 'wussten',
    },
    partizip2: 'gewusst',
  ),
  VerbEntry(
    infinitive: 'nehmen', english: 'to take', auxiliary: Auxiliary.haben, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'nehme',  GrammaticalPerson.du: 'nimmst',
      GrammaticalPerson.er: 'nimmt',   GrammaticalPerson.wir: 'nehmen',
      GrammaticalPerson.ihr: 'nehmt',  GrammaticalPerson.sie: 'nehmen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'nahm',   GrammaticalPerson.du: 'nahmst',
      GrammaticalPerson.er: 'nahm',    GrammaticalPerson.wir: 'nahmen',
      GrammaticalPerson.ihr: 'nahmt',  GrammaticalPerson.sie: 'nahmen',
    },
    partizip2: 'genommen',
  ),
  VerbEntry(
    infinitive: 'geben', english: 'to give', auxiliary: Auxiliary.haben, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'gebe',  GrammaticalPerson.du: 'gibst',
      GrammaticalPerson.er: 'gibt',   GrammaticalPerson.wir: 'geben',
      GrammaticalPerson.ihr: 'gebt',  GrammaticalPerson.sie: 'geben',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'gab',   GrammaticalPerson.du: 'gabst',
      GrammaticalPerson.er: 'gab',    GrammaticalPerson.wir: 'gaben',
      GrammaticalPerson.ihr: 'gabt',  GrammaticalPerson.sie: 'gaben',
    },
    partizip2: 'gegeben',
  ),
  VerbEntry(
    infinitive: 'fahren', english: 'to drive / travel', auxiliary: Auxiliary.sein, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'fahre',  GrammaticalPerson.du: 'fährst',
      GrammaticalPerson.er: 'fährt',   GrammaticalPerson.wir: 'fahren',
      GrammaticalPerson.ihr: 'fahrt',  GrammaticalPerson.sie: 'fahren',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'fuhr',   GrammaticalPerson.du: 'fuhrst',
      GrammaticalPerson.er: 'fuhr',    GrammaticalPerson.wir: 'fuhren',
      GrammaticalPerson.ihr: 'fuhrt',  GrammaticalPerson.sie: 'fuhren',
    },
    partizip2: 'gefahren',
  ),
  VerbEntry(
    infinitive: 'lesen', english: 'to read', auxiliary: Auxiliary.haben, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'lese',  GrammaticalPerson.du: 'liest',
      GrammaticalPerson.er: 'liest',  GrammaticalPerson.wir: 'lesen',
      GrammaticalPerson.ihr: 'lest',  GrammaticalPerson.sie: 'lesen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'las',   GrammaticalPerson.du: 'last',
      GrammaticalPerson.er: 'las',    GrammaticalPerson.wir: 'lasen',
      GrammaticalPerson.ihr: 'last',  GrammaticalPerson.sie: 'lasen',
    },
    partizip2: 'gelesen',
  ),
  VerbEntry(
    infinitive: 'stehen', english: 'to stand', auxiliary: Auxiliary.haben, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'stehe',  GrammaticalPerson.du: 'stehst',
      GrammaticalPerson.er: 'steht',   GrammaticalPerson.wir: 'stehen',
      GrammaticalPerson.ihr: 'steht',  GrammaticalPerson.sie: 'stehen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'stand',    GrammaticalPerson.du: 'standst',
      GrammaticalPerson.er: 'stand',     GrammaticalPerson.wir: 'standen',
      GrammaticalPerson.ihr: 'standet',  GrammaticalPerson.sie: 'standen',
    },
    partizip2: 'gestanden',
  ),
  VerbEntry(
    infinitive: 'schreiben', english: 'to write', auxiliary: Auxiliary.haben, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'schreibe',  GrammaticalPerson.du: 'schreibst',
      GrammaticalPerson.er: 'schreibt',   GrammaticalPerson.wir: 'schreiben',
      GrammaticalPerson.ihr: 'schreibt',  GrammaticalPerson.sie: 'schreiben',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'schrieb',    GrammaticalPerson.du: 'schriebst',
      GrammaticalPerson.er: 'schrieb',     GrammaticalPerson.wir: 'schrieben',
      GrammaticalPerson.ihr: 'schriebt',   GrammaticalPerson.sie: 'schrieben',
    },
    partizip2: 'geschrieben',
  ),
  VerbEntry(
    infinitive: 'bleiben', english: 'to stay / remain', auxiliary: Auxiliary.sein, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'bleibe',  GrammaticalPerson.du: 'bleibst',
      GrammaticalPerson.er: 'bleibt',   GrammaticalPerson.wir: 'bleiben',
      GrammaticalPerson.ihr: 'bleibt',  GrammaticalPerson.sie: 'bleiben',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'blieb',    GrammaticalPerson.du: 'bliebst',
      GrammaticalPerson.er: 'blieb',     GrammaticalPerson.wir: 'blieben',
      GrammaticalPerson.ihr: 'bliebt',   GrammaticalPerson.sie: 'blieben',
    },
    partizip2: 'geblieben',
  ),
  VerbEntry(
    infinitive: 'treffen', english: 'to meet', auxiliary: Auxiliary.haben, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'treffe',  GrammaticalPerson.du: 'triffst',
      GrammaticalPerson.er: 'trifft',   GrammaticalPerson.wir: 'treffen',
      GrammaticalPerson.ihr: 'trefft',  GrammaticalPerson.sie: 'treffen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'traf',    GrammaticalPerson.du: 'trafst',
      GrammaticalPerson.er: 'traf',     GrammaticalPerson.wir: 'trafen',
      GrammaticalPerson.ihr: 'traft',   GrammaticalPerson.sie: 'trafen',
    },
    partizip2: 'getroffen',
  ),
  VerbEntry(
    infinitive: 'fangen', english: 'to catch', auxiliary: Auxiliary.haben, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'fange',  GrammaticalPerson.du: 'fängst',
      GrammaticalPerson.er: 'fängt',   GrammaticalPerson.wir: 'fangen',
      GrammaticalPerson.ihr: 'fangt',  GrammaticalPerson.sie: 'fangen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'fing',    GrammaticalPerson.du: 'fingst',
      GrammaticalPerson.er: 'fing',     GrammaticalPerson.wir: 'fingen',
      GrammaticalPerson.ihr: 'fingt',   GrammaticalPerson.sie: 'fingen',
    },
    partizip2: 'gefangen',
  ),
  VerbEntry(
    infinitive: 'tragen', english: 'to carry / wear', auxiliary: Auxiliary.haben, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'trage',  GrammaticalPerson.du: 'trägst',
      GrammaticalPerson.er: 'trägt',   GrammaticalPerson.wir: 'tragen',
      GrammaticalPerson.ihr: 'tragt',  GrammaticalPerson.sie: 'tragen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'trug',    GrammaticalPerson.du: 'trugst',
      GrammaticalPerson.er: 'trug',     GrammaticalPerson.wir: 'trugen',
      GrammaticalPerson.ihr: 'trugt',   GrammaticalPerson.sie: 'trugen',
    },
    partizip2: 'getragen',
  ),
  VerbEntry(
    infinitive: 'rufen', english: 'to call / shout', auxiliary: Auxiliary.haben, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'rufe',  GrammaticalPerson.du: 'rufst',
      GrammaticalPerson.er: 'ruft',   GrammaticalPerson.wir: 'rufen',
      GrammaticalPerson.ihr: 'ruft',  GrammaticalPerson.sie: 'rufen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'rief',    GrammaticalPerson.du: 'riefst',
      GrammaticalPerson.er: 'rief',     GrammaticalPerson.wir: 'riefen',
      GrammaticalPerson.ihr: 'rieft',   GrammaticalPerson.sie: 'riefen',
    },
    partizip2: 'gerufen',
  ),
  VerbEntry(
    infinitive: 'fallen', english: 'to fall', auxiliary: Auxiliary.sein, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'falle',  GrammaticalPerson.du: 'fällst',
      GrammaticalPerson.er: 'fällt',   GrammaticalPerson.wir: 'fallen',
      GrammaticalPerson.ihr: 'fallt',  GrammaticalPerson.sie: 'fallen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'fiel',    GrammaticalPerson.du: 'fielst',
      GrammaticalPerson.er: 'fiel',     GrammaticalPerson.wir: 'fielen',
      GrammaticalPerson.ihr: 'fielt',   GrammaticalPerson.sie: 'fielen',
    },
    partizip2: 'gefallen',
  ),
  VerbEntry(
    infinitive: 'zeigen', english: 'to show / point', auxiliary: Auxiliary.haben, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'zeige',  GrammaticalPerson.du: 'zeigst',
      GrammaticalPerson.er: 'zeigt',   GrammaticalPerson.wir: 'zeigen',
      GrammaticalPerson.ihr: 'zeigt',  GrammaticalPerson.sie: 'zeigen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'zeigte',   GrammaticalPerson.du: 'zeigtest',
      GrammaticalPerson.er: 'zeigte',    GrammaticalPerson.wir: 'zeigten',
      GrammaticalPerson.ihr: 'zeigtet',  GrammaticalPerson.sie: 'zeigten',
    },
    partizip2: 'gezeigt',
  ),
  VerbEntry(
    infinitive: 'öffnen', english: 'to open', auxiliary: Auxiliary.haben, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'öffne',  GrammaticalPerson.du: 'öffnest',
      GrammaticalPerson.er: 'öffnet',  GrammaticalPerson.wir: 'öffnen',
      GrammaticalPerson.ihr: 'öffnet', GrammaticalPerson.sie: 'öffnen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'öffnete',   GrammaticalPerson.du: 'öffnetest',
      GrammaticalPerson.er: 'öffnete',    GrammaticalPerson.wir: 'öffneten',
      GrammaticalPerson.ihr: 'öffnetet',  GrammaticalPerson.sie: 'öffneten',
    },
    partizip2: 'geöffnet',
  ),
  VerbEntry(
    infinitive: 'schließen', english: 'to close', auxiliary: Auxiliary.haben, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'schließe',  GrammaticalPerson.du: 'schließt',
      GrammaticalPerson.er: 'schließt',   GrammaticalPerson.wir: 'schließen',
      GrammaticalPerson.ihr: 'schließt',  GrammaticalPerson.sie: 'schließen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'schloss',    GrammaticalPerson.du: 'schlossest',
      GrammaticalPerson.er: 'schloss',     GrammaticalPerson.wir: 'schlossen',
      GrammaticalPerson.ihr: 'schlosset',  GrammaticalPerson.sie: 'schlossen',
    },
    partizip2: 'geschlossen',
  ),
  VerbEntry(
    infinitive: 'beginnen', english: 'to begin', auxiliary: Auxiliary.haben, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'beginne',  GrammaticalPerson.du: 'beginnst',
      GrammaticalPerson.er: 'beginnt',   GrammaticalPerson.wir: 'beginnen',
      GrammaticalPerson.ihr: 'beginnt',  GrammaticalPerson.sie: 'beginnen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'begann',    GrammaticalPerson.du: 'begannst',
      GrammaticalPerson.er: 'begann',     GrammaticalPerson.wir: 'begannen',
      GrammaticalPerson.ihr: 'begannt',   GrammaticalPerson.sie: 'begannen',
    },
    partizip2: 'begonnen',
  ),
  VerbEntry(
    infinitive: 'kosten', english: 'to cost', auxiliary: Auxiliary.haben, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'koste',  GrammaticalPerson.du: 'kostest',
      GrammaticalPerson.er: 'kostet',  GrammaticalPerson.wir: 'kosten',
      GrammaticalPerson.ihr: 'kostet', GrammaticalPerson.sie: 'kosten',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'kostete',   GrammaticalPerson.du: 'kostetest',
      GrammaticalPerson.er: 'kostete',    GrammaticalPerson.wir: 'kosteten',
      GrammaticalPerson.ihr: 'kostetet',  GrammaticalPerson.sie: 'kosteten',
    },
    partizip2: 'gekostet',
  ),
  VerbEntry(
    infinitive: 'reisen', english: 'to travel', auxiliary: Auxiliary.sein, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'reise',  GrammaticalPerson.du: 'reist',
      GrammaticalPerson.er: 'reist',   GrammaticalPerson.wir: 'reisen',
      GrammaticalPerson.ihr: 'reist',  GrammaticalPerson.sie: 'reisen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'reiste',   GrammaticalPerson.du: 'reistest',
      GrammaticalPerson.er: 'reiste',    GrammaticalPerson.wir: 'reisten',
      GrammaticalPerson.ihr: 'reistet',  GrammaticalPerson.sie: 'reisten',
    },
    partizip2: 'gereist',
  ),
  VerbEntry(
    infinitive: 'einladen', english: 'to invite', auxiliary: Auxiliary.haben, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'lade ein',   GrammaticalPerson.du: 'lädst ein',
      GrammaticalPerson.er: 'lädt ein',    GrammaticalPerson.wir: 'laden ein',
      GrammaticalPerson.ihr: 'ladet ein',  GrammaticalPerson.sie: 'laden ein',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'lud ein',    GrammaticalPerson.du: 'ludst ein',
      GrammaticalPerson.er: 'lud ein',     GrammaticalPerson.wir: 'luden ein',
      GrammaticalPerson.ihr: 'ludet ein',  GrammaticalPerson.sie: 'luden ein',
    },
    partizip2: 'eingeladen',
  ),
  VerbEntry(
    infinitive: 'anrufen', english: 'to phone / call', auxiliary: Auxiliary.haben, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'rufe an',   GrammaticalPerson.du: 'rufst an',
      GrammaticalPerson.er: 'ruft an',    GrammaticalPerson.wir: 'rufen an',
      GrammaticalPerson.ihr: 'ruft an',   GrammaticalPerson.sie: 'rufen an',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'rief an',    GrammaticalPerson.du: 'riefst an',
      GrammaticalPerson.er: 'rief an',     GrammaticalPerson.wir: 'riefen an',
      GrammaticalPerson.ihr: 'rieft an',   GrammaticalPerson.sie: 'riefen an',
    },
    partizip2: 'angerufen',
  ),
  VerbEntry(
    infinitive: 'aufstehen', english: 'to get up / stand up', auxiliary: Auxiliary.sein, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'stehe auf',   GrammaticalPerson.du: 'stehst auf',
      GrammaticalPerson.er: 'steht auf',    GrammaticalPerson.wir: 'stehen auf',
      GrammaticalPerson.ihr: 'steht auf',   GrammaticalPerson.sie: 'stehen auf',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'stand auf',    GrammaticalPerson.du: 'standst auf',
      GrammaticalPerson.er: 'stand auf',     GrammaticalPerson.wir: 'standen auf',
      GrammaticalPerson.ihr: 'standet auf',  GrammaticalPerson.sie: 'standen auf',
    },
    partizip2: 'aufgestanden',
  ),
  VerbEntry(
    infinitive: 'abholen', english: 'to pick up / collect', auxiliary: Auxiliary.haben, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'hole ab',   GrammaticalPerson.du: 'holst ab',
      GrammaticalPerson.er: 'holt ab',    GrammaticalPerson.wir: 'holen ab',
      GrammaticalPerson.ihr: 'holt ab',   GrammaticalPerson.sie: 'holen ab',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'holte ab',   GrammaticalPerson.du: 'holtest ab',
      GrammaticalPerson.er: 'holte ab',    GrammaticalPerson.wir: 'holten ab',
      GrammaticalPerson.ihr: 'holtet ab',  GrammaticalPerson.sie: 'holten ab',
    },
    partizip2: 'abgeholt',
  ),
  VerbEntry(
    infinitive: 'verstehen', english: 'to understand', auxiliary: Auxiliary.haben, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'verstehe',  GrammaticalPerson.du: 'verstehst',
      GrammaticalPerson.er: 'versteht',   GrammaticalPerson.wir: 'verstehen',
      GrammaticalPerson.ihr: 'versteht',  GrammaticalPerson.sie: 'verstehen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'verstand',    GrammaticalPerson.du: 'verstandst',
      GrammaticalPerson.er: 'verstand',     GrammaticalPerson.wir: 'verstanden',
      GrammaticalPerson.ihr: 'verstandet',  GrammaticalPerson.sie: 'verstanden',
    },
    partizip2: 'verstanden',
  ),
  VerbEntry(
    infinitive: 'putzen', english: 'to clean', auxiliary: Auxiliary.haben, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'putze',  GrammaticalPerson.du: 'putzt',
      GrammaticalPerson.er: 'putzt',   GrammaticalPerson.wir: 'putzen',
      GrammaticalPerson.ihr: 'putzt',  GrammaticalPerson.sie: 'putzen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'putzte',   GrammaticalPerson.du: 'putztest',
      GrammaticalPerson.er: 'putzte',    GrammaticalPerson.wir: 'putzten',
      GrammaticalPerson.ihr: 'putztet',  GrammaticalPerson.sie: 'putzten',
    },
    partizip2: 'geputzt',
  ),
  VerbEntry(
    infinitive: 'wechseln', english: 'to change / exchange', auxiliary: Auxiliary.haben, level: CefrLevel.a2,
    praesens: {
      GrammaticalPerson.ich: 'wechsle',  GrammaticalPerson.du: 'wechselst',
      GrammaticalPerson.er: 'wechselt',  GrammaticalPerson.wir: 'wechseln',
      GrammaticalPerson.ihr: 'wechselt', GrammaticalPerson.sie: 'wechseln',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'wechselte',   GrammaticalPerson.du: 'wechseltest',
      GrammaticalPerson.er: 'wechselte',    GrammaticalPerson.wir: 'wechselten',
      GrammaticalPerson.ihr: 'wechseltet',  GrammaticalPerson.sie: 'wechselten',
    },
    partizip2: 'gewechselt',
  ),

  // ── B1 ──────────────────────────────────────────────────────────────────────
  VerbEntry(
    infinitive: 'sprechen', english: 'to speak', auxiliary: Auxiliary.haben, level: CefrLevel.b1,
    praesens: {
      GrammaticalPerson.ich: 'spreche',  GrammaticalPerson.du: 'sprichst',
      GrammaticalPerson.er: 'spricht',   GrammaticalPerson.wir: 'sprechen',
      GrammaticalPerson.ihr: 'sprecht',  GrammaticalPerson.sie: 'sprechen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'sprach',    GrammaticalPerson.du: 'sprachst',
      GrammaticalPerson.er: 'sprach',     GrammaticalPerson.wir: 'sprachen',
      GrammaticalPerson.ihr: 'spracht',   GrammaticalPerson.sie: 'sprachen',
    },
    partizip2: 'gesprochen',
  ),
  VerbEntry(
    infinitive: 'denken', english: 'to think', auxiliary: Auxiliary.haben, level: CefrLevel.b1,
    praesens: {
      GrammaticalPerson.ich: 'denke',  GrammaticalPerson.du: 'denkst',
      GrammaticalPerson.er: 'denkt',   GrammaticalPerson.wir: 'denken',
      GrammaticalPerson.ihr: 'denkt',  GrammaticalPerson.sie: 'denken',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'dachte',   GrammaticalPerson.du: 'dachtest',
      GrammaticalPerson.er: 'dachte',    GrammaticalPerson.wir: 'dachten',
      GrammaticalPerson.ihr: 'dachtet',  GrammaticalPerson.sie: 'dachten',
    },
    partizip2: 'gedacht',
  ),
  VerbEntry(
    infinitive: 'entscheiden', english: 'to decide', auxiliary: Auxiliary.haben, level: CefrLevel.b1,
    praesens: {
      GrammaticalPerson.ich: 'entscheide',  GrammaticalPerson.du: 'entscheidest',
      GrammaticalPerson.er: 'entscheidet',  GrammaticalPerson.wir: 'entscheiden',
      GrammaticalPerson.ihr: 'entscheidet', GrammaticalPerson.sie: 'entscheiden',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'entschied',    GrammaticalPerson.du: 'entschiedst',
      GrammaticalPerson.er: 'entschied',     GrammaticalPerson.wir: 'entschieden',
      GrammaticalPerson.ihr: 'entschiedet',  GrammaticalPerson.sie: 'entschieden',
    },
    partizip2: 'entschieden',
  ),
  VerbEntry(
    infinitive: 'erklären', english: 'to explain', auxiliary: Auxiliary.haben, level: CefrLevel.b1,
    praesens: {
      GrammaticalPerson.ich: 'erkläre',  GrammaticalPerson.du: 'erklärst',
      GrammaticalPerson.er: 'erklärt',   GrammaticalPerson.wir: 'erklären',
      GrammaticalPerson.ihr: 'erklärt',  GrammaticalPerson.sie: 'erklären',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'erklärte',   GrammaticalPerson.du: 'erklärtest',
      GrammaticalPerson.er: 'erklärte',    GrammaticalPerson.wir: 'erklärten',
      GrammaticalPerson.ihr: 'erklärtet',  GrammaticalPerson.sie: 'erklärten',
    },
    partizip2: 'erklärt',
  ),
  VerbEntry(
    infinitive: 'empfehlen', english: 'to recommend', auxiliary: Auxiliary.haben, level: CefrLevel.b1,
    praesens: {
      GrammaticalPerson.ich: 'empfehle',  GrammaticalPerson.du: 'empfiehlst',
      GrammaticalPerson.er: 'empfiehlt',  GrammaticalPerson.wir: 'empfehlen',
      GrammaticalPerson.ihr: 'empfehlt',  GrammaticalPerson.sie: 'empfehlen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'empfahl',    GrammaticalPerson.du: 'empfahlst',
      GrammaticalPerson.er: 'empfahl',     GrammaticalPerson.wir: 'empfahlen',
      GrammaticalPerson.ihr: 'empfahlt',   GrammaticalPerson.sie: 'empfahlen',
    },
    partizip2: 'empfohlen',
  ),
  VerbEntry(
    infinitive: 'versprechen', english: 'to promise', auxiliary: Auxiliary.haben, level: CefrLevel.b1,
    praesens: {
      GrammaticalPerson.ich: 'verspreche',  GrammaticalPerson.du: 'versprichst',
      GrammaticalPerson.er: 'verspricht',   GrammaticalPerson.wir: 'versprechen',
      GrammaticalPerson.ihr: 'versprecht',  GrammaticalPerson.sie: 'versprechen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'versprach',    GrammaticalPerson.du: 'versprachst',
      GrammaticalPerson.er: 'versprach',     GrammaticalPerson.wir: 'versprachen',
      GrammaticalPerson.ihr: 'verspracht',   GrammaticalPerson.sie: 'versprachen',
    },
    partizip2: 'versprochen',
  ),
  VerbEntry(
    infinitive: 'verlieren', english: 'to lose', auxiliary: Auxiliary.haben, level: CefrLevel.b1,
    praesens: {
      GrammaticalPerson.ich: 'verliere',  GrammaticalPerson.du: 'verlierst',
      GrammaticalPerson.er: 'verliert',   GrammaticalPerson.wir: 'verlieren',
      GrammaticalPerson.ihr: 'verliert',  GrammaticalPerson.sie: 'verlieren',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'verlor',    GrammaticalPerson.du: 'verlorst',
      GrammaticalPerson.er: 'verlor',     GrammaticalPerson.wir: 'verloren',
      GrammaticalPerson.ihr: 'verlort',   GrammaticalPerson.sie: 'verloren',
    },
    partizip2: 'verloren',
  ),
  VerbEntry(
    infinitive: 'gewinnen', english: 'to win', auxiliary: Auxiliary.haben, level: CefrLevel.b1,
    praesens: {
      GrammaticalPerson.ich: 'gewinne',  GrammaticalPerson.du: 'gewinnst',
      GrammaticalPerson.er: 'gewinnt',   GrammaticalPerson.wir: 'gewinnen',
      GrammaticalPerson.ihr: 'gewinnt',  GrammaticalPerson.sie: 'gewinnen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'gewann',    GrammaticalPerson.du: 'gewannst',
      GrammaticalPerson.er: 'gewann',     GrammaticalPerson.wir: 'gewannen',
      GrammaticalPerson.ihr: 'gewannt',   GrammaticalPerson.sie: 'gewannen',
    },
    partizip2: 'gewonnen',
  ),
  VerbEntry(
    infinitive: 'erscheinen', english: 'to appear / be published', auxiliary: Auxiliary.sein, level: CefrLevel.b1,
    praesens: {
      GrammaticalPerson.ich: 'erscheine',  GrammaticalPerson.du: 'erscheinst',
      GrammaticalPerson.er: 'erscheint',   GrammaticalPerson.wir: 'erscheinen',
      GrammaticalPerson.ihr: 'erscheint',  GrammaticalPerson.sie: 'erscheinen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'erschien',    GrammaticalPerson.du: 'erschienst',
      GrammaticalPerson.er: 'erschien',     GrammaticalPerson.wir: 'erschienen',
      GrammaticalPerson.ihr: 'erschient',   GrammaticalPerson.sie: 'erschienen',
    },
    partizip2: 'erschienen',
  ),
  VerbEntry(
    infinitive: 'benutzen', english: 'to use', auxiliary: Auxiliary.haben, level: CefrLevel.b1,
    praesens: {
      GrammaticalPerson.ich: 'benutze',  GrammaticalPerson.du: 'benutzt',
      GrammaticalPerson.er: 'benutzt',   GrammaticalPerson.wir: 'benutzen',
      GrammaticalPerson.ihr: 'benutzt',  GrammaticalPerson.sie: 'benutzen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'benutzte',   GrammaticalPerson.du: 'benutztest',
      GrammaticalPerson.er: 'benutzte',    GrammaticalPerson.wir: 'benutzten',
      GrammaticalPerson.ihr: 'benutztet',  GrammaticalPerson.sie: 'benutzten',
    },
    partizip2: 'benutzt',
  ),
  VerbEntry(
    infinitive: 'vergleichen', english: 'to compare', auxiliary: Auxiliary.haben, level: CefrLevel.b1,
    praesens: {
      GrammaticalPerson.ich: 'vergleiche',  GrammaticalPerson.du: 'vergleichst',
      GrammaticalPerson.er: 'vergleicht',   GrammaticalPerson.wir: 'vergleichen',
      GrammaticalPerson.ihr: 'vergleicht',  GrammaticalPerson.sie: 'vergleichen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'verglich',    GrammaticalPerson.du: 'verglichst',
      GrammaticalPerson.er: 'verglich',     GrammaticalPerson.wir: 'verglichen',
      GrammaticalPerson.ihr: 'verglichet',  GrammaticalPerson.sie: 'verglichen',
    },
    partizip2: 'verglichen',
  ),
  VerbEntry(
    infinitive: 'erinnern', english: 'to remember / remind', auxiliary: Auxiliary.haben, level: CefrLevel.b1,
    praesens: {
      GrammaticalPerson.ich: 'erinnere',  GrammaticalPerson.du: 'erinnerst',
      GrammaticalPerson.er: 'erinnert',   GrammaticalPerson.wir: 'erinnern',
      GrammaticalPerson.ihr: 'erinnert',  GrammaticalPerson.sie: 'erinnern',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'erinnerte',   GrammaticalPerson.du: 'erinnertest',
      GrammaticalPerson.er: 'erinnerte',    GrammaticalPerson.wir: 'erinnerten',
      GrammaticalPerson.ihr: 'erinnertet',  GrammaticalPerson.sie: 'erinnerten',
    },
    partizip2: 'erinnert',
  ),
  VerbEntry(
    infinitive: 'vermissen', english: 'to miss (someone)', auxiliary: Auxiliary.haben, level: CefrLevel.b1,
    praesens: {
      GrammaticalPerson.ich: 'vermisse',  GrammaticalPerson.du: 'vermisst',
      GrammaticalPerson.er: 'vermisst',   GrammaticalPerson.wir: 'vermissen',
      GrammaticalPerson.ihr: 'vermisst',  GrammaticalPerson.sie: 'vermissen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'vermisste',   GrammaticalPerson.du: 'vermisstest',
      GrammaticalPerson.er: 'vermisste',    GrammaticalPerson.wir: 'vermissten',
      GrammaticalPerson.ihr: 'vermisstet',  GrammaticalPerson.sie: 'vermissten',
    },
    partizip2: 'vermisst',
  ),
  VerbEntry(
    infinitive: 'verbessern', english: 'to improve', auxiliary: Auxiliary.haben, level: CefrLevel.b1,
    praesens: {
      GrammaticalPerson.ich: 'verbessere',  GrammaticalPerson.du: 'verbesserst',
      GrammaticalPerson.er: 'verbessert',   GrammaticalPerson.wir: 'verbessern',
      GrammaticalPerson.ihr: 'verbessert',  GrammaticalPerson.sie: 'verbessern',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'verbesserte',   GrammaticalPerson.du: 'verbessertest',
      GrammaticalPerson.er: 'verbesserte',    GrammaticalPerson.wir: 'verbesserten',
      GrammaticalPerson.ihr: 'verbessertet',  GrammaticalPerson.sie: 'verbesserten',
    },
    partizip2: 'verbessert',
  ),
  VerbEntry(
    infinitive: 'beweisen', english: 'to prove', auxiliary: Auxiliary.haben, level: CefrLevel.b1,
    praesens: {
      GrammaticalPerson.ich: 'beweise',  GrammaticalPerson.du: 'beweist',
      GrammaticalPerson.er: 'beweist',   GrammaticalPerson.wir: 'beweisen',
      GrammaticalPerson.ihr: 'beweist',  GrammaticalPerson.sie: 'beweisen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'bewies',    GrammaticalPerson.du: 'bewiest',
      GrammaticalPerson.er: 'bewies',     GrammaticalPerson.wir: 'bewiesen',
      GrammaticalPerson.ihr: 'bewiest',   GrammaticalPerson.sie: 'bewiesen',
    },
    partizip2: 'bewiesen',
  ),
];
