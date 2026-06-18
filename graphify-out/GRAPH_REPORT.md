# Graph Report - KoeNaWin  (2026-06-19)

## Corpus Check
- 62 files · ~588,639 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 492 nodes · 632 edges · 37 communities (34 shown, 3 thin omitted)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 30 edges (avg confidence: 0.82)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `692f3718`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- [[_COMMUNITY_Domain Models & Constants|Domain Models & Constants]]
- [[_COMMUNITY_Journey Service Logic|Journey Service Logic]]
- [[_COMMUNITY_Core Data Stack & Persistence|Core Data Stack & Persistence]]
- [[_COMMUNITY_Journey Onboarding Screen|Journey Onboarding Screen]]
- [[_COMMUNITY_Router & App State|Router & App State]]
- [[_COMMUNITY_Date Utils & Localization|Date Utils & Localization]]
- [[_COMMUNITY_HomeSettings & Nav Destinations|Home/Settings & Nav Destinations]]
- [[_COMMUNITY_Journey Entity & Outcomes|Journey Entity & Outcomes]]
- [[_COMMUNITY_Tab Nav & Settings Sheets|Tab Nav & Settings Sheets]]
- [[_COMMUNITY_Unit & UI Tests|Unit & UI Tests]]
- [[_COMMUNITY_Practice Screen|Practice Screen]]
- [[_COMMUNITY_README Koe Na Win Practice|README: Koe Na Win Practice]]
- [[_COMMUNITY_Commitment Entity|Commitment Entity]]
- [[_COMMUNITY_Model Coding Keys|Model Coding Keys]]
- [[_COMMUNITY_Daily Progress Entity|Daily Progress Entity]]
- [[_COMMUNITY_Achievement Screen|Achievement Screen]]
- [[_COMMUNITY_App Screenshots|App Screenshots]]
- [[_COMMUNITY_Language Picker & Launch Views|Language Picker & Launch Views]]
- [[_COMMUNITY_WebView Component|WebView Component]]
- [[_COMMUNITY_Notification Service|Notification Service]]
- [[_COMMUNITY_Custom Progress Style|Custom Progress Style]]
- [[_COMMUNITY_Stage Details Disclosure|Stage Details Disclosure]]
- [[_COMMUNITY_Myanmar Digit Conversion|Myanmar Digit Conversion]]
- [[_COMMUNITY_Graphify Workflow Docs|Graphify Workflow Docs]]
- [[_COMMUNITY_Stages List Screen|Stages List Screen]]
- [[_COMMUNITY_Haptic Feedback|Haptic Feedback]]
- [[_COMMUNITY_View Extensions|View Extensions]]
- [[_COMMUNITY_App Entry Point|App Entry Point]]
- [[_COMMUNITY_Circular Progress View|Circular Progress View]]
- [[_COMMUNITY_Missed Day View|Missed Day View]]
- [[_COMMUNITY_Stage Details List Cell|Stage Details List Cell]]
- [[_COMMUNITY_Language Flag Assets|Language Flag Assets]]
- [[_COMMUNITY_UIScreenWindow Extensions|UIScreen/Window Extensions]]
- [[_COMMUNITY_Not Started View|Not Started View]]
- [[_COMMUNITY_App Icon & Logo|App Icon & Logo]]
- [[_COMMUNITY_Community 35|Community 35]]
- [[_COMMUNITY_Community 36|Community 36]]

## God Nodes (most connected - your core abstractions)
1. `JourneyService` - 32 edges
2. `JourneyScreen` - 14 edges
3. `Day` - 14 edges
4. `Journey` - 13 edges
5. `PracticeScreen` - 13 edges
6. `Commitment` - 12 edges
7. `SettingsScreen` - 11 edges
8. `TabItem` - 11 edges
9. `Router` - 11 edges
10. `DailyProgress` - 10 edges

## Surprising Connections (you probably didn't know these)
- `App Showcase Dark Theme (4 Screens)` --semantically_similar_to--> `App Showcase Light Theme (4 Screens)`  [INFERRED] [semantically similar]
  images/image2.png → images/image1.png
- `United States Flag (English)` --conceptually_related_to--> `Language Selection`  [INFERRED]
  KoeNaWin/Resources/Assets.xcassets/english.imageset/united-states-2.png → KoeNaWin/Resources/Assets.xcassets
- `Myanmar Flag` --conceptually_related_to--> `Language Selection`  [INFERRED]
  KoeNaWin/Resources/Assets.xcassets/myanmar.imageset/myanmar-2.png → KoeNaWin/Resources/Assets.xcassets
- `App Screens Scattered Mockup` --semantically_similar_to--> `App Showcase Light Theme (4 Screens)`  [INFERRED] [semantically similar]
  images/image3.png → images/image1.png
- `App Isometric Mockup with Notification` --semantically_similar_to--> `App Screens Scattered Mockup`  [INFERRED] [semantically similar]
  images/image4.png → images/image3.png

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Graphify Query Toolset** — claude_graphify_query, claude_graphify_path, claude_graphify_explain [EXTRACTED 0.95]
- **KoeNaWin App Directory Structure** — readme_models_dir, readme_features_dir, readme_resources_dir, readme_coredata_dir [EXTRACTED 0.95]
- **Daily Practice Flow** — readme_daily_practice_guidance, readme_mantra, readme_vegetarian_reminders, readme_progress_tracking [INFERRED 0.75]
- **App Navigation Flow** — images_image1_progressscreen, images_image1_countscreen, images_image1_dayslistscreen, images_image1_settingsscreen, images_image1_bottomtabbar [INFERRED 0.85]

## Communities (37 total, 3 thin omitted)

### Community 0 - "Domain Models & Constants"
Cohesion: 0.06
Nodes (42): Day, Decodable, Equatable, Hashable, Identifiable, Decoder, Int, Prayer (+34 more)

### Community 1 - "Journey Service Logic"
Cohesion: 0.13
Nodes (16): CoreDataStack, Bool, Calendar, Commitment, DailyProgress, Date, Double, Int (+8 more)

### Community 2 - "Core Data Stack & Persistence"
Cohesion: 0.08
Nodes (25): CommitmentCategory, Commitment, CommitmentCategory, custom, koeNaWin, CoreDataError, failedToSave, CoreDataStack (+17 more)

### Community 3 - "Journey Onboarding Screen"
Cohesion: 0.08
Nodes (19): Content, JourneyMode, newCommitment, onboarding, JourneyScreen, JourneyMode, AppLanguage, Bool (+11 more)

### Community 4 - "Router & App State"
Cohesion: 0.11
Nodes (13): AppTheme, KoeNaWinStage, AppLanguage, Double, Int, String, ObservableObject, Router (+5 more)

### Community 5 - "Date Utils & Localization"
Cohesion: 0.09
Nodes (20): CaseIterable, ColorScheme, Date, DateFormat, hMMa, yyyy_MMMM_d, ImageResource, AppLanguage (+12 more)

### Community 6 - "Home/Settings & Nav Destinations"
Cohesion: 0.11
Nodes (14): HomeScreen, JourneyService, KoeNaWinStore, Router, UserPreferences, CGFloat, CoreDataError, JourneyService (+6 more)

### Community 7 - "Journey Entity & Outcomes"
Cohesion: 0.11
Nodes (21): Journey, JourneyEndReason, completed, missed, none, userStopped, JourneyOutcome, abandoned (+13 more)

### Community 8 - "Tab Nav & Settings Sheets"
Cohesion: 0.11
Nodes (16): Int, LocalizedStringKey, Router, String, UserPreferences, SheetType, language, privacyPolicy (+8 more)

### Community 9 - "Unit & UI Tests"
Cohesion: 0.11
Nodes (5): KoeNaWinTests, KoeNaWinUITests, KoeNaWinUITestsLaunchTests, Bool, XCTestCase

### Community 10 - "Practice Screen"
Cohesion: 0.15
Nodes (10): ButtonStyle, Bool, CGFloat, Configuration, JourneyService, KoeNaWinStore, LocalizedStringKey, UserPreferences (+2 more)

### Community 11 - "README: Koe Na Win Practice"
Cohesion: 0.18
Nodes (16): Buddha's Nine Attributes, CoreData Persistence, Daily Practice Guidance, 81-Day Spiritual Journey, Failure Handling and Progress Reset, Features Directory, Koe Na Win Buddhist Discipline, KoeNaWin App (+8 more)

### Community 12 - "Commitment Entity"
Cohesion: 0.15
Nodes (12): Acknowledgements, Data Sources, Features, Getting Started, How It Works, Installation, KoeNaWin, License (+4 more)

### Community 13 - "Model Coding Keys"
Cohesion: 0.14
Nodes (12): CodingKey, CodingKeys, benefits, id, prayers, stage, CodingKeys, day (+4 more)

### Community 14 - "Daily Progress Entity"
Cohesion: 0.21
Nodes (12): DailyProgress, DayStatus, completed, missed, notStarted, DayStatus, Date, Int16 (+4 more)

### Community 15 - "Achievement Screen"
Cohesion: 0.19
Nodes (10): AchievementBadgeCard, AchievementExport, AchievementScreen, View, CGFloat, Int, JourneyService, Router (+2 more)

### Community 16 - "App Screenshots"
Cohesion: 0.26
Nodes (13): Bottom Tab Navigation Bar, Circular Progress Indicator, Large Count Button, Count Screen, Days List Screen, Progress Home Screen, Settings About Screen, App Showcase Light Theme (4 Screens) (+5 more)

### Community 17 - "Language Picker & Launch Views"
Cohesion: 0.22
Nodes (6): LanguagePicker, AppLanguage, Date, LaunchScreen, View, ScheduledView

### Community 18 - "WebView Component"
Cohesion: 0.25
Nodes (6): WebView, Context, String, UIView, UIViewRepresentable, UIViewType

### Community 19 - "Notification Service"
Cohesion: 0.28
Nodes (4): Bool, Date, String, NotificationService

### Community 20 - "Custom Progress Style"
Cohesion: 0.29
Nodes (6): Color, CustomProgressViewStyle, CGFloat, Configuration, View, ProgressViewStyle

### Community 21 - "Stage Details Disclosure"
Cohesion: 0.25
Nodes (6): DisclosureGroupStyle, Configuration, JourneyService, KoeNaWinStage, CustomDisclosureStyle, StageDetailsScreen

### Community 22 - "Myanmar Digit Conversion"
Cohesion: 0.46
Nodes (3): Double, Int, String

### Community 23 - "Graphify Workflow Docs"
Cohesion: 0.33
Nodes (7): GRAPH_REPORT.md, graphify explain Command, graphify path Command, graphify query Command, graphify update Command, Graphify Knowledge Graph Workflow, Graphify Wiki Index

### Community 24 - "Stages List Screen"
Cohesion: 0.33
Nodes (4): Int, KoeNaWinStore, Router, StagesScreen

### Community 25 - "Haptic Feedback"
Cohesion: 0.33
Nodes (4): Haptic, impact, notification, selection

### Community 26 - "View Extensions"
Cohesion: 0.40
Nodes (3): View, Bool, PracticeState

### Community 27 - "App Entry Point"
Cohesion: 0.50
Nodes (3): App, KoeNaWinApp, Scene

### Community 28 - "Circular Progress View"
Cohesion: 0.50
Nodes (3): CircularProgressView, CGFloat, Double

### Community 29 - "Missed Day View"
Cohesion: 0.50
Nodes (3): Date, Router, MissedDayView

### Community 30 - "Stage Details List Cell"
Cohesion: 0.50
Nodes (4): Bool, Prayer, UserPreferences, ListCell

### Community 31 - "Language Flag Assets"
Cohesion: 1.00
Nodes (3): Language Selection, United States Flag (English), Myanmar Flag

### Community 35 - "Community 35"
Cohesion: 0.17
Nodes (9): UserProgress, Data, Bundle, JSONDecoder, Date, Int16, String, T (+1 more)

### Community 36 - "Community 36"
Cohesion: 0.29
Nodes (5): Architecture, Build / Test / Run, Conventions, graphify, What this is

## Knowledge Gaps
- **196 isolated node(s):** `Double`, `CGFloat`, `Color`, `Configuration`, `View` (+191 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **3 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `TabItem` connect `Tab Nav & Settings Sheets` to `Domain Models & Constants`, `Language Picker & Launch Views`, `Date Utils & Localization`?**
  _High betweenness centrality (0.175) - this node is a cross-community bridge._
- **Why does `JSONDecoder` connect `Community 35` to `Journey Service Logic`?**
  _High betweenness centrality (0.152) - this node is a cross-community bridge._
- **Why does `NSManagedObject` connect `Core Data Stack & Persistence` to `Community 35`, `Daily Progress Entity`, `Journey Entity & Outcomes`?**
  _High betweenness centrality (0.123) - this node is a cross-community bridge._
- **What connects `Double`, `CGFloat`, `Color` to the rest of the system?**
  _196 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Domain Models & Constants` be split into smaller, more focused modules?**
  _Cohesion score 0.05603864734299517 - nodes in this community are weakly interconnected._
- **Should `Journey Service Logic` be split into smaller, more focused modules?**
  _Cohesion score 0.1253968253968254 - nodes in this community are weakly interconnected._
- **Should `Core Data Stack & Persistence` be split into smaller, more focused modules?**
  _Cohesion score 0.08064516129032258 - nodes in this community are weakly interconnected._