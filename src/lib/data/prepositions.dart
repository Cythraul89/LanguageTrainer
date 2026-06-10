import 'package:language_trainer/models/noun.dart';
import 'package:language_trainer/models/preposition.dart';

const kPrepositions = <PrepositionEntry>[
  // ── Akkusativ ────────────────────────────────────────────────────────────────
  PrepositionEntry(word: 'durch', english: 'through', cases: ['Akkusativ'], level: CefrLevel.a1),
  PrepositionEntry(word: 'für', english: 'for', cases: ['Akkusativ'], level: CefrLevel.a1),
  PrepositionEntry(word: 'gegen', english: 'against', cases: ['Akkusativ'], level: CefrLevel.a1),
  PrepositionEntry(word: 'ohne', english: 'without', cases: ['Akkusativ'], level: CefrLevel.a1),
  PrepositionEntry(word: 'um', english: 'around / at (time)', cases: ['Akkusativ'], level: CefrLevel.a1),
  PrepositionEntry(word: 'bis', english: 'until / up to', cases: ['Akkusativ'], level: CefrLevel.a2),
  PrepositionEntry(word: 'entlang', english: 'along', cases: ['Akkusativ'], level: CefrLevel.a2),

  // ── Dativ ────────────────────────────────────────────────────────────────────
  PrepositionEntry(word: 'aus', english: 'out of / from', cases: ['Dativ'], level: CefrLevel.a1),
  PrepositionEntry(word: 'bei', english: 'at / near / with', cases: ['Dativ'], level: CefrLevel.a1),
  PrepositionEntry(word: 'mit', english: 'with', cases: ['Dativ'], level: CefrLevel.a1),
  PrepositionEntry(word: 'nach', english: 'after / to (cities)', cases: ['Dativ'], level: CefrLevel.a1),
  PrepositionEntry(word: 'seit', english: 'since / for (time)', cases: ['Dativ'], level: CefrLevel.a1),
  PrepositionEntry(word: 'von', english: 'from / of / by', cases: ['Dativ'], level: CefrLevel.a1),
  PrepositionEntry(word: 'zu', english: 'to / at', cases: ['Dativ'], level: CefrLevel.a1),
  PrepositionEntry(word: 'außer', english: 'except / besides', cases: ['Dativ'], level: CefrLevel.a2),
  PrepositionEntry(word: 'gegenüber', english: 'opposite / towards', cases: ['Dativ'], level: CefrLevel.a2),

  // ── Wechselpräpositionen (two-way) ───────────────────────────────────────────
  PrepositionEntry(word: 'an', english: 'at / on (vertical)', cases: ['Dativ', 'Akkusativ'], level: CefrLevel.a1),
  PrepositionEntry(word: 'auf', english: 'on (horizontal) / onto', cases: ['Dativ', 'Akkusativ'], level: CefrLevel.a1),
  PrepositionEntry(word: 'in', english: 'in / into', cases: ['Dativ', 'Akkusativ'], level: CefrLevel.a1),
  PrepositionEntry(word: 'hinter', english: 'behind', cases: ['Dativ', 'Akkusativ'], level: CefrLevel.a2),
  PrepositionEntry(word: 'neben', english: 'next to / beside', cases: ['Dativ', 'Akkusativ'], level: CefrLevel.a2),
  PrepositionEntry(word: 'über', english: 'over / above / about', cases: ['Dativ', 'Akkusativ'], level: CefrLevel.a2),
  PrepositionEntry(word: 'unter', english: 'under / below / among', cases: ['Dativ', 'Akkusativ'], level: CefrLevel.a2),
  PrepositionEntry(word: 'vor', english: 'in front of / before / ago', cases: ['Dativ', 'Akkusativ'], level: CefrLevel.a2),
  PrepositionEntry(word: 'zwischen', english: 'between', cases: ['Dativ', 'Akkusativ'], level: CefrLevel.a2),

  // ── Genitiv ──────────────────────────────────────────────────────────────────
  PrepositionEntry(word: 'wegen', english: 'because of / due to', cases: ['Genitiv'], level: CefrLevel.b1),
  PrepositionEntry(word: 'trotz', english: 'despite / in spite of', cases: ['Genitiv'], level: CefrLevel.b1),
  PrepositionEntry(word: 'während', english: 'during / while', cases: ['Genitiv'], level: CefrLevel.b1),
  PrepositionEntry(word: 'statt', english: 'instead of', cases: ['Genitiv'], level: CefrLevel.b1),
];
