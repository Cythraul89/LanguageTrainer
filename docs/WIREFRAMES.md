# LanguageTrainer — Screen Wireframes

Design language mirrors StockManager:
- Seed colour `Colors.indigo`, Material 3, `useMaterial3: true`
- Light / dark follows system setting
- `Card(clipBehavior: Clip.antiAlias)` for grouped content
- 16 px outer padding, 8 px intra-section spacing
- `titleMedium` for section headers, `bodySmall` / `onSurfaceVariant` for metadata
- `FilledButton` for primary actions, `FilledButton.tonal` for answer choices

---

## Navigation Shell

### Mobile  (width < 600 px) — BottomNavigationBar

```
 ┌──────────────────────────────────────┐
 │                                      │
 │            [screen content]          │
 │                                      │
 ├──────────────────────────────────────┤
 │   🏠          📊          ⚙         │
 │   Home       Stats     Settings      │
 └──────────────────────────────────────┘
```

### Tablet / Desktop  (width 600–1199 px) — NavigationRail compact

```
 ┌────┬─────────────────────────────────┐
 │ 🏠 │                                 │
 │    │                                 │
 │ 📊 │      [screen content]           │
 │    │                                 │
 │ ⚙  │                                 │
 └────┴─────────────────────────────────┘
```

### Wide Desktop  (width ≥ 1200 px) — NavigationRail extended

```
 ┌──────────────┬──────────────────────────────────────────────┐
 │  Language    │                                              │
 │  Trainer     │                                              │
 │              │                                              │
 │ 🏠  Home     │             [screen content]                 │
 │              │                                              │
 │ 📊  Stats    │                                              │
 │              │                                              │
 │ ⚙   Settings│                                              │
 └──────────────┴──────────────────────────────────────────────┘
```

---

## HomeScreen

```
 ┌──────────────────────────────────────┐
 │  Language Trainer              ☀/🌙  │  ← AppBar (indigo, theme toggle)
 ├──────────────────────────────────────┤
 │                                      │
 │  Practice level                      │  ← titleMedium
 │  ┌────┐ ┌────┐ ┌────┐ ┌────┐        │
 │  │ A1 │ │ A2 │ │ B1 │  B2           │  ← FilterChip row
 │  └────┘ └────┘ └────┘               │    selected = filled indigo
 │  C1     C2                           │    deselected = outline
 │                                      │
 │  ┌──────────────────────────────┐    │
 │  │  Due today                   │    │  ← Card (Clip.antiAlias)
 │  │──────────────────────────────│    │    titleMedium header
 │  │  Nouns               12 / 20 │    │
 │  │  Präsens             45 / 60 │    │  ← bodyMedium rows
 │  │  Präteritum          45 / 60 │    │    right: primary colour
 │  │  Perfekt             45 / 60 │    │
 │  │──────────────────────────────│    │
 │  │  Total              147 / 200│    │  ← bold total row
 │  └──────────────────────────────┘    │
 │                                      │
 │  ████████████████████████████████    │
 │  ▶  Start Review  (147 cards)        │  ← FilledButton (disabled = 0 due)
 │                                      │
 ├──────────────────────────────────────┤
 │   🏠          📊          ⚙         │  ← BottomNavigationBar (mobile only)
 └──────────────────────────────────────┘
```

**Interaction notes**
- FilterChip tap toggles a level; at least one must remain selected
  (chip tap is ignored if it would deselect the last active chip).
- Due counts update immediately after level change.
- "Start Review" is `disabled` when `totalDue == 0`.

---

## QuizScreen — Noun (article selection)

```
 ┌──────────────────────────────────────┐
 │ ←   3 / 45                           │  ← AppBar: back (confirms quit) + progress
 │ ████▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │  ← LinearProgressIndicator (indigo)
 ├──────────────────────────────────────┤
 │                                      │
 │                                      │
 │                                      │
 │               Hund                   │  ← displaySmall  (word)
 │                                      │
 │               dog                    │  ← titleMedium   (english)
 │              (Hunde)                 │  ← bodySmall / onSurfaceVariant (plural)
 │                                      │
 │                                      │
 │  ┌──────┐    ┌──────┐    ┌──────┐   │
 │  │ der  │    │ die  │    │ das  │   │  ← FilledButton.tonal × 3
 │  └──────┘    └──────┘    └──────┘   │    equal width, large text
 │                                      │
 │                                      │
 └──────────────────────────────────────┘
```

### After correct answer

```
 ┌──────────────────────────────────────┐
 │ ←   3 / 45                           │
 │ ████▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
 ├──────────────────────────────────────┤
 │               Hund                   │
 │               dog                    │
 │              (Hunde)                 │
 │                                      │
 │  ┌────────────────────────────────┐  │
 │  │ ✓  Correct!                   │  │  ← green tinted Card
 │  └────────────────────────────────┘  │    border: green
 │                                      │
 │  ████████████████████████████████    │
 │             Next →                   │  ← FilledButton
 │                                      │
 └──────────────────────────────────────┘
```

### After wrong answer

```
 ┌──────────────────────────────────────┐
 │ ←   3 / 45                           │
 │ ████▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
 ├──────────────────────────────────────┤
 │               Hund                   │
 │               dog                    │
 │              (Hunde)                 │
 │                                      │
 │  ┌────────────────────────────────┐  │
 │  │ ✗  Incorrect                  │  │  ← red tinted Card
 │  │    Answer: der Hund           │  │    border: red
 │  └────────────────────────────────┘  │
 │                                      │
 │  ████████████████████████████████    │
 │             Next →                   │
 │                                      │
 └──────────────────────────────────────┘
```

---

## QuizScreen — Verb (free-text conjugation)

### Unanswered

```
 ┌──────────────────────────────────────┐
 │ ←  12 / 45                           │
 │ ████████████░░░░░░░░░░░░░░░░░░░░░░░ │
 ├──────────────────────────────────────┤
 │                                      │
 │                                      │
 │    er/sie/es  ___  (gehen)           │  ← headlineMedium (prompt)
 │                                      │
 │             Perfekt                  │  ← labelLarge / onSurfaceVariant (tense)
 │                                      │
 │           to go / travel             │  ← titleMedium (english)
 │                                      │
 │  ┌──────────────────────────┐ ┌────┐ │
 │  │  ist gegangen            │ │Check│ │  ← TextField + FilledButton
 │  └──────────────────────────┘ └────┘ │    keyboard auto-opens
 │                                      │
 └──────────────────────────────────────┘
```

### After wrong answer (with override option)

```
 ┌──────────────────────────────────────┐
 │ ←  12 / 45                           │
 │ ████████████░░░░░░░░░░░░░░░░░░░░░░░ │
 ├──────────────────────────────────────┤
 │    er/sie/es  ___  (gehen)           │
 │             Perfekt                  │
 │           to go / travel             │
 │                                      │
 │  ┌────────────────────────────────┐  │
 │  │ ✗  Incorrect                  │  │
 │  │    Answer: ist gegangen       │  │
 │  └────────────────────────────────┘  │
 │                                      │
 │    Mark as correct (typo / keyboard) │  ← TextButton (subtle, below card)
 │                                      │
 │  ████████████████████████████████    │
 │             Next →                   │
 │                                      │
 └──────────────────────────────────────┘
```

### Session complete

```
 ┌──────────────────────────────────────┐
 │  Done                                │
 ├──────────────────────────────────────┤
 │                                      │
 │                                      │
 │               ✓                      │  ← large green check icon (72 px)
 │                                      │
 │          Session complete!           │  ← titleLarge
 │                                      │
 │                                      │
 └──────────────────────────────────────┘
```

---

## StatsScreen

```
 ┌──────────────────────────────────────┐
 │ ←  Statistics                        │  ← AppBar
 ├──────────────────────────────────────┤
 │                                      │
 │  Total deck size             200     │  ← bodyLarge + primary colour value
 │  Due now                     147     │
 │                                      │
 │  ────────────────────────────────    │  ← Divider
 │                                      │
 │  Nouns                  12 due / 20  │
 │  Verbs — Präsens        45 due / 60  │
 │  Verbs — Präteritum     45 due / 60  │
 │  Verbs — Perfekt        45 due / 60  │
 │                                      │
 ├──────────────────────────────────────┤
 │   🏠          📊          ⚙         │
 └──────────────────────────────────────┘
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
 │  │ A1 │ │ A2 │ │ B1 │ B2  C1  C2   │  ← FilterChip row (same as HomeScreen)
 │  └────┘ └────┘ └────┘               │
 │                                      │
 │  ────────────────────────────────    │
 │                                      │
 │  Theme                       System  │  ← ListTile with trailing dropdown
 │                         Light │ Dark │    (System / Light / Dark)
 │                                      │
 ├──────────────────────────────────────┤
 │   🏠          📊          ⚙         │
 └──────────────────────────────────────┘
```

**Notes:**
- Level selector on both HomeScreen (quick access) and SettingsScreen (canonical).
  Both widgets share the same `ReviewScheduler.setSelectedLevels()` call.
- Theme dropdown writes to `AppPreferences` (key `theme`, values `system`/`light`/`dark`).
  Follows the same pattern as StockManager's `AppTheme` enum.

---

## Quit Confirmation Dialog

Shown when user presses back during an active quiz session:

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

| Role                  | Usage                                         |
|-----------------------|-----------------------------------------------|
| `primary`             | AppBar, filled buttons, progress bar, chips   |
| `onPrimary`           | Text/icons on primary backgrounds             |
| `primaryContainer`    | Tonal button fills, selected chip background  |
| `surface`             | Card backgrounds                              |
| `onSurfaceVariant`    | Plural hints, tense labels, metadata text     |
| `error` / `errorContainer` | Wrong-answer feedback card              |
| green (custom)        | Correct-answer feedback card                  |

Dark theme uses the same seed with `Brightness.dark` — no additional
colour overrides needed.
