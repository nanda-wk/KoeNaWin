//
//  KoeNaWinRepository.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import Combine
import CoreData
import Foundation

enum ProgressStatus: Equatable {
    case active(progress: UserProgress, prayer: Prayer, dayUntilVegetarian: Int, todayCompleted: Bool)
    case missedDay(failureDate: Date)
    case completed
    case notStarted
    case notMonday(nextMonday: Date)
}

final class KoeNaWinRepository {
    private let stack = CoreDataStack.shared
    private lazy var context = stack.viewContext

    private let calendar: Calendar = {
        var cal = Calendar.current
        cal.timeZone = TimeZone.current
        return cal
    }()

    private(set) var progressPublisher = CurrentValueSubject<ProgressStatus, Never>(.notStarted)

    private func loadUserProgress() -> UserProgress? {
        let request = UserProgress.latest()
        do {
            return try context.fetch(request).first
        } catch {
            print("Failed to fetch user progress: \(error)")
        }
        return nil
    }

    private func saveUserProgress(_ userProgress: UserProgress) {
        let context = userProgress.managedObjectContext ?? context
        do {
            try stack.persist(in: context)
        } catch {
            print("Failed to save user progress: \(error)")
        }
    }

    private func saveUserRecord(
        startDate: Date,
        endDate: Date,
        stage: Int16,
        day: Int16,
        status: Status
    ) {
        let record = UserRecord(context: context)
        record.startDate = startDate
        record.endDate = endDate
        record.stage = stage
        record.day = day
        record.status = status.rawValue

        let context = record.managedObjectContext ?? context
        do {
            try stack.persist(in: context)
        } catch {
            print("Failed to save user record: \(error)")
        }
    }
}

extension KoeNaWinRepository {
    func checkProgress() {
        guard let progress = loadUserProgress() else {
            progressPublisher.send(.notStarted)
            return
        }

        let today = Date.now
        let daysSinceStart = calendar.dateComponents([.day], from: progress.startDate, to: today).day ?? 0
        let completedDays = progress.completedDaysArray

        // Check for missed days
        for i in 0 ..< daysSinceStart {
            let checkDate = calendar.date(byAdding: .day, value: i, to: progress.startDate)!
            if !completedDays.contains(where: { calendar.isDate($0, inSameDayAs: checkDate) }) {
                saveUserRecord(
                    startDate: progress.startDate,
                    endDate: checkDate,
                    stage: progress.currentStage,
                    day: progress.dayOfStage,
                    status: .fail
                )
                progressPublisher.send(.missedDay(failureDate: checkDate))
                resetPracitceCount()
                return
            }
        }

        // Calculate current progress
        let totalDay = daysSinceStart + 1
        let stageIndex = (totalDay - 1) / 9
        let dayInStage = (totalDay - 1) % 9

        if stageIndex < koeNaWinStages.count, dayInStage < koeNaWinStages[stageIndex].prayers.count {
            let currentPrayer = koeNaWinStages[stageIndex].prayers[dayInStage]
            let todayCompleted = completedDays.contains(where: { calendar.isDate($0, inSameDayAs: today) })
            let dayUntilVegetarian = calculateDaysUntilVegetarian(dayInStage: dayInStage + 1)
            progressPublisher.send(.active(progress: progress, prayer: currentPrayer, dayUntilVegetarian: dayUntilVegetarian, todayCompleted: todayCompleted))
            if todayCompleted {
                resetPracitceCount()
            }
        } else {
            saveUserRecord(
                startDate: progress.startDate,
                endDate: today,
                stage: progress.currentStage,
                day: progress.dayOfStage,
                status: .complete
            )
            progressPublisher.send(.completed)
            resetPracitceCount()
        }
    }

    func markTodayAsCompleted() {
        guard let progress = loadUserProgress() else { return }

        var completedDays = progress.completedDaysArray
        completedDays.append(Date.now)

        progress.completedDaysArray = completedDays

        progress.dayOfStage += 1
        if progress.dayOfStage > 9 {
            progress.currentStage += 1
            progress.dayOfStage = 1
        }
        saveUserProgress(progress)

        resetPracitceCount()

        checkProgress()
    }

    func startNewProgress() {
        let today = Date.now
        let weekday = calendar.component(.weekday, from: today)

        if weekday != 2 {
            let nextMonday = calendar.nextDate(after: today, matching: DateComponents(weekday: 2), matchingPolicy: .nextTime)!
            progressPublisher.send(.notMonday(nextMonday: nextMonday))
            resetPracitceCount()
            return
        }

        do {
            try stack.deleteAll(UserProgress.self)
        } catch {
            print("Failed to delete completed days or user progress")
        }

        let userProgress = UserProgress(context: context)
        userProgress.startDate = Date.now
        userProgress.currentStage = 1
        userProgress.dayOfStage = 0
        userProgress.completedDaysArray = []
        resetPracitceCount()
        saveUserProgress(userProgress)
        checkProgress()
    }

    func changeStartDate(_ date: Date) {
        let progress = loadUserProgress()

        if let progress, calendar.isDate(date, inSameDayAs: progress.startDate) {
            return
        }

        let today = Date.now
        let daysSinceStart = calendar.dateComponents([.day], from: date, to: today).day ?? 0

        let newProgress = progress ?? UserProgress(context: context)

        newProgress.startDate = date
        newProgress.currentStage = Int16(((daysSinceStart - 1) / 9) + 1)
        newProgress.dayOfStage = Int16(((daysSinceStart - 1) % 9) + 1)

        var completedDates: [Date] = []
        for i in 0 ..< daysSinceStart {
            if let dayDate = calendar.date(byAdding: .day, value: i, to: date) {
                completedDates.append(dayDate)
            }
        }
        newProgress.completedDaysArray = completedDates
        saveUserProgress(newProgress)
        resetPracitceCount()
    }

    private func calculateDaysUntilVegetarian(dayInStage: Int) -> Int {
        var day = 0

        if dayInStage <= 5 {
            day = 5 - dayInStage
        } else {
            day = 9 - (dayInStage - 5)
        }

        return day
    }

    private func resetPracitceCount() {
        UserDefaults.standard.set(0, forKey: "count")
        UserDefaults.standard.set(0, forKey: "round")
    }
}
