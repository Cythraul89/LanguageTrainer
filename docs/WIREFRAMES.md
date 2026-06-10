# LanguageTrainer — Screen Wireframes

Design language:
- Seed colour `Colors.indigo`, Material 3, `useMaterial3: true`
- Light / dark follows system setting
- `Card(clipBehavior: Clip.antiAlias)` for grouped content
- 16 px outer padding, 8 px intra-section spacing
- `titleMedium` for section headers, `bodySmall` / `onSurfaceVariant` for metadata
- `FilledButton` for primary actions, `OutlinedButton` for secondary actions
- `FilledButton.tonal` for answer choices (article/auxiliary buttons)

---

## Navigation Shell

### Mobile  (width < 600 px) — BottomNavigationBar

```
 ┌──────────────────────────────────────┐
 │                                      │
 │            [screen content]          │
 │                                      │
 ├──────────────────────────────────────┤
 │  🏠      📊      🏆       ⚙         │
 │  Home   Stats  Achieve  Settings     │
 └──────────────────────────────────────┘
```

### Tablet / Desktop  (width ≥ 600 px) — NavigationRail

```
 ┌────┬─────────────────────────────────┐
 │ 🏠 │                                 │
 │ 📊 │                                 │
 │ 🏆 │      [screen content]           │
 │ ⚙  │                                 │
 └────┴─────────────────────────────────┘
```

---

## HomeScreen

```
 ┌──────────────────────────────────────┐
 │  Language Trainer                    │  ← AppBar
 ├──────────────────────────────────────┤
 │                                      │
 │  Level 7            420 / 500 XP     │  ← XP card (Card)
 │  ███████████████░░░░░░░░░░░░         │    LinearProgressIndicator
 │  312 correct answers total           │    bodySmall / onSurfaceVariant
 │                                      │
 │  Practice level                      │  ← titleMedium
 │  ┌────┐ ┌────┐ ┌────┐ ┌────┐        │
 │  │ A1 │ │ A2 │ │ B1 │  B2           │  ← FilterChip row
 │  └────┘ └────┘ └────┘               │    selected = filled indigo
 │  C1     C2                           │
 │                                      │
 │  Practice category                   │  ← titleMedium
 │  ┌────────┐ ┌───────┐ ┌──────────┐  │
 │  │Artikel │ │Plural │ │Übersetzg.│  │  ← FilterChip row (14 types)
 │  └────────┘ └───────┘ └──────────┘  │
 │  …                                   │
 │                                      │
 │  ┌──────────────────────────────┐    │  ← Due today Card
 │  │  Due today                   │    │
 │  │──────────────────────────────│    │
 │  │  Artikel             12 / 20 │    │
 │  │  Plural              10 / 18 │    │
 │  │  Übersetzung (N)      8 / 20 │    │
 │  │  DE schreiben (N)     6 / 20 │    │
 │  │  Präsens             45 / 60 │    │
 │  │  …                           │    │
 │  │──────────────────────────────│    │
 │  │  Total               95 / 178│    │  ← bold
 │  └──────────────────────────────┘    │
 │                                      │
 │  ████████████████████████████████    │
 │  ▶  Start Review (95)                │  ← FilledButton (disabled if 0)
 │                                      │
 │  ╔════════════════════════════════╗  │
 │  ║  Difficult words (7)           ║  │  ← OutlinedButton (disabled if 0)
 │  ╚════════════════════════════════╝  │
 │                                      │
 │  ╔════════════════════════════════╗  │
 │  ║  Browse vocabulary             ║  │  ← OutlinedButton (always enabled)
 │  ╚════════════════════════════════╝  │
 │                                      │
 └──────────────────────────────────────┘
```

**Interaction notes**
- Level FilterChip: at least one must remain selected.
- Category FilterChip: at least one must remain selected.
- Due counts update immediately after any filter change.
- "Difficult words" shows cards with easeFactor < 2.0 (seen but struggling),
  regardless of SM-2 due date.

---

## QuizScreen — Noun article selection

### Unanswered

```
 ┌──────────────────────────────────────┐
 │ ←   3 / 45                           │  ← AppBar (back = quit confirm)
 │ ████▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │  ← LinearProgressIndicator
 ├──────────────────────────────────────┤
 │                                      │
 │               Hund                   │  ← displaySmall
 │               dog                    │  ← titleMedium
 │              (Hunde)                 │  ← bodySmall / onSurfaceVariant
 │                                      │
 │  ┌──────┐    ┌──────┐    ┌──────┐   │
 │  │ der  │    │ die  │    │ das  │   │  ← FilledButton.tonal × 3
 │  └──────┘    └──────┘    └──────┘   │
 │                                      │
 └──────────────────────────────────────┘
```

### After correct answer

```
 │  ┌────────────────────────────────┐  │
 │  │ ✓  Correct!                   │  │  ← green tinted Card
 │  └────────────────────────────────┘  │
 │  ████████████████████████████████    │
 │             Next →                   │  ← FilledButton
```

### After wrong answer

```
 │  ┌────────────────────────────────┐  │
 │  │ ✗  Incorrect                  │  │  ← red tinted Card
 │  │    Answer: der Hund           │  │
 │  └────────────────────────────────┘  │
 │  ████████████████████████████████    │
 │             Next →                   │
```

---

## QuizScreen — Auxiliary selection

```
 │               gehen                  │  ← displaySmall
 │           to go / travel             │  ← titleMedium
 │         haben oder sein?             │  ← labelLarge / onSurfaceVariant
 │                                      │
 │      ┌────────┐    ┌────────┐        │
 │      │ haben  │    │  sein  │        │  ← FilledButton.tonal × 2
 │      └────────┘    └────────┘        │
```

---

## QuizScreen — Free-text (conjugation / translation / reverse)

### Unanswered (verb conjugation example)

```
 ┌──────────────────────────────────────┐
 │ ←  12 / 45                           │
 │ ████████████░░░░░░░░░░░░░░░░░░░░░░░ │
 ├──────────────────────────────────────┤
 │                                      │
 │    er/sie/es  ___  (gehen)           │  ← headlineMedium
 │             Perfekt                  │  ← labelLarge / onSurfaceVariant
 │           to go / travel             │  ← titleMedium
 │                                      │
 │  ┌──────────────────────────┐ ┌────┐ │
 │  │  ist gegangen            │ │ ✓  │ │  ← TextField + FilledButton
 │  └──────────────────────────┘ └────┘ │
 │                                      │
 └──────────────────────────────────────┘
```

### After wrong answer (with override option)

```
 │  ┌────────────────────────────────┐  │
 │  │ ✗  Incorrect                  │  │
 │  │    Answer: ist gegangen       │  │
 │  └────────────────────────────────┘  │
 │                                      │
 │  [ Mark as correct (typo/keyboard) ] │  ← TextButton (text-input cards only)
 │                                      │
 │  ████████████████████████████████    │
 │             Next →                   │
```

---

## QuizScreen — Session complete

```
 ┌──────────────────────────────────────┐
 │  Session Complete                    │  ← AppBar
 ├──────────────────────────────────────┤
 │         🎉 (confetti if level-up)    │  ← ConfettiWidget overlay
 │                                      │
 │               ✓                      │  ← green check icon (72 px)
 │         Session complete!            │  ← headlineSmall
 │          +120 XP earned              │  ← titleMedium / primary
 │                                      │
 │  ┌──────────────────────────────┐    │
 │  │  Level 8    [Level up! 7→8]  │    │  ← XP summary Card
 │  │  520 / 600 XP                │    │    Chip shown only if leveledUp
 │  │  ███████████████░░░░░░░      │    │
 │  └──────────────────────────────┘    │
 │                                      │
 │  Achievements unlocked!              │  ← only if any unlocked
 │  ┌──────────────────────────────┐    │
 │  │  🏆  100 correct answers!    │    │  ← primaryContainer Card
 │  │      Answered 100 correctly  │    │
 │  └──────────────────────────────┘    │
 │                                      │
 │  ████████████████████████████████    │
 │         Back to Home                 │  ← FilledButton
 │                                      │
 └──────────────────────────────────────┘
```

---

## VocabBrowserScreen

```
 ┌──────────────────────────────────────┐
 │ ←  Vocabulary                        │  ← AppBar with TabBar
 │   Nouns    Verbs    Adjectives        │
 ├──────────────────────────────────────┤
 │  ┌────────────────────────────────┐  │
 │  │ 🔍  Search…                   │  │  ← shared TextField (all tabs)
 │  └────────────────────────────────┘  │
 │                                      │
 │  ● Hund                              │  ← ListTile (Nouns tab)
 │    dog                    pl: Hunde  │    leading: article chip (colour-coded)
 │                                      │    trailing: plural
 │  ● Frau                              │
 │    woman                 pl: Frauen  │
 │  …                                   │
 └──────────────────────────────────────┘
```

### Article chips (Nouns tab)

| Article | Colour  |
|---------|---------|
| der     | Blue `#1565C0` |
| die     | Red  `#C62828` |
| das     | Green `#2E7D32` |

### Verbs tab — expanded

```
 │  gehen                          ist   │  ← ExpansionTile (auxiliary chip)
 │  to go / travel                  ▲   │    tapping expands conjugation table
 │  ┌───────────────────────────────┐   │
 │  │        Präsens  Präteritum  Perfekt│
 │  │  ich   gehe     ging        bin gegangen│
 │  │  du    gehst    gingst      bist gegangen│
 │  │  er    geht     ging        ist gegangen│
 │  │  wir   gehen    gingen      sind gegangen│
 │  │  ihr   geht     gingt       seid gegangen│
 │  │  sie   gehen    gingen      sind gegangen│
 │  │  Part.II  gegangen                │
 │  └───────────────────────────────┘   │
```

### Adjectives tab

```
 │  groß                                │  ← ListTile
 │  big / tall     größer · am größten  │    trailing: comparative · superlative
```

---

## SettingsScreen

```
 ┌──────────────────────────────────────┐
 │ ←  Settings                          │  ← AppBar
 ├──────────────────────────────────────┤
 │                                      │
 │  Practice level                      │  ← titleMedium
 │  ┌────┐ ┌────┐ ┌────┐               │
 │  │ A1 │ │ A2 │ │ B1 │ B2  C1  C2   │  ← FilterChip row
 │  └────┘ └────┘ └────┘               │
 │                                      │
 │  ────────────────────────────────    │
 │                                      │
 │  Session size                 10     │  ← titleMedium + current value
 │  5 ──●──────────────────────── 50    │  ← Slider (5–50, steps of 5)
 │                                      │
 │  ────────────────────────────────    │
 │                                      │
 │  About                         >     │  ← ListTile (navigates to AboutScreen)
 │                                      │
 └──────────────────────────────────────┘
```

---

## AboutScreen

```
 ┌──────────────────────────────────────┐
 │ ←  About                             │  ← AppBar
 ├──────────────────────────────────────┤
 │                                      │
 │        [App Icon]                    │
 │       Language Trainer               │  ← titleLarge
 │       Version 1.0.0+7                │  ← bodyMedium (tap 7× for easter egg)
 │                                      │
 │  Legal                               │  ← section header
 │  Open Source Licence          GPL-3  │  ← ListTile → url_launcher
 │  Source Code                  GitHub │  ← ListTile → url_launcher
 │                                      │
 │  Data                                │
 │  Export review log                   │  ← ListTile → share_plus JSON export
 │                                      │
 └──────────────────────────────────────┘
```

---

## Quit Confirmation Dialog

```
 ┌──────────────────────────────────────┐
 │  Quit review?                        │  ← AlertDialog title
 │                                      │
 │  Progress so far is saved.           │  ← bodyMedium
 │                                      │
 │              Continue      Quit      │  ← TextButton + FilledButton
 └──────────────────────────────────────┘
```

---

## Colour Reference (Material 3 — indigo seed)

| Role                       | Usage                                          |
|----------------------------|------------------------------------------------|
| `primary`                  | AppBar, filled buttons, progress bar, chips    |
| `onPrimary`                | Text/icons on primary backgrounds              |
| `primaryContainer`         | Tonal button fills, achievement cards          |
| `surface`                  | Card backgrounds                               |
| `onSurfaceVariant`         | Plural hints, tense labels, metadata text      |
| `error` / `errorContainer` | Wrong-answer feedback card                     |
| green (custom)             | Correct-answer feedback card                   |
| `#1565C0` / `#C62828` / `#2E7D32` | Article chips (der/die/das)         |

Dark theme uses the same seed with `Brightness.dark` — no additional
colour overrides needed.
