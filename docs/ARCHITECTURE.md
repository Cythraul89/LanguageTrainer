# LanguageTrainer — Architecture

## 1. Layer Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│  Presentation                                                        │
│  AdaptiveShell                                                       │
│  HomeScreen · QuizScreen · StatsScreen · AchievementsScreen         │
│  SettingsScreen · AboutScreen · VocabBrowserScreen                   │
│  Widgets: ArticleButtons · AuxiliaryButtons · ConjugationField       │
│           FeedbackOverlay                                            │
├─────────────────────────────────────────────────────────────────────┤
│  Service                                                             │
│  ReviewScheduler ←→ Sm2Service (pure)                               │
│  GamificationService                                                 │
├─────────────────────────────────────────────────────────────────────┤
│  Data                                                                │
│  AppDatabase (Drift/SQLite)    kNouns · kVerbs · kAdjectives (const)│
└─────────────────────────────────────────────────────────────────────┘
```

Dependencies flow strictly downward. No layer imports from a layer above it.
`Sm2Service` is stateless — no database or widget dependency.
`AppServices` is the top-level composition root injected into `AdaptiveShell`.

---

## 2. AppServices Composition Root

```dart
class AppServices {
  final AppDatabase db;
  final ReviewScheduler scheduler;        // owns DB + SM-2
  final GamificationService gamification; // owns DB
}
```

Created once in `LanguageTrainerApp.initState`, disposed on `dispose`.
Passed to shells and screens via constructor injection (no provider/riverpod).

---

## 3. Module Dependency Graph

```
                       ┌──────────────┐
                       │ AdaptiveShell│
                       └──────┬───────┘
        ┌───────────┬──────────┼──────────┬─────────────┐
        ▼           ▼          ▼          ▼             ▼
  HomeScreen  StatsScreen  Achievements  Settings    (push)
        │                               Screen      AboutScreen
        │ push            ┌─────────────┘
        ▼                 │ push
   QuizScreen       VocabBrowserScreen
  /    |    \
ArtBtn AuxBtn ConjField FeedbackOverlay
        │
        ▼
  ReviewScheduler       GamificationService
   /    |     \                |
Sm2Svc  │   AppDatabase ◄─────┘
        │     /       \
   ┌────┴────┐   ┌─────┴──────────┐
   │  kNouns  │   │ ReviewEntries  │
   │  kVerbs  │   │ AppPreferences │
   │ kAdjs    │   │ UserProgress   │
   └──────────┘   └────────────────┘
```

---

## 4. Adaptive Navigation Shell

| Screen width  | Shell                              |
|---------------|------------------------------------|
| < 600 px      | `BottomNavigationBar` (mobile)     |
| ≥ 600 px      | `NavigationRail` (desktop/tablet)  |

Navigation destinations (4 tabs):

| Index | Label        | Icon                           |
|-------|--------------|--------------------------------|
| 0     | Home         | `Icons.home_outlined`          |
| 1     | Stats        | `Icons.bar_chart_outlined`     |
| 2     | Achievements | `Icons.emoji_events_outlined`  |
| 3     | Settings     | `Icons.settings_outlined`      |

`QuizScreen`, `VocabBrowserScreen`, and `AboutScreen` are pushed on top of
the shell navigator — not tab destinations.

---

## 5. Data Flow — Quiz Session

```
User taps "Start Review" or "Difficult words"
         │
         ▼
GamificationService.startSession()   ← resets session XP / streak counter
         │
         ▼
ReviewScheduler.getDueItems()  OR  getDifficultItems()
  ├─ reads AppPreferences → selected CefrLevels
  ├─ reads AppPreferences → selected CardTypes
  ├─ reads AppPreferences → session size limit
  ├─ filters kNouns / kVerbs / kAdjectives by level
  ├─ loads all ReviewEntries from DB
  ├─ for each card: eligible(sm2)?
  │     getDueItems     → Sm2Service.isDue(sm2)
  │     getDifficultItems → repetitions > 0 && easeFactor < 2.0
  ├─ due.shuffle()
  └─ due.sublist(0, limit)   ← cap at session size
         │
         ▼
List<QuizItem> (shuffled, capped)
         │
         ▼
QuizScreen iterates linearly
         │
         ├─ NounQuizItem             → ArticleButtons (der/die/das)
         ├─ VerbAuxiliaryQuizItem    → AuxiliaryButtons (haben/sein)
         └─ everything else          → ConjugationField (free text)
                │
                ▼
         User answers
                │
                ├─ correct  → grade 5 → Sm2Service.applyGrade
                └─ wrong    → grade 0 → Sm2Service.applyGrade
                               card re-queued at end
                │
                ▼
         ReviewScheduler.saveResult()        ← immediate DB write
         GamificationService.processAnswer() ← XP + achievement check
                                               (inside DB transaction)
         │
         ▼ (on last card)
GamificationService.completeSession() → SessionSummary
  ├─ increments sessionsCompleted
  ├─ runs achievement check inside same DB transaction
  ├─ returns XP total, level change, newly unlocked achievements
  └─ if leveledUp → confetti burst on SessionCompleteScreen
```

---

## 6. _queryItems Predicate Pattern

Both `getDueItems` and `getDifficultItems` share one implementation:

```dart
Future<List<QuizItem>> _queryItems({
  required bool Function(Sm2State) eligible,
}) async { ... }

getDueItems()      → _queryItems(eligible: (sm2) => Sm2Service.isDue(sm2))
getDifficultItems()→ _queryItems(eligible: (sm2) =>
                       sm2.repetitions > 0 && sm2.easeFactor < 2.0)
```

The `eligible` predicate is called once per candidate card — no duplication
of the level/cardType filtering or QuizItem construction logic.

---

## 7. Gamification System

```
XP per correct answer     : 10 XP
First-attempt bonus       : +5 XP
Override (typo correction): 10 XP  (first-attempt bonus preserved)

Level formula:
  level = floor( (1 + sqrt(1 + 8·totalXp/100)) / 2 )
```

Achievements are checked atomically inside the DB transaction that writes
updated stats, preventing double-unlock races.

| Achievement ID      | Trigger                        |
|---------------------|--------------------------------|
| `first_correct`     | totalCorrect ≥ 1               |
| `correct_50`        | totalCorrect ≥ 50              |
| `correct_100`       | totalCorrect ≥ 100             |
| `correct_500`       | totalCorrect ≥ 500             |
| `first_correct_100` | totalFirstCorrect ≥ 100        |
| `level_5`           | level ≥ 5                      |
| `level_10`          | level ≥ 10                     |
| `level_20`          | level ≥ 20                     |
| `consecutive_10`    | 10 correct in a row            |
| `first_session`     | sessionsCompleted ≥ 1          |

---

## 8. SM-2 State Machine

```
         ┌────────────────────────────────────────┐
         │  New card (epoch 0 nextReview)          │
         │  EF=2.5  interval=0  reps=0             │
         └───────────────────┬────────────────────┘
                             │ grade 5
                             ▼
                    ┌────────────────┐
                    │  reps=1        │
                    │  interval=1    │◄─── grade 5 ──┐
                    │  EF+=0.1       │               │
                    └───────┬────────┘               │
                            │ grade 5                │
                            ▼                        │
                    ┌────────────────┐               │
                    │  reps=2        │     grade 0   │
                    │  interval=6    ├───────────────►│ reset
                    └───────┬────────┘    reps=0     │
                            │ grade 5     interval=1 │
                            ▼                        │
                    ┌────────────────┐               │
                    │  reps=n+1      │               │
                    │  interval=     │               │
                    │  round(prev×EF)│               │
                    │  EF clamped    │               │
                    │  ≥ 1.3         │               │
                    └───────┬────────┘               │
                            │                        │
                            └────────────────────────┘
```

---

## 9. Database Schema

```
review_entries
┌────────────────┬─────────┬──────────────────────────────────────┐
│ id             │ TEXT PK │ e.g. "noun:Hund"                      │
│                │         │      "verb:gehen:er:perfekt"          │
│                │         │      "adj_comparative:groß"           │
│ cardType       │ INTEGER │ CardType enum index                   │
│ easeFactor     │ REAL    │ ≥ 1.3, default 2.5                    │
│ intervalDays   │ INTEGER │ days until next review                │
│ repetitions    │ INTEGER │ consecutive correct count             │
│ nextReviewMs   │ INTEGER │ ms since epoch                        │
└────────────────┴─────────┴──────────────────────────────────────┘

app_preferences
┌────────────────┬─────────┬──────────────────────────────────────┐
│ key            │ TEXT PK │ "selected_levels"                     │
│                │         │ "selected_card_types"                 │
│                │         │ "session_size"                        │
│ value          │ TEXT    │ "a1,a2,b1"  /  "10"                  │
└────────────────┴─────────┴──────────────────────────────────────┘

user_progress
┌───────────────────┬─────────┬─────────────────────────────────┐
│ id                │ INTEGER │ always 1 (singleton row)         │
│ totalXp           │ INTEGER │ cumulative XP                    │
│ totalCorrect      │ INTEGER │ all-time correct answers         │
│ totalFirstCorrect │ INTEGER │ correct on first attempt         │
│ sessionsCompleted │ INTEGER │ completed quiz sessions          │
│ unlockedAchievements│ TEXT  │ comma-separated achievement IDs  │
└───────────────────┴─────────┴─────────────────────────────────┘
```

Generated by Drift (build_runner). Schema version 1 — no migrations in v1.

---

## 10. File Structure

```
src/
├── pubspec.yaml
├── analysis_options.yaml
└── lib/
    ├── main.dart                         ← runApp entry point
    ├── app.dart                          ← AppServices + MaterialApp
    ├── models/
    │   ├── noun.dart                     ← NounEntry, Article, CefrLevel
    │   ├── verb.dart                     ← VerbEntry, GrammaticalPerson, Tense, Auxiliary
    │   ├── adjective.dart                ← AdjectiveEntry
    │   ├── quiz_item.dart                ← QuizItem (sealed, 12 subtypes), Sm2State, CardType
    │   ├── achievement.dart              ← Achievement, AchievementTrigger, kAchievements
    │   └── user_progress.dart            ← UserProgress (XP, level, stats)
    ├── data/
    │   ├── nouns.dart                    ← const kNouns (~215 entries, A1–B1)
    │   ├── verbs.dart                    ← const kVerbs (~95 entries, A1–B1)
    │   └── adjectives.dart               ← const kAdjectives (~54 entries, A1–B2)
    ├── services/
    │   ├── sm2.dart                      ← Sm2Service — pure algorithm, no I/O
    │   ├── database.dart                 ← AppDatabase (Drift), all three tables
    │   ├── review_scheduler.dart         ← _queryItems, getDueItems, getDifficultItems,
    │   │                                    getStats, saveResult, session size, filters
    │   └── gamification_service.dart     ← XP, levels, achievements, session tracking
    ├── shell/
    │   ├── adaptive_shell.dart           ← breakpoint router (< 600 px → mobile)
    │   ├── mobile_shell.dart             ← BottomNavigationBar
    │   ├── desktop_shell.dart            ← NavigationRail
    │   └── shell_items.dart              ← shared navigation destination definitions
    ├── screens/
    │   ├── home_screen.dart              ← filters, due summary, Start/Difficult/Browse
    │   ├── quiz_screen.dart              ← linear quiz + SessionCompleteScreen (confetti)
    │   ├── vocab_browser_screen.dart     ← searchable noun/verb/adjective browser
    │   ├── stats_screen.dart             ← deck size and due breakdown
    │   ├── achievements_screen.dart      ← achievement badge grid
    │   ├── settings_screen.dart          ← CEFR level selector, session size, About link
    │   └── about_screen.dart             ← version, licence, log export, easter egg
    └── widgets/
        ├── article_buttons.dart          ← der / die / das tappable buttons
        ├── auxiliary_buttons.dart        ← haben / sein tappable buttons
        ├── conjugation_field.dart        ← free-text input with optional hint text
        └── feedback_overlay.dart         ← correct/incorrect banner + Next + Override
```

---

## 11. Key Packages

| Package             | Purpose                                   |
|---------------------|-------------------------------------------|
| `drift`             | SQLite ORM + code generation              |
| `sqlite3_flutter_libs` | Flutter SQLite backend                 |
| `package_info_plus` | Read app version at runtime               |
| `url_launcher`      | Open external URLs (licence, GitHub)      |
| `share_plus`        | Share files (JSON log export)             |
| `path_provider`     | Temp directory for export file            |
| `confetti`          | Confetti burst animation on level-up      |

---

## 12. Theme

```dart
ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
  useMaterial3: true,
)
// + darkTheme with Brightness.dark, same seed
// themeMode: ThemeMode.system
```

---

## 13. Version Stamping

The app version displayed in `AboutScreen` comes from `pubspec.yaml` embedded
at build time via `package_info_plus`.

CI patches `pubspec.yaml` before building:

| Workflow      | Stamp format                       | Example        |
|---------------|------------------------------------|----------------|
| `ci.yml`      | `{base}-dev+{run_number}`          | `0.1.0-dev+42` |
| `release.yml` | `{tag_version}+{run_number}`       | `1.0.0+7`      |

Release tags follow `v{major}.{minor}.{patch}`.
