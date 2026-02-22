//
//  JourneyService.swift
//  KoeNaWin
//
//  Created by Nanda Win Kyu on 2026-02-12.
//

import Combine
import CoreData
import Foundation

@MainActor
final class JourneyService: ObservableObject {
    @Published private(set) var activeJourney: Journey?
    @Published private(set) var todayProgress: DailyProgress?

    @Published private(set) var practiceState: PracticeState = .notStarted
    @Published private(set) var isTodayCompleted = false
    @Published private(set) var totalCompletedDays = 0
    @Published private(set) var startDate: Date?
    @Published private(set) var totalDays = 81
    @Published private(set) var stage = 0
    @Published private(set) var day = 0
    @Published private(set) var displayStage = 0
    @Published private(set) var displayDay = 0
    @Published private(set) var vegetarianDayIn = 0

    var daysRemaining: Int {
        max(0, totalDays - totalCompletedDays)
    }

    var totalProgress: Double {
        totalDays > 0 ? Double(totalCompletedDays) / Double(totalDays) : 0
    }

    var currentStage: KoeNaWinStage? {
        KoeNaWinStore.shared.stages.first(where: { $0.stage == displayStage })
    }

    var currentPrayer: Prayer? {
        guard let currentStage else { return nil }
        let prayerIndex = displayDay
        guard prayerIndex >= 0, prayerIndex < currentStage.prayers.count else {
            return nil
        }
        return currentStage.prayers[prayerIndex]
    }

    private let stack: CoreDataStack
    private var context: NSManagedObjectContext { stack.viewContext }

    private let calendar: Calendar = .current

    init(stack: CoreDataStack = .shared) {
        self.stack = stack
        ensureKoeNaWinCommitmentExists()
        refreshState()
    }

    func refreshActiveJourney() {
        let request = Journey.journeyFetchRequest
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Journey.createdAt, ascending: false)]
        request.fetchLimit = 1

        do {
            activeJourney = try context.fetch(request).first
        } catch {
            print("Failed to fetch active journey: \(error)")
            activeJourney = nil
        }
    }

    func refreshState() {
        refreshActiveJourney()
        resolveDailyState()
        updateUISyncProperties()
    }

    private func updateUISyncProperties() {
        guard let journey = activeJourney else {
            practiceState = .notStarted
            startDate = nil
            isTodayCompleted = false
            totalCompletedDays = 0
            totalDays = 81
            stage = 0
            day = 0
            return
        }

        startDate = journey.startDate
        totalDays = Int(journey.commitment.totalDays)
        totalCompletedDays = Int(journey.completedDays)

        // Resolve PracticeState
        let today = Date.today()
        let journeyStart = journey.startDate.startOfDay()

        if journey.outcome == .succeeded {
            practiceState = .completedAll
        } else if journey.outcome == .failed || journey.outcome == .abandoned {
            if let firstMiss = journey.dailyProgress.sorted(by: { $0.dayNumber < $1.dayNumber }).first(where: { $0.status == .missed }) {
                practiceState = .missedDay(date: firstMiss.date)
            } else {
                practiceState = .started
            }
        } else if today < journeyStart {
            practiceState = .scheduled(startDate: journey.startDate)
        } else {
            practiceState = .started
        }

        isTodayCompleted = todayProgress?.status == .completed

        // Calculate stage and day (Actual Progress)
        if journey.outcome == .inProgress {
            stage = (totalCompletedDays / 9) + 1
            day = (totalCompletedDays % 9)

            let effectiveCompletedDays = isTodayCompleted ? max(0, totalCompletedDays - 1) : totalCompletedDays
            displayStage = (effectiveCompletedDays / 9) + 1
            displayDay = (effectiveCompletedDays % 9)
        } else if journey.outcome == .succeeded {
            stage = 9
            day = 9
            displayStage = 9
            displayDay = 9
        }

        if stage < 9 || (stage == 9 && day < 5) {
            vegetarianDayIn = day > 5 ? (9 - day) + 5 : 5 - day
        }
    }

    func dayIndex(for journey: Journey, at date: Date = .today()) -> Int16 {
        let components = calendar.dateComponents([.day], from: journey.startDate, to: date)
        let days = Int16(components.day ?? 0)
        if days <= 0 {
            return 0
        }
        return days
    }

    func resolveDailyState() {
        guard let journey = activeJourney else {
            todayProgress = nil
            return
        }

        detectMissedDays()

        guard journey.outcome == .inProgress else {
            todayProgress = nil
            return
        }

        let currentDayIndex = dayIndex(for: journey)

        // Fetch or create today's progress
        let request = DailyProgress.dailyProgressFetchRequest
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "journey == %@", journey),
            NSPredicate(format: "dayNumber == %d", currentDayIndex),
        ])

        do {
            if let existing = try context.fetch(request).first {
                todayProgress = existing
            } else {
                // If we haven't reached the total days requirement, create a new record
                if currentDayIndex < journey.commitment.totalDays {
                    let newDay = DailyProgress.create(
                        dayNumber: currentDayIndex,
                        date: .today(),
                        status: .notStarted,
                        journey: journey,
                        context: context
                    )
                    try stack.persist(in: context)
                    todayProgress = newDay
                }
            }
        } catch {
            print("Failed to resolve daily state: \(error)")
        }
    }

    func detectMissedDays() {
        guard let journey = activeJourney else { return }
        let currentDayIndex = dayIndex(for: journey)

        do {
            let request = DailyProgress.dailyProgressFetchRequest
            request.predicate = NSPredicate(format: "journey == %@", journey)
            let existingProgress = try context.fetch(request)
            let existingDayNumbers = Set(existingProgress.map(\.dayNumber))

            var createdAny = false
            for dayIndex in 0 ..< currentDayIndex {
                if !existingDayNumbers.contains(dayIndex) {
                    guard let date = calendar.date(
                        byAdding: .day,
                        value: Int(dayIndex),
                        to: journey.startDate.startOfDay()
                    ) else { continue }
                    DailyProgress.create(
                        dayNumber: dayIndex,
                        date: date,
                        status: .missed,
                        journey: journey,
                        context: context
                    )
                    createdAny = true
                }
            }

            for progress in existingProgress where progress.dayNumber < currentDayIndex && progress.status == .notStarted {
                progress.status = .missed
                createdAny = true
            }

            if createdAny {
                journey.outcome = .failed
                journey.endedReason = .missed
                journey.endDate = .today()

                try stack.persist(in: context)

                context.refresh(journey, mergeChanges: true)
            }
        } catch {
            print("Failed to detect missed days: \(error)")
        }
    }

    func completeToday() throws {
        guard let journey = activeJourney, let progress = todayProgress else { return }

        progress.status = .completed
        progress.completedAt = .now

        // Update journey stats
        updateJourneyStats(journey)

        let currentIndex = dayIndex(for: journey)
        if currentIndex >= Int(journey.commitment.totalDays) - 1 {
            journey.outcome = .succeeded
            journey.endDate = .today()
            journey.endedReason = .completed
        }

        try stack.persist(in: context)
        refreshState()
    }

    private func updateJourneyStats(_ journey: Journey) {
        do {
            let request = DailyProgress.dailyProgressFetchRequest
            request.predicate = NSPredicate(format: "journey == %@", journey)
            let allProgress = try context.fetch(request).sorted { $0.dayNumber < $1.dayNumber }

            journey.completedDays = Int16(allProgress.filter { $0.status == .completed }.count)
            journey.missedDays = Int16(allProgress.filter { $0.status == .missed }.count)
            journey.longestStreak = Int16(calculateLongestStreak(from: allProgress))
        } catch {
            print("Failed to update journey stats: \(error)")
        }
    }

    private func calculateLongestStreak(from progress: [DailyProgress]) -> Int {
        var maxStreak = 0
        var currentStreak = 0

        for p in progress {
            if p.status == .completed {
                currentStreak += 1
                maxStreak = max(maxStreak, currentStreak)
            } else if p.status == .missed {
                currentStreak = 0
            }
        }
        return maxStreak
    }

    private func backfillCompletedDays(for journey: Journey) {
        let currentDayIndex = dayIndex(for: journey)
        if currentDayIndex <= 0 { return }

        for dayIndex in 0 ..< currentDayIndex {
            guard let date = calendar.date(
                byAdding: .day,
                value: Int(dayIndex),
                to: journey.startDate.startOfDay()
            ) else { continue }
            DailyProgress.create(
                dayNumber: dayIndex,
                date: date,
                status: .completed,
                journey: journey,
                context: context
            )
        }

        updateJourneyStats(journey)
    }

    private func ensureKoeNaWinCommitmentExists() {
        let request = Commitment.commitmentFetchRequest
        request.predicate = NSPredicate(format: "categoryRaw == %d", CommitmentCategory.koeNaWin.rawValue)
        request.fetchLimit = 1

        do {
            if try context.fetch(request).first == nil {
                Commitment.create(
                    totalDays: 81,
                    category: .koeNaWin,
                    context: context
                )
                try stack.persist(in: context)
            }
        } catch {
            print("Failed to ensure KoeNaWin commitment: \(error)")
        }
    }

    private func getOrCreateKoeNaWinCommitment() throws -> Commitment {
        let request = Commitment.commitmentFetchRequest
        request.predicate = NSPredicate(format: "categoryRaw == %d", CommitmentCategory.koeNaWin.rawValue)
        request.fetchLimit = 1

        if let existing = try context.fetch(request).first {
            return existing
        }

        let commitment = Commitment.create(
            totalDays: 81,
            category: .koeNaWin,
            context: context
        )
        try stack.persist(in: context)
        return commitment
    }

    func startNewJourney(startDate: Date, reflection: String? = nil) throws {
        let commitment = try getOrCreateKoeNaWinCommitment()

        if let reflection {
            commitment.reflection = reflection
        }

        if startDate > Date.today() {
            setNewCommitmentReminder(startDate)
        }

        try startNewJourney(for: commitment, startDate: startDate)
    }

    func startNewJourney(for commitment: Commitment, startDate: Date? = nil) throws {
        // Abandon any existing journey
        if let current = activeJourney, current.outcome == .inProgress {
            current.outcome = .abandoned
            current.endDate = .today()
            current.endedReasonRaw = JourneyEndReason.userStopped.rawValue
        }

        let journey = Journey.create(
            startDate: startDate?.startOfDay() ?? .today(),
            outcome: .inProgress,
            commitment: commitment,
            context: context
        )

        backfillCompletedDays(for: journey)

        try stack.persist(in: context)
        refreshState()
    }

    // MARK: - Notifications

    func setDailyReminder(_ date: Date) {
        NotificationService.shared.cancelNotification(id: NotificationID.scheduleNotificationIdentifier)
        NotificationService.shared.scheduleNotification(
            id: NotificationID.scheduleNotificationIdentifier,
            title: NotiMessage.scheduleNotificationTitle,
            subtitle: NotiMessage.scheduleNotificationBody,
            date: date,
            repeats: true
        )
    }

    func setNewCommitmentReminder(_ date: Date) {
        NotificationService.shared.cancelNotification(id: NotificationID.oneDayBeforeNotificationIdentifier)
        var component = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        component.day = (component.day ?? 1) - 1
        component.hour = 14
        component.minute = 0
        let reminderDate = calendar.date(from: component) ?? date
        NotificationService.shared.scheduleNotification(
            id: NotificationID.oneDayBeforeNotificationIdentifier,
            title: NotiMessage.oneDayBeforeNotificationTitle,
            subtitle: NotiMessage.oneDayBeforeNotificationBody,
            date: reminderDate,
            repeats: false
        )
    }

    #if DEBUG

        // MARK: - Previews

        func setupForPreview(state: PracticeState) {
            practiceState = state
            switch state {
            case .started:
                totalCompletedDays = 12
                stage = 2
                day = 4
                isTodayCompleted = false
                vegetarianDayIn = 1
            case .notStarted:
                totalCompletedDays = 0
                stage = 0
                day = 0
                isTodayCompleted = false
            case let .scheduled(startDate):
                self.startDate = startDate
                totalCompletedDays = 0
                stage = 0
                day = 0
                isTodayCompleted = false
            case .missedDay:
                totalCompletedDays = 5
                stage = 1
                day = 6
                isTodayCompleted = false
            case .completedAll:
                totalCompletedDays = 81
                stage = 9
                day = 9
                isTodayCompleted = true
            }
        }
    #endif
}
