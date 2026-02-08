//
//  UserProgressService.swift
//  KoeNaWin
//
//  Created by Nanda Win Kyu on 2026-02-08.
//

import Foundation

@MainActor
final class UserProgressService: ObservableObject {
    @Published private(set) var practiceState: PracticeState? = nil

    private let stack: CoreDataStack
    private lazy var context = stack.viewContext
    private lazy var calendar = {
        var calendar = Calendar.current
        calendar.timeZone = .current
        return calendar
    }()

    init(stack: CoreDataStack = .shared) {
        self.stack = stack
    }

    func checkUserProgress() {
        do {
            let today = Date.today()

            // 1️⃣ Not started yet
            guard let commitment = try fetchActiveCommitment() else {
                practiceState = .notStarted
                return
            }

            let startDay = calendar.startOfDay(for: commitment.startDate)

            // 2️⃣ Scheduled for
            if today < startDay {
                practiceState = .scheduled(startDate: commitment.startDate)
                return
            }

            // 3️⃣ All completed
            let completedTotal = try completedDaysCount(
                for: commitment,
                before: calendar.date(byAdding: .day, value: 1, to: today)!
            )

            if completedTotal >= commitment.totalDays {
                practiceState = .completedAll
                return
            }

            // 4️⃣ Today completed?
            if try isTodayCompleted(commitment: commitment, today: today) {
                practiceState = .completedToday
                return
            }

            // 5️⃣ Find first missed past day
            if let missedDay = try firstMissedDay(
                commitment: commitment,
                today: today
            ) {
                practiceState = .missedDay(missedDay)
                return
            }

            practiceState = .inProgressToday
        } catch {
            practiceState = nil
        }
    }

    func startNewCommitment(startDate: Date, commitmentReflection: String? = nil) throws {
        let commitment = Commitment.create(
            startDate: startDate,
            commitmentReflection: commitmentReflection,
            context: context
        )

        let context = commitment.managedObjectContext ?? context

        try stack.persist(in: context)
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
}

extension UserProgressService {
    private func fetchActiveCommitment() throws -> Commitment? {
        let request = Commitment.commitmentFetchRequest
        request.predicate = NSPredicate(format: "isActive == YES")
        request.fetchLimit = 1
        return try context.fetch(request).first
    }

    private func completedDaysCount(
        for commitment: Commitment,
        before date: Date
    ) throws -> Int {
        let request = DailyProgress.dailyProgressFetchRequest
        request.resultType = .countResultType

        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "commitment == %@", commitment),
            NSPredicate(format: "statusRaw == %d", DailyProgressStatus.completed.rawValue),
            NSPredicate(format: "date < %@", date as NSDate),
        ])

        return try context.count(for: request)
    }

    private func completedDates(
        for commitment: Commitment,
        before date: Date
    ) throws -> Set<Date> {
        let request = DailyProgress.dailyProgressFetchRequest
        request.resultType = .dictionaryResultType
        request.propertiesToFetch = ["date"]

        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "commitment == %@", commitment),
            NSPredicate(format: "statusRaw == %d", DailyProgressStatus.completed.rawValue),
            NSPredicate(format: "date < %@", date as NSDate),
        ])

        let results = try context.fetch(request) as! [[String: Date]]

        return Set(results.map {
            calendar.startOfDay(for: $0["date"]!)
        })
    }

    private func firstMissedDay(
        commitment: Commitment,
        today: Date
    ) throws -> Date? {
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

    private func isTodayCompleted(
        commitment: Commitment,
        today: Date
    ) throws -> Bool {
        let start = today
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
