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

  // ── B1 ──────────────────────────────────────────────────────────────────────
  VerbEntry(
    infinitive: 'schreiben', english: 'to write', auxiliary: Auxiliary.haben, level: CefrLevel.b1,
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
    infinitive: 'essen', english: 'to eat', auxiliary: Auxiliary.haben, level: CefrLevel.b1,
    praesens: {
      GrammaticalPerson.ich: 'esse',  GrammaticalPerson.du: 'isst',
      GrammaticalPerson.er: 'isst',   GrammaticalPerson.wir: 'essen',
      GrammaticalPerson.ihr: 'esst',  GrammaticalPerson.sie: 'essen',
    },
    praeteritum: {
      GrammaticalPerson.ich: 'aß',   GrammaticalPerson.du: 'aßt',
      GrammaticalPerson.er: 'aß',    GrammaticalPerson.wir: 'aßen',
      GrammaticalPerson.ihr: 'aßt',  GrammaticalPerson.sie: 'aßen',
    },
    partizip2: 'gegessen',
  ),
  VerbEntry(
    infinitive: 'trinken', english: 'to drink', auxiliary: Auxiliary.haben, level: CefrLevel.b1,
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
];
