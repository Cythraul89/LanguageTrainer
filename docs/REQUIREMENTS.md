# LanguageTrainer — Requirements Specification

## 1. Purpose

Personal, ad-free Flutter app for drilling German vocabulary using spaced
repetition. Supports noun gender, noun plural, noun/verb/adjective translation,
EN→DE reverse, verb conjugation (three tenses), auxiliary selection,
Partizip II, and adjective comparative/superlative quizzes. All state is
stored locally with no network dependency.

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
  plural:  String    // nominative plural or '-' (uncountable)
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

### 3.3 Adjective

```
AdjectiveEntry {
  word:        String    // base form, e.g. "groß"
  english:     String    // English gloss, e.g. "big / tall"
  comparative: String    // e.g. "größer"
  superlative: String    // e.g. "am größten"
  level:       CefrLevel
}
```

Only gradable adjectives are included — ungradable adjectives (möglich,
genug, etc.) are excluded from the dataset.

### 3.4 Review Card

One card per (item, quiz-type) pair:

```
QuizItem (sealed)
  NounQuizItem            { cardId, cardType=noun, sm2, entry: NounEntry }
  NounPluralQuizItem      { cardId, cardType=nounPlural, sm2, entry: NounEntry }
  NounTranslationQuizItem { cardId, cardType=nounTranslation, sm2, entry: NounEntry }
  NounReverseQuizItem     { cardId, cardType=nounReverse, sm2, entry: NounEntry }
  VerbQuizItem            { cardId, cardType, sm2, infinitive, person, tense,
                            correctAnswer, english }
  VerbTranslationQuizItem { cardId, cardType=verbTranslation, sm2, infinitive, english }
  VerbPartizipIIQuizItem  { cardId, cardType=verbPartizipII, sm2, infinitive,
                            english, partizip2 }
  VerbAuxiliaryQuizItem   { cardId, cardType=verbAuxiliary, sm2, infinitive,
                            english, auxiliary }
  VerbReverseQuizItem     { cardId, cardType=verbReverse, sm2, infinitive, english }
  AdjTranslationQuizItem  { cardId, cardType=adjTranslation, sm2, entry: AdjectiveEntry }
  AdjComparativeQuizItem  { cardId, cardType=adjComparative, sm2, entry: AdjectiveEntry }
  AdjSuperlativeQuizItem  { cardId, cardType=adjSuperlative, sm2, entry: AdjectiveEntry }

Sm2State {
  easeFactor:  double    // ≥ 1.3, default 2.5
  intervalDays: int      // days until next review, 0 = same day
  repetitions:  int      // consecutive correct answers
  nextReview:   DateTime
}

CardType enum:
  noun | nounPlural | nounTranslation | nounReverse |
  verbPraesens | verbPraeteritum | verbPerfekt |
  verbPartizipII | verbAuxiliary | verbTranslation | verbReverse |
  adjTranslation | adjComparative | adjSuperlative
```

### 3.5 Card ID Scheme

```
noun:<Word>                         // e.g. "noun:Hund"
noun_plural:<Word>                  // e.g. "noun_plural:Hund"
noun_translation:<Word>             // e.g. "noun_translation:Hund"
noun_reverse:<Word>                 // e.g. "noun_reverse:Hund"
verb:<infinitive>:<person>:<tense>  // e.g. "verb:machen:ich:praesens"
verb_translation:<infinitive>       // e.g. "verb_translation:machen"
verb_partizip2:<infinitive>         // e.g. "verb_partizip2:machen"
verb_auxiliary:<infinitive>         // e.g. "verb_auxiliary:machen"
verb_reverse:<infinitive>           // e.g. "verb_reverse:machen"
adj_translation:<word>              // e.g. "adj_translation:groß"
adj_comparative:<word>              // e.g. "adj_comparative:groß"
adj_superlative:<word>              // e.g. "adj_superlative:groß"
```

Card IDs are stable — renaming a word/infinitive would orphan its SM-2 state.

---

## 4. Vocabulary

Curated, hardcoded in Dart source (`lib/data/`). Can be expanded without
schema changes; existing cards keep their SM-2 state when new words are added.

| Category   | Count | Deck cards generated                                   |
|------------|------:|-------------------------------------------------------:|
| Nouns      | ~215  | up to ~860 (noun + plural + translation + reverse)     |
| Verbs      | ~95   | up to ~1 900 (6 persons × 3 tenses + 4 extra types)   |
| Adjectives | ~54   | up to ~162 (translation + comparative + superlative)   |
| **Total**  |       | **up to ~2 922** (depending on active CardTypes)       |

Thematic groups: everyday objects, family, food, travel, birthday,
relationships, abstract B1 concepts.

CEFR coverage:

| Level | Nouns | Verbs | Adjectives |
|-------|------:|------:|-----------:|
| A1    | ~60   | ~30   | ~20        |
| A2    | ~71   | ~45   | ~15        |
| B1    | ~61   | ~20   | ~10        |
| B2    | —     | —     | ~9         |
| C1–C2 | reserved for future expansion              |

---

## 5. CEFR Level Filter

Users select one or more CEFR levels (A1–C2) from the Home screen. Only
words tagged at a selected level appear in drills. The selection is persisted
in `AppPreferences` (key `selected_levels`) and defaults to all levels on
first launch. At least one level must remain selected.

---

## 6. CardType (Category) Filter

Users select one or more card categories from the Home screen:

| German label    | CardType           | Default |
|-----------------|--------------------|---------|
| Artikel         | `noun`             | ✓       |
| Plural          | `nounPlural`       | ✓       |
| Übersetzung     | `nounTranslation`  | ✓       |
| DE schreiben    | `nounReverse`      | ✓       |
| Präsens         | `verbPraesens`     | ✓       |
| Präteritum      | `verbPraeteritum`  | ✓       |
| Perfekt         | `verbPerfekt`      | ✓       |
| Partizip II     | `verbPartizipII`   | ✓       |
| Hilfsverb       | `verbAuxiliary`    | ✓       |
| Bedeutung       | `verbTranslation`  | ✓       |
| Verb schreiben  | `verbReverse`      | ✓       |
| Adj. Bedeutung  | `adjTranslation`   | ✓       |
| Komparativ      | `adjComparative`   | ✗       |
| Superlativ      | `adjSuperlative`   | ✗       |

Selection is persisted in `AppPreferences` (key `selected_card_types`).
At least one must remain selected.

The filter is applied in both `_queryItems()` (quiz) and `getStats()`
(stats screen) so the due-count summary always reflects the active filter.

---

## 7. Session Size

Users set the maximum number of cards per quiz session in Settings.

- Default: 10
- Range: 5 – 50 (slider, steps of 5)
- Persisted in `AppPreferences` (key `session_size`)

Cards are shuffled then truncated to the session size limit.

---

## 8. Spaced Repetition — SM-2

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
Due cards are presented in randomised order, then truncated to session size.

Wrong answers are re-queued at the end of the current session. SM-2 state
is written immediately on the first answer.

Override: if the user marks a wrong answer as correct (typo / keyboard
layout issue), the card is re-graded 5 and removed from the re-queue.

---

## 9. Quiz Modes

### 9.1 Noun Article Quiz (`noun`)
- **Prompt**: German word + English gloss + plural shown as hint.
- **Answer**: Three tappable buttons — `der`, `die`, `das`.

### 9.2 Noun Plural Quiz (`nounPlural`)
- **Prompt**: `der/die/das <Word>` + English gloss.
- **Answer**: Free-text input. Normalised (case-insensitive, `ss` ↔ `ß`).
- Only generated for nouns where `plural ≠ '-'`.

### 9.3 Noun Translation Quiz (`nounTranslation`)
- **Prompt**: `der/die/das <Word>`.
- **Answer**: Free-text English translation. Slash-separated variants accepted.

### 9.4 Noun Reverse Quiz (`nounReverse`)
- **Prompt**: English word.
- **Answer**: Free-text German noun with article, e.g. `der Hund`.

### 9.5 Verb Conjugation Quiz (`verbPraesens` / `verbPraeteritum` / `verbPerfekt`)
- **Prompt**: `<person> ___ (<infinitive>)` + tense label + English gloss.
- **Answer**: Free-text conjugated form. Normalised.
- Perfekt answer is the full string, e.g. `bin gegangen`.

### 9.6 Verb Partizip II Quiz (`verbPartizipII`)
- **Prompt**: Infinitive + English gloss.
- **Answer**: Free-text Partizip II form.

### 9.7 Auxiliary Quiz (`verbAuxiliary`)
- **Prompt**: Infinitive + English gloss.
- **Answer**: Two tappable buttons — `haben`, `sein`.

### 9.8 Verb Translation Quiz (`verbTranslation`)
- **Prompt**: German infinitive.
- **Answer**: Free-text English translation. Slash-separated variants accepted;
  leading `to ` stripped before comparison.

### 9.9 Verb Reverse Quiz (`verbReverse`)
- **Prompt**: English infinitive gloss.
- **Answer**: Free-text German infinitive.

### 9.10 Adjective Translation Quiz (`adjTranslation`)
- **Prompt**: German adjective.
- **Answer**: Free-text English translation. Slash-separated variants accepted.

### 9.11 Adjective Comparative Quiz (`adjComparative`)
- **Prompt**: German adjective + English gloss.
- **Answer**: Free-text comparative form, e.g. `größer`.

### 9.12 Adjective Superlative Quiz (`adjSuperlative`)
- **Prompt**: German adjective + English gloss.
- **Answer**: Free-text superlative form including `am`, e.g. `am größten`.

---

## 10. Difficult Words Session

Cards with `easeFactor < 2.0` and at least one repetition are flagged as
"difficult". The Home screen shows a count and an "Difficult words (N)"
button that launches a quiz restricted to those cards, ignoring the SM-2
due date.

---

## 11. Vocabulary Browser

A searchable read-only reference screen accessible from the Home screen.
Three tabs: Nouns, Verbs, Adjectives.

- **Nouns tab**: article chip (colour-coded der=blue/die=red/das=green),
  word, English gloss, plural.
- **Verbs tab**: infinitive, English gloss, auxiliary chip, expandable
  conjugation table (Präsens / Präteritum / Perfekt for all 6 persons
  plus Partizip II row).
- **Adjectives tab**: base form, English gloss, comparative, superlative.
- Live search filters all three tabs simultaneously.

---

## 12. Gamification

### 12.1 XP and Levels

| Event                           | XP     |
|---------------------------------|--------|
| Correct answer                  | +10    |
| Correct on first attempt (bonus)| +5     |
| Override (typo correction)      | +10 (first-attempt bonus preserved) |

Level formula: `level = floor((1 + sqrt(1 + 8·totalXp / 100)) / 2)`

### 12.2 Achievements

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

Achievement checks run atomically inside the DB transaction that updates
stats to prevent double-unlock.

### 12.3 Confetti

When a quiz session results in a level-up, a confetti burst plays on the
Session Complete screen.

---

## 13. Persistence

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

## 14. Screens & Navigation

### 14.1 Shell (Adaptive)

Four persistent tab destinations:

| Width       | Shell layout            |
|-------------|-------------------------|
| < 600 px    | `BottomNavigationBar`   |
| ≥ 600 px    | `NavigationRail`        |

| Tab | Destination  |
|-----|--------------|
| 0   | Home         |
| 1   | Stats        |
| 2   | Achievements |
| 3   | Settings     |

`QuizScreen`, `VocabBrowserScreen`, and `AboutScreen` are pushed on top of
the shell — not tab destinations.

### 14.2 HomeScreen

- CEFR level `FilterChip` row.
- CardType `FilterChip` row (14 types).
- Due-count card: per-type rows with total; unselected rows dimmed.
- "Start Review (N)" `FilledButton` — disabled when N = 0.
- "Difficult words (N)" `OutlinedButton` — disabled when no difficult cards.
- "Browse vocabulary" `OutlinedButton` — always enabled.
- Birthday greeting: on June 3rd shows an `AlertDialog`.

### 14.3 QuizScreen

- Linear progression through shuffled due/difficult cards.
- `LinearProgressIndicator` below AppBar.
- Wrong answers re-queued at end; SM-2 written immediately.
- Override button on free-text cards (marks wrong answer as correct).
- Session summary on completion: XP earned, level progress, unlocked
  achievements, confetti if level-up.
- Back button shows quit-confirmation `AlertDialog`.

### 14.4 StatsScreen

- Total deck size and total due.
- Per-type breakdown.

### 14.5 AchievementsScreen

- Grid of achievement badges (emoji + title + description).
- Locked achievements shown greyed-out.

### 14.6 SettingsScreen

- CEFR level `FilterChip` row.
- Session size slider (5–50, default 10).
- Link to AboutScreen.

### 14.7 AboutScreen

- App icon, name, and version (from `package_info_plus`).
- Legal section: licence link, source code link.
- Data section: "Export review log" via `share_plus`.
- Easter egg: 7-tap on version row shows a message.

### 14.8 VocabBrowserScreen

- Tabs: Nouns / Verbs / Adjectives.
- Shared live search bar at top.

---

## 15. CI / CD

| Trigger           | Jobs                                                       |
|-------------------|------------------------------------------------------------|
| Push to branch    | `flutter analyze --fatal-infos`, `flutter test`, debug builds (Android APK, Linux .deb, macOS .zip), SBOM |
| Push tag `v*.*.*` | Release builds, GitHub Release created with all artifacts  |

Version stamp:

| Workflow      | Format                         | Example        |
|---------------|--------------------------------|----------------|
| `ci.yml`      | `{base}-dev+{run_number}`      | `0.1.0-dev+42` |
| `release.yml` | `{tag_version}+{run_number}`   | `1.0.0+7`      |

### Android release signing

Four repository secrets: `ANDROID_RELEASE_KEYSTORE_B64`,
`ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`.

---

## 16. Out of Scope (v1)

- Wiktionary / network data import
- User-defined word lists
- Audio pronunciation
- Light / dark theme toggle (follows system automatically)
- Accounts, sync, or cloud backup
- Push notifications for daily reminders
- Case/gender inflection drills (adjective endings)
- Sentence / grammar exercises
