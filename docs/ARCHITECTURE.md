# LanguageTrainer — Architecture

## 1. Layer Overview

```
┌──────────────────────────────────────────────────────────────────┐
│  Presentation                                                     │
│  AdaptiveShell · HomeScreen · QuizScreen · StatsScreen           │
│  Widgets: ArticleButtons · ConjugationField · FeedbackOverlay    │
├──────────────────────────────────────────────────────────────────┤
│  Service                                                          │
│  ReviewScheduler   ←→   Sm2Service (pure)                        │
├──────────────────────────────────────────────────────────────────┤
│  Data                                                             │
│  AppDatabase (Drift/SQLite)    kNouns · kVerbs (const Dart)      │
└──────────────────────────────────────────────────────────────────┘
```

Dependencies flow strictly downward. No layer imports from a layer above it.
`Sm2Service` is a stateless utility — no database or widget dependency.

---

## 2. Module Dependency Graph

```
                        ┌──────────────┐
                        │ AdaptiveShell│
                        └──────┬───────┘
               ┌───────────────┼───────────────┐
               ▼               ▼               ▼
         HomeScreen       StatsScreen    SettingsScreen
               │
               │ push
               ▼
          QuizScreen
         /     |     \
ArticleButtons  ConjugationField  FeedbackOverlay
        \            |           /
         └────────────┬──────────┘
                      ▼
             ReviewScheduler
             /      |       \
        Sm2Service  │    AppDatabase
                    │     /       \
               ┌────┴────┐    ┌───┴──────────┐
               │  kNouns  │    │ ReviewEntries│
               │  kVerbs  │    │ AppPreferences│
               └──────────┘    └──────────────┘
```

---

## 3. Adaptive Navigation Shell

Mirrors StockManager's breakpoint strategy:

| Screen width  | Shell                           |
|---------------|---------------------------------|
| < 600 px      | `BottomNavigationBar` (mobile)  |
| 600 – 1199 px | `NavigationRail` compact        |
| ≥ 1200 px     | `NavigationRail` extended (labels visible) |

Navigation destinations:

| Index | Label    | Icon                         | Route   |
|-------|----------|------------------------------|---------|
| 0     | Home     | `Icons.home_outlined`        | `/`     |
| 1     | Stats    | `Icons.bar_chart_outlined`   | `/stats`|
| 2     | Settings | `Icons.settings_outlined`    | `/settings` |

`QuizScreen` is pushed onto the navigator on top of the shell — it is
not a tab destination.

---

## 4. Data Flow — Quiz Session

```
User taps "Start Review"
         │
         ▼
ReviewScheduler.getDueItems()
  ├─ reads AppPreferences → selected CefrLevels
  ├─ filters kNouns / kVerbs by level
  ├─ loads all ReviewEntries from DB
  └─ for each card: Sm2Service.isDue(sm2) ?
         │
         ▼
List<QuizItem>  (sorted: oldest nextReview first)
         │
         ▼
QuizScreen receives list, iterates linearly
         │
         ├─ NounQuizItem  → ArticleButtons (der/die/das)
         └─ VerbQuizItem  → ConjugationField (free text)
                │
                ▼
         User answers
                │
                ├─ correct  → grade 5 → Sm2Service.applyGrade
                └─ wrong    → grade 0 → Sm2Service.applyGrade
                               card re-queued at session end
                │
                ▼
         ReviewScheduler.saveResult()
         AppDatabase.upsertReviewEntry()  ← immediate write
```

---

## 5. SM-2 State Machine

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

## 6. Database Schema

```
review_entries
┌────────────────┬─────────┬──────────────────────────────┐
│ id             │ TEXT PK │ e.g. "noun:Hund"              │
│                │         │      "verb:gehen:er:perfekt"  │
│ cardType       │ INTEGER │ CardType enum index           │
│ easeFactor     │ REAL    │ ≥ 1.3, default 2.5            │
│ intervalDays   │ INTEGER │ days until next review        │
│ repetitions    │ INTEGER │ consecutive correct count     │
│ nextReviewMs   │ INTEGER │ ms since epoch                │
└────────────────┴─────────┴──────────────────────────────┘

app_preferences
┌────────────────┬─────────┬──────────────────────────────┐
│ key            │ TEXT PK │ e.g. "selected_levels"        │
│ value          │ TEXT    │ e.g. "a1,a2,b1"               │
└────────────────┴─────────┴──────────────────────────────┘
```

Generated by Drift (build_runner). Schema version 1 — no migrations in v1.

---

## 7. File Structure

```
src/
├── pubspec.yaml
├── analysis_options.yaml
├── lib/
│   ├── main.dart
│   ├── app.dart                    ← MaterialApp + GoRouter + AdaptiveShell
│   ├── models/
│   │   ├── noun.dart               ← NounEntry, Article, CefrLevel
│   │   ├── verb.dart               ← VerbEntry, GrammaticalPerson, Tense, Auxiliary
│   │   └── quiz_item.dart          ← QuizItem (sealed), Sm2State, CardType
│   ├── data/
│   │   ├── nouns.dart              ← const kNouns (60 entries, A1–B1)
│   │   └── verbs.dart              ← const kVerbs (25 entries, A1–B1)
│   ├── services/
│   │   ├── sm2.dart                ← Sm2Service — pure algorithm, no I/O
│   │   ├── database.dart           ← AppDatabase (Drift), ReviewEntries table
│   │   └── review_scheduler.dart   ← getDueItems, getStats, saveResult
│   ├── shell/
│   │   ├── adaptive_shell.dart     ← breakpoint router (mobile/desktop)
│   │   ├── mobile_shell.dart       ← BottomNavigationBar
│   │   └── desktop_shell.dart      ← NavigationRail
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── quiz_screen.dart
│   │   ├── stats_screen.dart
│   │   └── settings_screen.dart
│   └── widgets/
│       ├── article_buttons.dart
│       ├── conjugation_field.dart
│       └── feedback_overlay.dart
└── test/
    └── sm2_test.dart
```

---

## 8. Theme

Identical seed to StockManager for visual consistency:

```dart
ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
  useMaterial3: true,
)
// + darkTheme with Brightness.dark, same seed
// themeMode: ThemeMode.system
```
