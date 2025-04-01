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

    private let calendar = Calendar.current

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

    private func loadCompletedDays() -> [Date] {
        let request = CompletedDay.latest()
        var result = [Date]()
        do {
            let data = try context.fetch(request)

            result = data.map(\.date)
        } catch {
            print("Failed to fetch completed days: \(error)")
        }

        return result
    }

    private func saveUserProgress(_ userProgress: UserProgress) {
        let context = userProgress.managedObjectContext ?? context
        do {
            try stack.persist(in: context)
        } catch {
            print("Failed to save user progress: \(error)")
        }
    }

    private func saveCompletedDay(_ date: CompletedDay) {
        let context = date.managedObjectContext ?? context
        do {
            try stack.persist(in: context)
        } catch {
            print("Failed to save completed day: \(error)")
        }
    }

    private func saveFailureRecord(_ record: FailureRecord) {
        let context = record.managedObjectContext ?? context
        do {
            try stack.persist(in: context)
        } catch {
            print("Failed to save failure record: \(error)")
        }
    }

    private func saveFailureRecord(startDate: Date, failureDate: Date, stage: Int16, day: Int16) {
        let record = FailureRecord(context: context)
        record.startDate = startDate
        record.failureDate = failureDate
        record.stage = stage
        record.day = day

        let context = record.managedObjectContext ?? context
        do {
            try stack.persist(in: context)
            try stack.deleteAll(CompletedDay.self)
            try stack.deleteAll(UserProgress.self)
        } catch {
            print("Failed to save failure record: \(error)")
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
        let completedDays = loadCompletedDays()

        // Check for missed days
        for i in 0 ..< daysSinceStart {
            let checkDate = calendar.date(byAdding: .day, value: i, to: progress.startDate)!
            if !completedDays.contains(where: { calendar.isDate($0, inSameDayAs: checkDate) }) {
                saveFailureRecord(
                    startDate: checkDate,
                    failureDate: progress.startDate,
                    stage: progress.currentStage,
                    day: progress.dayOfStage
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
            progressPublisher.send(.completed)
            resetPracitceCount()
        }
    }

    func markTodayAsCompleted() {
        guard let progress = loadUserProgress() else { return }

        let completedDay = CompletedDay(context: context)
        completedDay.date = Date.now
        saveCompletedDay(completedDay)

        progress.dayOfStage += 1
        if progress.dayOfStage > 9 {
            progress.currentStage += 1
            progress.dayOfStage = 1
        }
        saveUserProgress(progress)

        resetPracitceCount()

        // Refresh progress after marking today as completed
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

        let userProgress = UserProgress(context: context)
        userProgress.startDate = Date.now
        userProgress.currentStage = 1
        userProgress.dayOfStage = 0
        resetPracitceCount()
        saveUserProgress(userProgress)
        checkProgress()
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
