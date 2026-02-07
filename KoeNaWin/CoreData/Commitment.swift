//
//  Commitment.swift
//  KoeNaWin
//
//  Created by Nanda Win Kyu on 2026-02-08.
//

import CoreData
import Foundation

final class Commitment: NSManagedObject, Identifiable {
    @NSManaged var id: UUID
    @NSManaged var mantraText: String?
    @NSManaged var startDate: Date
    @NSManaged var totalDays: Int16
    @NSManaged var isActive: Bool
    @NSManaged var createdAt: Date

    @NSManaged var dailyProgresses: Set<DailyProgress>
    @NSManaged var practiceJourney: PracticeJourney?
}
