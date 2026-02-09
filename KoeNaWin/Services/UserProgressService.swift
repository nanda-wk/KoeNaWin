//
//  UserProgressService.swift
//  KoeNaWin
//
//  Created by Nanda Win Kyu on 2026-02-08.
//

import Foundation

@MainActor
final class UserProgressService: ObservableObject {
    @Published private(set) var practiceState: PracticeState = .notStarted
    @Published private(set) var isTodayCompleted = false

    @Published private(set) var totalCompletedDays = 0
    @Published private(set) var startDate: Date?
    private(set) var totalDays = 81
    private(set) var stage = 0
    private(set) var day = 0

    var daysRemaining: Int {
        max(0, totalDays - totalCompletedDays)
    }

    var totalProgress: Double {
        Double(totalCompletedDays) / Double(totalDays)
    }

    var currentPrayer: Prayer? {
        guard let currentStage = KoeNaWinStore.shared.stages.first(where: { $0.stage == stage }) else {
            return nil
        }
        let prayerIndex = day - 1
        guard prayerIndex >= 0, prayerIndex < currentStage.prayers.count else {
            return nil
        }
        return currentStage.prayers[prayerIndex]
    }

    private let stack: CoreDataStack
    private lazy var context = stack.viewContext
    private lazy var calendar = {
        var calendar = Calendar.current
        calendar.timeZone = .current
        return calendar
    }()

    init(stack: CoreDataStack = .shared, initialState: PracticeState? = nil) {
        self.stack = stack
        if let initialState {
            practiceState = initialState
        } else {
            refreshState()
        }
    }

    #if DEBUG
        func _setMockState(_ state: PracticeState) {
            practiceState = state
        }
    #endif

    func refreshState() {
        do {
            let today = Date.today()

            // 1️⃣ Not started yet
            guard let commitment = try fetchActiveCommitment() else {
                practiceState = .notStarted
                startDate = nil
                return
            }

            startDate = commitment.startDate
            let startDay = calendar.startOfDay(for: commitment.startDate)

            // 2️⃣ Scheduled for future
            if today < startDay {
                practiceState = .scheduled(startDate: commitment.startDate)
                return
            }

            // 3️⃣ Check for Missed Day (Automated Failure)
            if let missedDay = try firstMissedDay(commitment: commitment, today: today) {
                try saveMissedDay(for: commitment, on: missedDay)
                practiceState = .missedDay(date: missedDay)
                return
            }

            // 4️⃣ Today completed check
            isTodayCompleted = try checkIsTodayCompleted(commitment: commitment, today: today)

            // 5️⃣ Progress Calculation
            let totalCompleted = try completedDaysCount(for: commitment, before: calendar.date(byAdding: .day, value: 1, to: today)!)
            totalCompletedDays = totalCompleted
            totalDays = Int(commitment.totalDays)

            if totalCompleted >= commitment.totalDays {
                practiceState = .completedAll
                return
            }

            // Calculate current stage/day based on completion
            // stage 1: 0-8, stage 2: 9-17, etc.
            stage = (totalCompleted / 9) + 1
            day = (totalCompleted % 9) + 1

            // If already completed for today, we show "Started" state but the UI uses isTodayCompleted for indicator
            practiceState = .started
        } catch {
            practiceState = .notStarted
        }
    }

    func startNewCommitment(startDate: Date, commitmentReflection: String? = nil) throws {
        _ = Commitment.create(
            startDate: startDate,
            commitmentReflection: commitmentReflection,
            context: context
        )

        try stack.persist(in: context)
        refreshState()
    }

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
        NotificationService.shared.scheduleNotification(
            id: NotificationID.oneDayBeforeNotificationIdentifier,
            title: NotiMessage.oneDayBeforeNotificationTitle,
            subtitle: NotiMessage.oneDayBeforeNotificationBody,
            date: date,
            repeats: false
        )
    }

    func saveDailyProgress(_ date: Date = .today(), status: DailyProgressStatus) throws {
        guard let commitment = try fetchActiveCommitment() else {
            practiceState = .notStarted
            return
        }

        _ = DailyProgress.create(
            date: date,
            status: status,
            commitment: commitment,
            context: context
        )

        try stack.persist(in: context)
        refreshState()
    }

    private func saveMissedDay(for commitment: Commitment, on date: Date) throws {
        // Prevent duplicate missed day records for the same date
        let existingRequest = DailyProgress.dailyProgressFetchRequest
        existingRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "commitment == %@", commitment),
            NSPredicate(format: "date == %@", date as NSDate),
            NSPredicate(format: "statusRaw == %d", DailyProgressStatus.missed.rawValue),
        ])

        if try context.count(for: existingRequest) == 0 {
            _ = DailyProgress.create(
                date: date,
                status: .missed,
                commitment: commitment,
                context: context
            )
        }

        commitment.commitmentReflection = "Missed a day on \(date.toStringWith(format: .yyyy_MMMM_d))."
        commitment.isActive = false

        let completedTotal = try completedDaysCount(for: commitment, before: date)

        _ = PracticeJourney.create(
            startDate: commitment.startDate,
            endDate: date,
            outcome: .failed,
            completedDays: Int16(completedTotal),
            missedDays: 1, // Currently fails on first miss
            longestStreak: Int16(completedTotal),
            endReason: .missed,
            reflectionNote: "Missed a day at \(date)",
            context: context
        )

        try stack.persist(in: context)
    }
}

extension UserProgressService {
    private func fetchActiveCommitment() throws -> Commitment? {
        let request = Commitment.commitmentFetchRequest
        request.predicate = NSPredicate(format: "isActive == YES")
        request.fetchLimit = 1
        return try context.fetch(request).first
    }

    private func completedDaysCount(for commitment: Commitment, before date: Date) throws -> Int {
        let request = DailyProgress.dailyProgressFetchRequest
        request.resultType = .countResultType

        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "commitment == %@", commitment),
            NSPredicate(format: "statusRaw == %d", DailyProgressStatus.completed.rawValue),
            NSPredicate(format: "date < %@", date as NSDate),
        ])

        return try context.count(for: request)
    }

    private func completedDates(for commitment: Commitment, before date: Date) throws -> Set<Date> {
        let request = DailyProgress.dailyProgressFetchRequest
        request.resultType = .dictionaryResultType
        request.propertiesToFetch = ["date"]

        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "commitment == %@", commitment),
            NSPredicate(format: "statusRaw == %d", DailyProgressStatus.completed.rawValue),
            NSPredicate(format: "date < %@", date as NSDate),
        ])

        let results = try context.fetch(request) as? [[String: Any]] ?? []

        return Set(results.compactMap {
            guard let date = $0["date"] as? Date else { return nil }
            return calendar.startOfDay(for: date)
        })
    }

    private func firstMissedDay(commitment: Commitment, today: Date) throws -> Date? {
        let startDay = calendar.startOfDay(for: commitment.startDate)
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!

        if yesterday < startDay {
            return nil
        }

        let completed = try completedDates(
            for: commitment,
            before: today
        )

        var current = startDay
        while current <= yesterday {
            if !completed.contains(current) {
                return current
            }
            current = calendar.date(byAdding: .day, value: 1, to: current)!
        }

        return nil
    }

    private func checkIsTodayCompleted(commitment: Commitment, today: Date) throws -> Bool {
        let start = calendar.startOfDay(for: today)
        let end = calendar.date(byAdding: .day, value: 1, to: start) ?? start

        let request = DailyProgress.dailyProgressFetchRequest
        request.fetchLimit = 1

        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "commitment == %@", commitment),
            NSPredicate(format: "statusRaw == %d", DailyProgressStatus.completed.rawValue),
            NSPredicate(format: "date >= %@ AND date < %@", start as NSDate, end as NSDate),
        ])

        return try context.count(for: request) > 0
    }
}
