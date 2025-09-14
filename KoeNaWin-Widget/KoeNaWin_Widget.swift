//
//  KoeNaWin_Widget.swift
//  KoeNaWin-Widget
//
//  Created by Nanda WK on 2025-07-29.
//

import SwiftUI
import WidgetKit

struct WidgetPrayer: Decodable, Hashable {
    let day: String
    let mantra: String
    let rounds: Int
}

struct WidgetStage: Decodable, Hashable {
    let prayers: [WidgetPrayer]
}

enum ProgressStatus {
    case notStarted
    case inProgress(WidgetPrayer)
    case todayCompleted
    case missed
    case completed
}

struct Provider: TimelineProvider {
    // 2. Create a function to load and decode the JSON data.
    private func loadPrayerData() -> [WidgetStage] {
        // Ensure the JSON file is included in the Widget's target membership.
        guard let url = Bundle.main.url(forResource: "KoeNaWin", withExtension: "json") else {
            fatalError("KoeNaWin.json not found in the widget bundle.")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load KoeNaWin.json.")
        }
        do {
            // Decode the array of stages using our lightweight structs.
            return try JSONDecoder().decode([WidgetStage].self, from: data)
        } catch {
            fatalError("Failed to decode KoeNaWin.json: \(error)")
        }
    }

    func placeholder(in _: Context) -> WidgetEntry {
        WidgetEntry(date: .now, status: .notStarted)
    }

    func getSnapshot(in _: Context, completion: @escaping (WidgetEntry) -> Void) {
        // Provide a sample snapshot.
        let progress = WidgetPrayer(day: "Tuesday", mantra: "သမ္မာသမ္ဗုဒ္ဓေါ", rounds: 2)
        let entry = WidgetEntry(date: .now, status: .inProgress(progress))
        completion(entry)
    }

    func getTimeline(in _: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        // This is where you'll determine the current state and create the timeline.
//        let allStages = loadPrayerData()
        let allStages = Bundle.main.decode([WidgetStage].self, from: "KoeNaWin.json")
        let currentStatus = getCurrentState(from: allStages)

        let entry = WidgetEntry(date: .now, status: currentStatus)

        // Create a timeline that refreshes at the start of the next day.
        let nextUpdateDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        completion(timeline)
    }

    // 3. Logic to determine the current state and get the correct prayer.
    private func getCurrentState(from allStages: [WidgetStage]) -> ProgressStatus {
        let stack: CoreDataStack = .shared
        let context = stack.viewContext
        let calendar = Calendar.current

        guard let progress = try? context.fetch(UserProgress.latest()).first else {
            return .notStarted
        }

        let today = calendar.startOfDay(for: Date.now)
        let startDate = calendar.startOfDay(for: progress.startDate)

        let completedDaysSet = Set(progress.completedDaysArray.map { calendar.startOfDay(for: $0) })

        // Check for missed days
        var dateToVerify = startDate
        while dateToVerify < today {
            if !completedDaysSet.contains(dateToVerify) {
                return .missed
            }
            dateToVerify = calendar.date(byAdding: .day, value: 1, to: dateToVerify)!
        }

        // Check if today is already completed
        if completedDaysSet.contains(today) {
            return .todayCompleted
        }

        // Calculate current stage and day index
        let daysSinceStart = calendar.dateComponents([.day], from: startDate, to: today).day ?? 0
        let stageIndex = daysSinceStart / 9
        let dayIndex = daysSinceStart % 9

        // Safely access the prayer data
        guard stageIndex < allStages.count, dayIndex < allStages[stageIndex].prayers.count else {
            return .completed // Assumes all stages are finished
        }

        let prayer = allStages[stageIndex].prayers[dayIndex]
        return .inProgress(prayer)
    }
}

// Update SimpleEntry to hold the data your widget view needs
struct WidgetEntry: TimelineEntry {
    let date: Date
    let status: ProgressStatus
}

struct KoeNaWin_WidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            SystemSmallView(entry: entry)
        case .accessoryRectangular:
            AccessoryRectangularView(entry: entry)
        default:
            // Fallback for any other future families
            SystemSmallView(entry: entry)
        }
    }
}

// A view for the Home Screen widget
struct SystemSmallView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            switch entry.status {
            case .notStarted:
                Text("Start your Adhitthan!")
            case let .inProgress(prayer):
                Text("Today's Mantra")
                    .font(.headline)
                Text(prayer.mantra)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Text("Bead count: \(prayer.rounds)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            case .todayCompleted:
                Text("Today Completed!")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.largeTitle)
            case .missed:
                Text("Adhitthan Missed")
                    .font(.headline)
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.red)
                    .font(.largeTitle)
            case .completed:
                Text("Congratulations!")
                    .font(.headline)
                Image(systemName: "party.popper.fill")
                    .foregroundStyle(.orange)
                    .font(.largeTitle)
            }
        }
    }
}

// A view for the Lock Screen widget
struct AccessoryRectangularView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            switch entry.status {
            case .notStarted:
                Text("Start your Adhitthan!")
            case let .inProgress(prayer):
                Text("Today's Mantra")
                Text(prayer.mantra)
                    .font(.headline)
                    .widgetAccentable()
            case .todayCompleted:
                Label("Today Completed!", systemImage: "checkmark.circle.fill")
                    .widgetAccentable()
            case .missed:
                Label("Adhitthan Missed", systemImage: "exclamationmark.triangle.fill")
            case .completed:
                Label("Adhitthan Finished!", systemImage: "party.popper.fill")
                    .widgetAccentable()
            }
        }
    }
}

struct KoeNaWin_Widget: Widget {
    let kind: String = "KoeNaWin_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            KoeNaWin_WidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("KoeNaWin Adhitthan")
        .description("Track your daily Adhitthan progress.")
        // 1. Specify the supported families
        .supportedFamilies([
            .systemSmall,
            .accessoryRectangular,
        ])
    }
}

#Preview(as: .systemSmall) {
    KoeNaWin_Widget()
} timeline: {
    WidgetEntry(date: .now, status: .inProgress(.init(day: "Monday", mantra: "အနုတ္တရောပုရိသဓမ္မသာရထိ", rounds: 4)))
    WidgetEntry(date: .now, status: .todayCompleted)
}

#Preview(as: .accessoryCircular) {
    KoeNaWin_Widget()
} timeline: {
    WidgetEntry(date: .now, status: .inProgress(.init(day: "Monday", mantra: "သတ္ထာဒေဝမနုဿာနံ", rounds: 4)))
    WidgetEntry(date: .now, status: .todayCompleted)
}
