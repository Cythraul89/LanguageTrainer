# LanguageTrainer — Requirements Specification

## 1. Purpose

Personal, ad-free Flutter app for drilling German vocabulary. Two exercise
types: noun gender (der/die/das) and verb conjugation across three tenses.
Repetitions are scheduled with the SM-2 spaced-repetition algorithm; all
state is stored locally with no network dependency.

---

## 2. Platforms

| Platform       | Min version          |
|----------------|----------------------|
| Android        | API 21 (Android 5.0) |
| macOS          | 10.14 Mojave         |
| Linux (x86-64) | Ubuntu 20.04         |

---

## 3. Data Model

### 3.1 Noun

```
NounEntry {
  word:    String    // nominative singular, e.g. "Hund"
  article: Article   // der | die | das
  plural:  String    // nominative plural, e.g. "Hunde"
  english: String    // English gloss, e.g. "dog"
  level:   CefrLevel // a1 | a2 | b1 | b2 | c1 | c2
}
```

### 3.2 Verb

```
VerbEntry {
  infinitive:   String               // e.g. "machen"
  english:      String               // e.g. "to do / make"
  auxiliary:    Auxiliary            // haben | sein (needed for Perfekt)
  level:        CefrLevel
  praesens:     Map<GrammaticalPerson, String>
  praeteritum:  Map<GrammaticalPerson, String>
  partizip2:    String               // past participle, e.g. "gemacht"
}
```

Perfekt is derived at runtime: auxiliary conjugated in Präsens + Partizip II.

```
GrammaticalPerson enum: ich | du | er | wir | ihr | sie
```

### 3.3 Review Card

One card per (item, quiz-type) pair:

```
QuizItem (sealed)
  NounQuizItem { cardId, cardType, sm2, entry: NounEntry }
  VerbQuizItem { cardId, cardType, sm2, infinitive, person, tense,
                 correctAnswer, english }

Sm2State {
  easeFactor:  double    // ≥ 1.3, default 2.5
  intervalDays: int      // days until next review, 0 = same day
  repetitions:  int      // consecutive correct answers
  nextReview:   DateTime
}

CardType enum: noun | verbPraesens | verbPraeteritum | verbPerfekt
```

### 3.4 Card ID Scheme

```
noun:<Word>                         // e.g. "noun:Hund"
verb:<infinitive>:<person>:<tense>  // e.g. "verb:machen:ich:praesens"
```

Card IDs are stable — renaming a word/infinitive would orphan its SM-2 state.

Tense token values: `praesens` | `praeteritum` | `perfekt`
Person token values: `ich` | `du` | `er` | `wir` | `ihr` | `sie`

---

## 4. Vocabulary

Curated, hardcoded in Dart source (`lib/data/`). Can be expanded without
schema changes; existing cards keep their SM-2 state when new words are added.

| Category | Count  | Deck cards generated |
|----------|-------:|---------------------:|
| Nouns    | ~215   | ~215 (1 per noun)    |
| Verbs    | ~95    | ~1 710 (6 persons × 3 tenses × ~95) |
| **Total**|        | **~1 925**           |

Thematic groups: everyday objects, family, food, travel, birthday, relationships.
Full word list: [`VOCABULARY.md`](VOCABULARY.md)

CEFR coverage:

| Level | Nouns | Verbs |
|-------|------:|------:|
| A1    | ~60   | ~30   |
| A2    | ~71   | ~45   |
| B1    | ~61   | ~20   |
| B2–C2 | reserved for future expansion |

---

## 5. CEFR Level Filter

Users select one or more CEFR levels (A1 – C2) from the Home screen. Only
words tagged at a selected level appear in drills. The selection is persisted
in `AppPreferences` (key `selected_levels`) and defaults to all levels on first
launch. At least one level must remain selected (the UI prevents deselecting all).

---

## 6. CardType (Category) Filter

Users select one or more card categories from the Home screen:

| Category    | CardType          |
|-------------|-------------------|
| Nouns       | `noun`            |
| Präsens     | `verbPraesens`    |
| Präteritum  | `verbPraeteritum` |
| Perfekt     | `verbPerfekt`     |

Selection is persisted in `AppPreferences` (key `selected_card_types`) and
defaults to all four types. At least one must remain selected.

The filter is applied in both `getDueItems()` (quiz) and `getStats()` (stats
screen) so the due-count summary always reflects the active filter.

---

## 7. Spaced Repetition — SM-2

Standard SM-2 as published by Wozniak (1990). Grading is binary:

| Result    | Grade |
|-----------|-------|
| Correct   | 5     |
| Incorrect | 0     |

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
Due cards are presented in randomised order each session.

Wrong answers: re-queued at the end of the current session. SM-2 state is
written immediately on the first answer so a crash loses at most one card.

Override: if the user marks a wrong answer as correct (e.g. keyboard layout
issue), the card is re-graded 5 and removed from the re-queue.

---

## 8. Gamification

### 8.1 XP and Levels

| Event                           | XP     |
|---------------------------------|--------|
| Correct answer                  | +10    |
| Correct on first attempt (bonus)| +5     |
| Override (typo correction)      | +10 (first-attempt bonus preserved) |

Level formula: `level = floor((1 + sqrt(1 + 8·totalXp / 100)) / 2)`

### 8.2 Achievements

Achievements are unlocked once and displayed on the Achievements screen.
Achievement checks run atomically inside the DB transaction that updates stats
to prevent double-unlock.

| Achievement             | Condition                      |
|-------------------------|--------------------------------|
| First correct answer    | totalCorrect ≥ 1               |
| 50 correct answers      | totalCorrect ≥ 50              |
| 100 correct answers     | totalCorrect ≥ 100             |
| 500 correct answers     | totalCorrect ≥ 500             |
| 100 first-try correct   | totalFirstCorrect ≥ 100        |
| Reach level 5           | level ≥ 5                      |
| Reach level 10          | level ≥ 10                     |
| Reach level 20          | level ≥ 20                     |
| 10 in a row             | consecutiveCorrect ≥ 10        |
| Complete first session  | sessionsCompleted ≥ 1          |

---

## 9. Quiz Modes

### 9.1 Noun Article Quiz

- **Prompt**: German word + English gloss.
- **Answer**: Three tappable buttons — `der`, `die`, `das`.
- **Feedback**: Immediate colour feedback; correct answer shown if wrong.
- **Grade**: correct → 5, wrong → 0.

### 9.2 Verb Conjugation Quiz (Präsens / Präteritum)

- **Prompt**: `___ (infinitive)` with person label and English gloss.
- **Answer**: Free-text input field; auto-focused on card load.
- **Normalisation**: Case-insensitive, trimmed. Accept `ss` ↔ `ß`.
- **Feedback**: Show correct conjugation.
- **Grade**: exact match (after normalisation) → 5, otherwise → 0.
- **Override**: User can mark as correct before advancing (typo / keyboard).

### 9.3 Verb Conjugation Quiz (Perfekt)

Same as §9.2. Expected answer is the full Perfekt string, e.g. `bin gegangen`.

---

## 10. Persistence

- **Engine**: SQLite via the `drift` package (code-generated ORM).
- **Tables**: `review_entries`, `app_preferences`, `user_progress`.
- **On first launch**: tables are empty; all cards are due immediately.
- **Write strategy**: write SM-2 state immediately after each answer.

```
review_entries     (id TEXT PK, cardType INTEGER, easeFactor REAL,
                    intervalDays INTEGER, repetitions INTEGER, nextReviewMs INTEGER)
app_preferences    (key TEXT PK, value TEXT)
user_progress      (id INTEGER PK=1, totalXp INTEGER, totalCorrect INTEGER,
                    totalFirstCorrect INTEGER, sessionsCompleted INTEGER,
                    unlockedAchievements TEXT)
```

Schema version 1 — no migrations in v1.

---

## 11. Screens & Navigation

### 11.1 Shell (Adaptive)

Four persistent tab destinations, shell layout depends on screen width:

| Width       | Shell layout                         |
|-------------|--------------------------------------|
| < 600 px    | `BottomNavigationBar`                |
| ≥ 600 px    | `NavigationRail`                     |

| Tab | Destination  |
|-----|--------------|
| 0   | Home         |
| 1   | Stats        |
| 2   | Achievements |
| 3   | Settings     |

`QuizScreen` and `AboutScreen` are pushed on top of the shell — not tab destinations.

### 11.2 HomeScreen

- CEFR level `FilterChip` row — at least one chip must stay selected.
- CardType `FilterChip` row — at least one must stay selected.
- Due-count card: per-type rows (Nouns / Präsens / Präteritum / Perfekt) with total;
  unselected rows are dimmed.
- "Start Review (N)" `FilledButton` — disabled when N = 0.
- Birthday greeting: on June 3rd the app shows an `AlertDialog`
  "Alles Gute zum Geburtstag Nkule." on first load.

### 11.3 QuizScreen

- Linear progression through due cards (shuffled).
- `LinearProgressIndicator` below AppBar.
- Wrong answers re-queued at end; SM-2 written immediately on first answer.
- Session summary on completion: XP earned, level progress, newly unlocked achievements.
- Back button shows a quit-confirmation `AlertDialog` if cards remain.

### 11.4 StatsScreen

- Total deck size and total due.
- Per-type breakdown (Nouns / Präsens / Präteritum / Perfekt): due / total.

### 11.5 AchievementsScreen

- Grid of achievement badges (emoji + title + description).
- Locked achievements shown as greyed-out.

### 11.6 SettingsScreen

- CEFR level `FilterChip` row (mirrors HomeScreen).
- Link to AboutScreen.
- Theme entry (disabled; follows system setting — toggle planned for future).

### 11.7 AboutScreen

- App icon, name, and version (from `package_info_plus`).
- Short description.
- Legal section: licence link (GPL-3.0), source code link (GitHub).
- Data section: "Export review log" — exports SM-2 progress as JSON via `share_plus`.

---

## 12. CI / CD

| Trigger         | Jobs                                                       |
|-----------------|------------------------------------------------------------|
| Push to branch  | `flutter analyze --fatal-infos`, `flutter test`, debug builds (Android APK, Linux .deb, macOS .zip), SBOM |
| Push tag `v*.*.*` | Release builds, GitHub Release created with all artifacts |

Version is stamped into `pubspec.yaml` before each build:
- Dev builds: `{base}-dev+{run_number}`
- Release builds: `{tag}+{run_number}`

### Android release signing

Four repository secrets enable signed release APKs:
`ANDROID_RELEASE_KEYSTORE_B64`, `ANDROID_KEYSTORE_PASSWORD`,
`ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`.

---

## 13. Out of Scope (v1)

- Wiktionary / network data import
- User-defined word lists
- Audio pronunciation
- Light / dark theme toggle (follows system automatically)
- Accounts, sync, or cloud backup
- Push notifications for daily reminders
- Preterite/subjunctive moods beyond the three tenses
- Sentence / grammar exercises
