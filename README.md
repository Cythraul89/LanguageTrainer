# LanguageTrainer

A personal, ad-free Flutter app for drilling German vocabulary with spaced repetition. Covers noun articles, plural forms, translations, verb conjugation, adjective forms, separable verb prefixes, and preposition cases — all scheduled by the SM-2 algorithm.

---

## Features

- **Noun drills** — article (der/die/das), plural, EN↔DE translation
- **Verb drills** — conjugation (Präsens · Präteritum · Perfekt), Partizip II, auxiliary (haben/sein), EN↔DE translation, separable prefix
- **Adjective drills** — DE→EN translation, comparative, superlative, EN→DE reverse
- **Preposition drills** — DE→EN translation, grammatical case (Akkusativ / Dativ / Genitiv)
- **Spaced repetition** — SM-2 algorithm; wrong answers are re-queued immediately
- **Difficult words session** — targets cards with ease factor < 2.0
- **CEFR level filter** — practice A1 through C2 words independently
- **Category filter** — 18 quiz types grouped into Substantive / Verben / Adjektive / Präpositionen
- **Gamification** — XP, levels, 10 achievement badges, confetti on level-up
- **Vocabulary browser** — searchable reference with conjugation tables; Nouns / Verbs / Adjectives / Prepositions tabs
- **Adaptive shell** — bottom nav on phone, navigation rail on tablet/desktop
- **Offline & ad-free** — all data stored locally with SQLite (Drift)

---

## Vocabulary

| Level | Nouns | Verbs      | Adjectives | Prepositions |
|-------|------:|-----------:|-----------:|-------------:|
| A1    |    61 |  31 (1 sep)|         19 |           15 |
| A2    |    78 |  51 (11 sep)|        15 |           10 |
| B1    |    65 |  19 (2 sep)|          7 |            4 |
| B2    |     0 |          0 |          8 |            0 |
| **Total** | **204** | **101** | **49** | **29**   |

Up to **~3 306 deck cards** depending on active quiz types (14 separable verbs generate a prefix card each).

Thematic groups: everyday objects, family, food, travel, birthday, relationships, abstract B1 concepts.  
Full word list with conjugation tables: [`docs/VOCABULARY.md`](docs/VOCABULARY.md)

---

## Quiz Types

| Group         | Label              | Type               | Input            | Default |
|---------------|--------------------|--------------------|------------------|---------|
| Substantive   | Artikel            | `noun`             | 3 buttons        | ✓ |
|               | Plural             | `nounPlural`       | free text        | ✓ |
|               | Übersetzung        | `nounTranslation`  | free text        | ✓ |
|               | DE schreiben       | `nounReverse`      | free text        | ✓ |
| Verben        | Präsens            | `verbPraesens`     | free text        | ✓ |
|               | Präteritum         | `verbPraeteritum`  | free text        | ✓ |
|               | Perfekt            | `verbPerfekt`      | free text        | ✓ |
|               | Partizip II        | `verbPartizipII`   | free text        | ✓ |
|               | Hilfsverb          | `verbAuxiliary`    | 2 buttons        | ✓ |
|               | Bedeutung          | `verbTranslation`  | free text        | ✓ |
|               | Verb schreiben     | `verbReverse`      | free text        | ✓ |
|               | Trennbar           | `verbSeparable`    | free text        | ✗ |
| Adjektive     | Adj. Bedeutung     | `adjTranslation`   | free text        | ✓ |
|               | Komparativ         | `adjComparative`   | free text        | ✗ |
|               | Superlativ         | `adjSuperlative`   | free text        | ✗ |
|               | Adj. DE schreiben  | `adjReverse`       | free text        | ✗ |
| Präpositionen | Bedeutung          | `prepTranslation`  | free text        | ✗ |
|               | Kasus              | `prepCase`         | 3 buttons        | ✗ |

---

## Platforms

| Platform | CI build         | Release artifact        |
|----------|------------------|-------------------------|
| Android  | ✓ debug APK      | signed APK (if secrets) |
| Linux    | ✓ .deb           | .deb package            |
| macOS    | ✓ .app.zip       | ad-hoc signed .zip      |

---

## Getting started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) stable channel
- Dart SDK ≥ 3.3.0

### Run locally

```bash
cd src
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

### Run tests

```bash
cd src
flutter test
```

---

## CI / CD

Push to `main`, `develop`, `feature/**`, or `claude/**` triggers:

1. `flutter analyze --fatal-infos` + `flutter test`
2. Debug builds for Android, Linux, macOS (artifacts kept 14 days)
3. Vocabulary PDF (`tools/gen_vocab_pdf.py` via `fpdf2`, no Flutter needed; kept 90 days)
4. SBOM (CycloneDX JSON)

Pushing a tag `v*.*.*` triggers the release workflow and creates a GitHub Release with all three platform artifacts.

### Android release signing

| Secret | Value |
|--------|-------|
| `ANDROID_RELEASE_KEYSTORE_B64` | `base64 -w0 release.keystore` |
| `ANDROID_KEYSTORE_PASSWORD` | keystore password |
| `ANDROID_KEY_ALIAS` | key alias (e.g. `languagetrainer`) |
| `ANDROID_KEY_PASSWORD` | key password |

---

## Architecture

```
src/lib/
├── app.dart                       # AppServices container + MaterialApp
├── main.dart
├── data/
│   ├── nouns.dart                 # 204 nouns A1–B1
│   ├── verbs.dart                 # 101 verbs A1–B1 (14 separable)
│   ├── adjectives.dart            # 49 adjectives A1–B2
│   └── prepositions.dart          # 29 prepositions A1–B1
├── models/                        # pure data classes + sealed QuizItem (16 subtypes)
├── services/
│   ├── database.dart              # Drift SQLite (3 tables)
│   ├── review_scheduler.dart      # SM-2 scheduling + level/category filters
│   ├── gamification_service.dart  # XP, levels, achievements
│   └── sm2.dart                   # pure SM-2 algorithm
├── shell/                         # adaptive navigation shell (mobile / desktop)
├── screens/                       # Home · Quiz · Stats · Achievements · Settings · About · VocabBrowser
└── widgets/                       # ArticleButtons · AuxiliaryButtons · CaseButtons · ConjugationField · FeedbackOverlay
tools/
└── gen_vocab_pdf.py               # standalone Python script → vocabulary.pdf (fpdf2)
```

Full docs: [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) · [`docs/REQUIREMENTS.md`](docs/REQUIREMENTS.md) · [`docs/CLASS_DIAGRAM.md`](docs/CLASS_DIAGRAM.md)

---

## License

See [LICENSE](LICENSE).
