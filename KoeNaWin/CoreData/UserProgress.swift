//
//  UserProgress.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import CoreData

final class UserProgress: NSManagedObject {
    @NSManaged var startDate: Date
    @NSManaged var currentStage: Int16
    @NSManaged var dayOfStage: Int16
    @NSManaged var completedDays: Data
    @NSManaged var reminder: Date
}

extension UserProgress {
    var completedDaysArray: [Date] {
        get {
            do {
                return try JSONDecoder().decode([Date].self, from: completedDays)
            } catch {
                print("Failed to decode completed dates: \(error)")
                return []
            }
        }
        set {
            do {
                completedDays = try JSONEncoder().encode(newValue.map { $0 })
            } catch {
                print("Failed to encode completed dates: \(error)")
                completedDays = Data()
            }
        }
    }
}

extension UserProgress {
    static var userProgressFetchRequest: NSFetchRequest<UserProgress> {
        NSFetchRequest(entityName: String(describing: UserProgress.self))
    }

    static func latest() -> NSFetchRequest<UserProgress> {
        let request = userProgressFetchRequest
        request.sortDescriptors = []
        return request
    }
}

extension UserProgress {
    
    private static func clearPreviewData() {
        let context = CoreDataStack.shared.viewContext
        let fetchRequest = UserProgress.userProgressFetchRequest
        do {
            let existing = try context.fetch(fetchRequest)
            for item in existing {
                context.delete(item)
            }
        } catch {
            print("Failed to clear preview data: \(error)")
        }
    }
    
    static func makePreview(
        stage: Int16 = 1,
        day: Int16 = 4,
        todayCompleted: Bool = false,
        markAsCompleted: Bool = false
    ) {
        clearPreviewData()
        
        let calendar = Calendar.current
        let today = Date.now.startOfDay(using: calendar)
        
        // Calculate total day number in the 81-day journey
        // Stage 8, Day 8 = (7 * 9) + 8 = 71
        let targetTotalDay = markAsCompleted ? 81 : ((Int(stage) - 1) * 9) + Int(day)
        let daysSinceStart = targetTotalDay - 1
        
        // Calculate the start date (no Monday adjustment - we want exact stage/day)
        guard let startDate = calendar.date(byAdding: .day, value: -daysSinceStart, to: today) else {
            return
        }
        
        // Build completedDays array for all days from start to yesterday (or today if todayCompleted)
        var completedDays: [Date] = []
        let daysToComplete = todayCompleted ? daysSinceStart + 1 : daysSinceStart
        for i in 0..<daysToComplete {
            if let completedDate = calendar.date(byAdding: .day, value: i, to: startDate) {
                completedDays.append(completedDate.startOfDay(using: calendar))
            }
        }
        
        // Set reminder to 8 PM today
        var reminderComponents = calendar.dateComponents([.year, .month, .day], from: today)
        reminderComponents.hour = 20
        reminderComponents.minute = 0
        let reminder = calendar.date(from: reminderComponents) ?? today
        
        let progress = UserProgress(context: CoreDataStack.shared.viewContext)
        progress.startDate = startDate
        progress.currentStage = stage
        progress.dayOfStage = day
        progress.completedDaysArray = completedDays
        progress.reminder = reminder
    }
    
    /// Creates a UserProgress with a missed day (yesterday not completed)
    static func makePreviewWithMissedDay() {
        clearPreviewData()
        
        let calendar = Calendar.current
        let today = Date.now.startOfDay(using: calendar)
        
        // Find the Monday 3 days ago (so we have a missed day in between)
        guard let threeDaysAgo = calendar.date(byAdding: .day, value: -3, to: today) else { return }
        
        let weekday = calendar.component(.weekday, from: threeDaysAgo)
        var startDate = threeDaysAgo
        if weekday != 2 {
            let daysToSubtract = (weekday == 1) ? 6 : (weekday - 2)
            startDate = calendar.date(byAdding: .day, value: -daysToSubtract, to: threeDaysAgo) ?? threeDaysAgo
        }
        
        let actualDaysSinceStart = calendar.dateComponents([.day], from: startDate, to: today).day ?? 0
        
        // Complete all days EXCEPT yesterday (creating a missed day)
        var completedDays: [Date] = []
        for i in 0..<(actualDaysSinceStart - 1) { // Skip yesterday
            if let completedDate = calendar.date(byAdding: .day, value: i, to: startDate) {
                completedDays.append(completedDate.startOfDay(using: calendar))
            }
        }
        
        var reminderComponents = calendar.dateComponents([.year, .month, .day], from: today)
        reminderComponents.hour = 20
        reminderComponents.minute = 0
        let reminder = calendar.date(from: reminderComponents) ?? today
        
        let progress = UserProgress(context: CoreDataStack.shared.viewContext)
        progress.startDate = startDate
        progress.currentStage = 1
        progress.dayOfStage = 1
        progress.completedDaysArray = completedDays
        progress.reminder = reminder
    }
    
    /// Creates a UserProgress scheduled to start on next Monday
    static func makePreviewWillStart() {
        clearPreviewData()
        
        let calendar = Calendar.current
        let today = Date.now.startOfDay(using: calendar)
        
        // Find next Monday
        guard let nextMonday = calendar.nextDate(
            after: today,
            matching: DateComponents(weekday: 2),
            matchingPolicy: .nextTime
        ) else { return }
        
        var reminderComponents = calendar.dateComponents([.year, .month, .day], from: today)
        reminderComponents.hour = 20
        reminderComponents.minute = 0
        let reminder = calendar.date(from: reminderComponents) ?? today
        
        let progress = UserProgress(context: CoreDataStack.shared.viewContext)
        progress.startDate = nextMonday
        progress.currentStage = 1
        progress.dayOfStage = 0
        progress.completedDaysArray = []
        progress.reminder = reminder
    }
}
