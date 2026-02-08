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
    @NSManaged var date: Date
    @NSManaged var statusRaw: Int16
    @NSManaged var completedAt: Date
    @NSManaged var createdAt: Date

    @NSManaged var commitment: Commitment
}

extension DailyProgress {
    var status: DailyProgressStatus {
        get { DailyProgressStatus(rawValue: statusRaw) ?? .notStarted }
        set { statusRaw = newValue.rawValue }
    }
}

extension DailyProgress {
    static var dailyProgressFetchRequest: NSFetchRequest<DailyProgress> {
        NSFetchRequest(entityName: String(describing: self))
    }
}
