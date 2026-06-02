# LanguageTrainer

A personal, ad-free Flutter app for drilling German vocabulary — noun articles (*der / die / das*) and verb conjugation (Präsens · Präteritum · Perfekt).

---

## Features

- **Noun drill** — tap the correct article (der / die / das)
- **Verb conjugation drill** — type the correct conjugated form
- **Spaced repetition** — SM-2 algorithm schedules cards by difficulty
- **CEFR level filter** — practice A1 through C2 words independently
- **Category filter** — focus on Nouns, Präsens, Präteritum, or Perfekt
- **Gamification** — earn XP per correct answer, level up, unlock achievement badges
- **Adaptive shell** — bottom nav on phone, navigation rail on tablet/desktop
- **Offline & ad-free** — all data stored locally with SQLite (Drift)

## Vocabulary

| Level | Nouns | Verbs |
|-------|------:|------:|
| A1 | 60 | 30 |
| A2 | 71 | 30+ |
| B1 | 61 | 15+ |

Thematic groups include: everyday objects, family, travel, birthday, relationships, and abstract vocabulary.  
Full word list with conjugation tables: [`docs/VOCABULARY.md`](docs/VOCABULARY.md)

## Platforms

| Platform | CI build | Release artifact |
|----------|----------|-----------------|
| Android | ✓ debug APK | signed APK (if keystore secret set) |
| Linux | ✓ .deb | .deb package |
| macOS | ✓ .app.zip | ad-hoc signed .zip |

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

## CI / CD

Push to `main`, `develop`, `feature/**`, or `claude/**` triggers:

1. `flutter analyze --fatal-infos` + `flutter test`
2. Debug builds for Android, Linux, macOS (artifacts uploaded for 14 days)
3. SBOM (CycloneDX JSON)

Pushing a tag `v*.*.*` triggers the release workflow and creates a GitHub Release with all three platform artifacts.

### Android release signing

Set these four repository secrets to enable signed release APKs:

| Secret | Value |
|--------|-------|
| `ANDROID_RELEASE_KEYSTORE_B64` | `base64 -w0 release.keystore` |
| `ANDROID_KEYSTORE_PASSWORD` | keystore password |
| `ANDROID_KEY_ALIAS` | key alias (e.g. `languagetrainer`) |
| `ANDROID_KEY_PASSWORD` | key password |

## Architecture

```
src/lib/
├── app.dart                  # AppServices container + MaterialApp
├── main.dart
├── data/
│   ├── nouns.dart            # static noun list
│   └── verbs.dart            # static verb list with full conjugations
├── models/                   # pure data classes
├── services/
│   ├── database.dart         # Drift SQLite database
│   ├── review_scheduler.dart # SM-2 scheduling + level/category filters
│   ├── gamification_service.dart
│   └── sm2.dart
├── shell/                    # adaptive navigation shell
└── screens/                  # Home · Quiz · Stats · Achievements · Settings
```

Full architecture diagram and wireframes: [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) · [`docs/WIREFRAMES.md`](docs/WIREFRAMES.md)

## License

See [LICENSE](LICENSE).
