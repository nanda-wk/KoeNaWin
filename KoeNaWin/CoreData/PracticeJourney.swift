//
//  PracticeJourney.swift
//  KoeNaWin
//
//  Created by Nanda Win Kyu on 2026-02-08.
//

import CoreData
import Foundation

final class PracticeJourney: NSManagedObject, Identifiable {
    @NSManaged var id: UUID
    @NSManaged var startDate: Date
    @NSManaged var endDate: Date
    @NSManaged var outcomeRaw: Int16
    @NSManaged var completedDays: Int16
    @NSManaged var missedDays: Int64
    @NSManaged var longestStreak: Int16
    @NSManaged var endReasonRaw: Int16
    @NSManaged var reflectionNote: String?
    @NSManaged var createdAt: Date?

    @NSManaged var commitment: Commitment
}

extension PracticeJourney {
    var outcome: PracticeOutcome {
        get { PracticeOutcome(rawValue: outcomeRaw) ?? .failed }
        set { outcomeRaw = newValue.rawValue }
    }

    var endReason: JourneyEndReason {
        get { JourneyEndReason(rawValue: endReasonRaw) ?? .completed }
        set { endReasonRaw = newValue.rawValue }
    }
}
