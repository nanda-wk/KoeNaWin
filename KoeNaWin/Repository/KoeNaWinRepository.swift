//
//  KoeNaWinRepository.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import Combine
import CoreData
import Foundation
import SwiftUI
import UserNotifications

enum ProgressStatus: Equatable {
    case active(progress: UserProgress, prayer: Prayer, dayUntilVegetarian: Int, todayCompleted: Bool)
    case missedDay(failureDate: Date)
    case completed
    case notStarted
    case notMonday(nextMonday: Date)
    case willStart(date: Date)
}

final class KoeNaWinRepository {
    private let stack: CoreDataStack
    private lazy var context = stack.viewContext
    private let notificationEndDateKey = "koenawin-notification-end-date"
    private let dailyReminderNotificationIdentifier = "koenawin-daily-reminder"
    private let beforeStartNotificationIdentifier = "koenawin-before-start"

    private let calendar: Calendar = {
        var cal = Calendar.current
        cal.timeZone = TimeZone.current
        return cal
    }()

    private(set) var progressPublisher = CurrentValueSubject<ProgressStatus, Never>(.notStarted)

    init(coreDataStack: CoreDataStack = CoreDataStack.shared) {
        stack = coreDataStack
    }

    func loadUserProgress() -> UserProgress? {
        let request = UserProgress.latest()
        do {
            return try context.fetch(request).first
        } catch {
            print("Failed to fetch user progress: \(error)")
        }
        return nil
    }

    func loadUserRecords() -> [UserRecord] {
        let request = UserRecord.latest()
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch user records: \(error)")
        }
        return []
    }

    func saveUserProgress(_ userProgress: UserProgress) {
        let context = userProgress.managedObjectContext ?? context
        do {
            try stack.persist(in: context)
        } catch {
            print("Failed to save user progress: \(error)")
        }
    }

    func saveUserRecord(
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

        if progress.startDate > today {
            progressPublisher.send(.willStart(date: progress.startDate))
            return
        }

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
            removeAllNotification()
            resetPracitceCount()
        }
    }

    func markTodayAsCompleted() {
        guard let progress = loadUserProgress() else { return }

        let today = Date.now

        var completedDays = progress.completedDaysArray
        completedDays.append(today)

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

    func startNewProgress(date: Date = .now) {
        let today = date
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

        var dateComponents = calendar.dateComponents([.year, .month, .day], from: today)
        dateComponents.hour = 20
        dateComponents.minute = 0

        let reminder = calendar.date(from: dateComponents) ?? today

        let userProgress = UserProgress(context: context)
        userProgress.startDate = today
        userProgress.currentStage = 1
        userProgress.dayOfStage = 0
        userProgress.completedDaysArray = []
        userProgress.reminder = reminder

        resetPracitceCount()
        saveUserProgress(userProgress)
        scheduleNotification(from: today, body: "ယနေ့ အဓိဌာန်ကို မမေ့ပါနဲ့", repeats: true, identifier: dailyReminderNotificationIdentifier)
        checkProgress()
    }

    func changeStartDate(_ date: Date) {
        let progress = loadUserProgress()

        if let progress, calendar.isDate(date, inSameDayAs: progress.startDate) {
            return
        }

        let today = Date.now
        let newProgress = progress ?? UserProgress(context: context)

        if date < today {
            let daysSinceStart = calendar.dateComponents([.day], from: date, to: today).day ?? 0
            var dateComponents = calendar.dateComponents([.year, .month, .day], from: today)
            dateComponents.hour = 20
            dateComponents.minute = 0

            let reminder = calendar.date(from: dateComponents) ?? today

            var completedDates: [Date] = []
            for i in 0 ..< daysSinceStart {
                if let dayDate = calendar.date(byAdding: .day, value: i, to: date) {
                    completedDates.append(dayDate)
                }
            }

            newProgress.startDate = date
            newProgress.currentStage = Int16(((daysSinceStart - 1) / 9) + 1)
            newProgress.dayOfStage = Int16(((daysSinceStart - 1) % 9) + 1)
            newProgress.completedDaysArray = completedDates
            newProgress.reminder = reminder
            changeReminderDate(newProgress.reminder)
        } else {
            newProgress.startDate = date
            newProgress.currentStage = 0
            newProgress.dayOfStage = 0
            newProgress.completedDaysArray = []
            newProgress.reminder = date
            scheduleNotification(from: date, hour: 10, body: "ဒီနေ့ အဓိဌာန် စဝင်ရန်။", identifier: beforeStartNotificationIdentifier)
        }

        saveUserProgress(newProgress)
        resetPracitceCount()
        checkProgress()
    }

    func changeReminderDate(_ date: Date) {
        let progress = loadUserProgress()

        let newDateComponents = calendar.dateComponents([.hour, .minute], from: date)

        guard let progress, newDateComponents != calendar.dateComponents([.hour, .minute], from: progress.reminder) else {
            return
        }

        progress.reminder = date
        saveUserProgress(progress)
        scheduleNotification(from: progress.startDate, hour: newDateComponents.hour!, minute: newDateComponents.minute!, body: "ယနေ့ အဓိဌာန်ကို မမေ့ပါနဲ့", repeats: true, identifier: dailyReminderNotificationIdentifier)
        checkProgress()
    }

    func checkNotificationValidity() {
        guard let endDate = UserDefaults.standard.object(forKey: notificationEndDateKey) as? Date else {
            return
        }

        if Date.now > endDate {
            removeAllNotification()
        }
    }

    func calculateDaysUntilVegetarian(dayInStage: Int) -> Int {
        var day = 0

        if dayInStage <= 5 {
            day = 5 - dayInStage
        } else {
            day = 9 - (dayInStage - 5)
        }

        return day
    }

    func resetPracitceCount() {
        UserDefaults.standard.set(0, forKey: "count")
        UserDefaults.standard.set(0, forKey: "round")
    }

    func scheduleNotification(
        from startDate: Date,
        hour: Int = 20,
        minute: Int = 0,
        title: String = "KoeNaWin(ကိုးနဝင်း)",
        body: String,
        repeats: Bool = false,
        identifier: String
    ) {
        removeAllNotification()

        var dateComponents = calendar.dateComponents([.hour, .minute], from: startDate)
        dateComponents.hour = hour
        dateComponents.minute = minute

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)

        let endDate = calendar.date(byAdding: .day, value: 81, to: startDate)
        UserDefaults.standard.set(endDate, forKey: notificationEndDateKey)
    }

    func removeAllNotification() {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [dailyReminderNotificationIdentifier, beforeStartNotificationIdentifier])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [dailyReminderNotificationIdentifier, beforeStartNotificationIdentifier])
        UserDefaults.standard.removeObject(forKey: notificationEndDateKey)
    }
}
