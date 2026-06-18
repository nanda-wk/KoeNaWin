# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

KoeNaWin is a SwiftUI iOS app (iOS 16+) guiding users through the traditional Koe Na Win Buddhist discipline: an 81-day journey = **9 stages × 9 days**. Each day has a mantra, recitation count, and a vegetarian flag. Practice can only start on a **Monday**; missing a day resets the journey.

## Build / Test / Run

Xcode project (no workspace, no SPM/CocoaPods/Carthage manifest — dependencies are system frameworks only). Two app targets: `KoeNaWin` (production) and `KoeNaWin-Dev` (dev variant).

```bash
# Build dev scheme for simulator
xcodebuild -project KoeNaWin.xcodeproj -scheme KoeNaWin-Dev \
  -destination 'platform=iOS Simulator,name=iPhone 16' build

# Run all tests (unit + UI)
xcodebuild -project KoeNaWin.xcodeproj -scheme KoeNaWin-Dev \
  -destination 'platform=iOS Simulator,name=iPhone 16' test

# Run a single test
xcodebuild -project KoeNaWin.xcodeproj -scheme KoeNaWin-Dev \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  test -only-testing:KoeNaWinTests/KoeNaWinTests/testExample
```

Day-to-day work is normally done in Xcode (open `KoeNaWin.xcodeproj`, ⌘B / ⌘U). Test targets are scaffold-only at present.

## Architecture

Two data planes, kept separate:

1. **Static content** — `Resources/KoeNaWin.json` holds the 9 stages, their prayers/mantras, and vegetarian days. Loaded by `KoeNaWinStore.loadData()` via the `Bundle.decode` extension into `KoeNaWinStage` / `Prayer` models. Read-only.
2. **User state** — Core Data (`CoreDataStack`) persists the practice journey: `Commitment` → `Journey` → `DailyProgress` (one-to-many chain). `Journey` carries `journeyOutcome` (inProgress/succeeded/failed/abandoned) and `journeyEndReason`.

**`JourneyService` (Services/) is the central orchestrator** — an `ObservableObject` that owns the `CoreDataStack`, resolves daily state, and drives the UI. It is the highest-connectivity node in the codebase; most features depend on it. Key responsibilities:
- `startNewJourney` / `getOrCreateKoeNaWinCommitment` — begin a cycle (Monday-only via `Date.isMonday`).
- `resolveDailyState` / `refreshState` / `refreshActiveJourney` — compute the current `PracticeState` (notStarted / scheduled / started / missedDay / completedAll, defined in `Uitls/Constants`).
- `completeToday`, `detectMissedDays`, `backfillCompletedDays` — daily progress + miss-detection logic (missing a day resets progress).
- `calculateLongestStreak`, `updateJourneyStats` — stats for the Achievement screen.
- `setDailyReminder` / `setNewCommitmentReminder` — schedule notifications (delegates to `NotificationService`).
- `migrateOldUserProgress` — migrates the legacy `UserProgress` entity to the `Commitment`/`Journey` model. Preserve this when touching Core Data.

**Navigation** is centralized in `Router/` — `Router` (`ObservableObject`) plus `RouterDestination` (push) and `RouterSheet` (modal) enums. Screens call `router.navigateTo` / `presentSheet` rather than holding `NavigationLink`s directly.

**Other services**: `UserPreferences` (app settings, theme, language), `NotificationService` (local notification scheduling/auth).

**Feature screens** (`Features/`): Home, Practice, Journey (onboarding/new-commitment), Stages + StageDetails, Settings, Achievement, Tab (root tab bar), Launch. The `Tab` screen is the navigation hub bridging most communities.

## Conventions

- **The utils directory is misspelled `Uitls/`** (not `Utils/`) — `Uitls/Constants.swift`, `Uitls/Haptic.swift`, `Uitls/Extensions/`. Use the existing spelling.
- **Localization is custom, not `Localizable.strings`-driven for content**: `AppLanguage` (english/myanmar) toggles language; Myanmar numeral rendering is done by `String`/`Int` extensions (`toMyanmarDigits`) in `Uitls/Extensions/StringExtensions`. When displaying counts/dates to Myanmar users, route through these.
- SwiftUI throughout; reusable UI lives in `Components/` (`CircularProgressView`, `CustomProgressViewStyle`, `LanguagePicker`, `WebView`).

## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

Rules:
- For codebase questions, first run `graphify query "<question>"` when graphify-out/graph.json exists. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).
