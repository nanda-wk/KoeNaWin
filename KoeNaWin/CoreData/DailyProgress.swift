//
//  DailyProgress.swift
//  KoeNaWin
//
//  Created by Nanda Win Kyu on 2026-02-08.
//

import CoreData
import Foundation

@objc(DailyProgress)
final class DailyProgress: NSManagedObject, Identifiable {
    @NSManaged var id: UUID
    @NSManaged var dayNumber: Int16
    @NSManaged var date: Date
    @NSManaged var statusRaw: Int16
    @NSManaged var completedAt: Date?
    @NSManaged var createdAt: Date

    @NSManaged var journey: Journey

    @discardableResult
    static func create(
        id: UUID = UUID(),
        dayNumber: Int16,
        date: Date,
        status: DayStatus = .notStarted,
        journey: Journey,
        context: NSManagedObjectContext
    ) -> DailyProgress {
        let progress = DailyProgress(context: context)
        progress.id = id
        progress.dayNumber = dayNumber
        progress.date = date
        progress.status = status
        progress.createdAt = .now
        progress.journey = journey
        return progress
    }
}

extension DailyProgress {
    var status: DayStatus {
        get { DayStatus(rawValue: statusRaw) ?? .notStarted }
        set { statusRaw = newValue.rawValue }
    }
}

enum DayStatus: Int16 {
    case notStarted = 0
    case completed = 1
    case missed = 2
}

extension DailyProgress {
    static var dailyProgressFetchRequest: NSFetchRequest<DailyProgress> {
        NSFetchRequest(entityName: String(describing: self))
    }
}
