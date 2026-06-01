# LanguageTrainer — Requirements Specification

## 1. Purpose

Personal, ad-free Flutter app for drilling German vocabulary. Two exercise
types: noun gender (der/die/das) and verb conjugation across three tenses.
Repetitions are scheduled with the SM-2 spaced-repetition algorithm; all
state is stored locally with no network dependency.

---

## 2. CEFR Level Selection

Users select one or more CEFR levels (A1 – C2) from the Home screen. Only
words tagged at a selected level appear in drills. The selection is persisted
in the local database (`AppPreferences` table, key `selected_levels`) and
defaults to all levels on first launch. At least one level must remain
selected (the UI prevents deselecting all).

Each `NounEntry` and `VerbEntry` carries a `CefrLevel` field. The word list
in v1 covers A1–B1; B2–C2 fields are reserved for future expansion.

---

## 2. Platforms

| Platform       | Min version |
|----------------|-------------|
| Android        | API 21 (Android 5.0) |
| macOS          | 10.14 Mojave |
| Linux (x86-64) | Ubuntu 20.04 equivalent |

---

## 3. Data Model

### 3.1 Noun

```
NounEntry {
  word:    String   // nominative singular, e.g. "Hund"
  article: Article  // der | die | das
  plural:  String   // nominative plural, e.g. "Hunde"
  english: String   // English gloss, e.g. "dog"
}
```

### 3.2 Verb

```
VerbEntry {
  infinitive: String               // e.g. "machen"
  english:    String               // e.g. "to do / make"
  auxiliary:  Auxiliary            // haben | sein  (needed for Perfekt)
  praesens:   Map<Person, String>
  praeteritum: Map<Person, String>
  partizip2:  String               // past participle, e.g. "gemacht"
}
```

`Perfekt` is derived at runtime: auxiliary conjugated in Präsens + Partizip II.

```
Person enum: ich | du | erSieEs | wir | ihr | sieSie
```

### 3.3 Review Card

One card per (item, quiz-type) pair:

```
ReviewCard {
  id:   String   // stable key, format defined in §3.4
  type: CardType // noun | verbPraesens | verbPraeteritum | verbPerfekt
  sm2:  Sm2State
}

Sm2State {
  easeFactor:  double  // ≥ 1.3, default 2.5
  interval:    int     // days until next review, 0 = same day
  repetitions: int     // consecutive correct answers
  nextReview:  DateTime
}
```

### 3.4 Card ID Scheme

```
noun:<Word>                        // e.g. "noun:Hund"
verb:<infinitive>:<person>:<tense> // e.g. "verb:machen:ich:praesens"
```

Tense token values: `praesens` | `praeteritum` | `perfekt`

Person token values: `ich` | `du` | `er` | `wir` | `ihr` | `sie`

---

## 4. Initial Word List

Curated, hardcoded in Dart source (`lib/data/`). Sizes are minimums; can be
expanded without schema changes.

| Category        | Count |
|-----------------|-------|
| Nouns           | ≥ 60  |
| Verbs           | ≥ 25  |

Coverage target for verbs: the 25 highest-frequency German verbs including all
strong/irregular verbs. Each verb generates 6 × 3 = 18 review cards
(6 persons × 3 tenses), plus nouns generate 1 card each → initial deck ≈
60 + 450 = ~510 cards.

---

## 5. Spaced Repetition — SM-2

Standard SM-2 as published by Wozniak (1990). Grading is binary for this app:

| Result   | Grade passed to SM-2 |
|----------|----------------------|
| Correct  | 5                    |
| Incorrect| 0                    |

Algorithm:

```
applyGrade(state, grade):
  if grade < 3:
    repetitions = 0
    interval    = 1
    EF unchanged
  else:
    EF' = EF + (0.1 − (5−grade)·(0.08 + (5−grade)·0.02))
    EF' = max(1.3, EF')
    if repetitions == 0: interval = 1
    elif repetitions == 1: interval = 6
    else: interval = round(interval × EF')
    repetitions += 1

nextReview = now() + interval days
```

New cards (no persisted state) are treated as due immediately.

Session behaviour: present all due cards in a single session. No hard daily
new-card cap in v1 — this is a personal tool and the user controls pace by
launching the app.

---

## 6. Quiz Modes

### 6.1 Noun Article Quiz

- **Prompt**: German word + English gloss displayed.
- **Answer**: Three tappable buttons — `der`, `die`, `das`.
- **Feedback**: Immediate — button turns green (correct) or red (wrong) with
  correct answer highlighted if wrong.
- **Grade**: correct → 5, wrong → 0.

### 6.2 Verb Conjugation Quiz (Präsens / Präteritum)

- **Prompt**: `___ [infinitive]` with person label, e.g. `ich ___ (gehen)`.
  English gloss shown below.
- **Answer**: Free-text input field. Auto-focus on card load.
- **Normalisation**: Compare lowercased, trimmed strings. Accept ß ↔ ss as
  equivalent for answers only (display always uses ß).
- **Feedback**: Show correct conjugation. Colour the input field green/red.
- **Grade**: exact match (after normalisation) → 5, otherwise → 0. User can
  override to "mark correct" before advancing (handles umlauts on some
  keyboards).

### 6.3 Verb Conjugation Quiz (Perfekt)

Same as §6.2 but prompt shows the full expected structure hint:
`ich ___ gegangen` where blank is the auxiliary. Alternatively the prompt
can ask for the full Perfekt string — TBD during implementation; the spec
allows either as long as it tests both auxiliary and participle together.

Simpler option chosen for v1: prompt is `ich ___ (gehen) — Perfekt`, expected
answer is the full string `bin gegangen`.

---

## 7. Persistence

- **Engine**: SQLite via `sqflite` package.
- **Schema**: single table `review_cards` (see §3.3). No migration needed in v1.
- **On first launch**: table is empty; cards are considered new (always due).
- **Write strategy**: write card state immediately after each answer — no
  buffering, so a crash mid-session loses only the current card.

```sql
CREATE TABLE review_cards (
  id          TEXT    PRIMARY KEY,
  type        INTEGER NOT NULL,   -- CardType index
  easeFactor  REAL    NOT NULL,
  interval    INTEGER NOT NULL,
  repetitions INTEGER NOT NULL,
  nextReview  INTEGER NOT NULL    -- milliseconds since epoch
);
```

---

## 8. Screens & Navigation

```
HomeScreen
  ├── StatsScreen      (push)
  └── QuizScreen       (push, receives list of due ReviewCards)
```

### 8.1 HomeScreen

- Due card count: total, broken down by type (nouns / verbs).
- "Start Review" button — disabled when 0 due.
- "Stats" button.
- No settings screen in v1.

### 8.2 QuizScreen

- Linear progression through due cards (no branching).
- Progress bar: completed / total.
- Wrong answers are re-queued at the end of the current session (shown once
  more) but the SM-2 state is written immediately on first answer.
- "Quit" (back) button — confirms exit if cards remain.

### 8.3 StatsScreen

- Total cards in deck.
- Cards due today / this week.
- Per-type breakdown table (nouns, Präsens, Präteritum, Perfekt).
- No streak tracking in v1.

---

## 9. Architecture

```
lib/
  main.dart
  models/
    noun.dart
    verb.dart
    review_card.dart       // ReviewCard, Sm2State, CardType, enums
  data/
    nouns.dart             // const kNouns = <NounEntry>[...]
    verbs.dart             // const kVerbs = <VerbEntry>[...]
  services/
    sm2.dart               // pure function: Sm2State applyGrade(state, grade)
    database.dart          // async CRUD over sqflite
    review_scheduler.dart  // getDueCards(), verbPromptFromId(), etc.
  screens/
    home_screen.dart
    quiz_screen.dart
    stats_screen.dart
  widgets/
    article_buttons.dart   // der/die/das row
    conjugation_field.dart // text field + override button
    feedback_overlay.dart  // correct/wrong banner
```

No state-management package in v1 — `setState` + `FutureBuilder` is
sufficient. Revisit if a second developer joins or the feature set grows.

---

## 10. Out of Scope (v1)

- Wiktionary / network data import
- User-defined word lists
- Audio pronunciation
- Dark/light theme toggle (system theme followed automatically)
- Accounts, sync, or backup
- Streak / gamification
- Preterite/subjunctive moods beyond the three tenses above
- Push notifications for daily reminders
