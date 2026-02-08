//
//  PracticeJourney.swift
//  KoeNaWin
//
//  Created by Nanda Win Kyu on 2026-02-08.
//

import CoreData
import Foundation

@objc(PracticeJourney)
final class PracticeJourney: NSManagedObject, Identifiable {
    @NSManaged var id: UUID
    @NSManaged var startDate: Date
    @NSManaged var endDate: Date?
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

extension PracticeJourney {
    static func create(
        startDate: Date,
        endDate: Date? = nil,
        outcome: PracticeOutcome = .none,
        completedDays: Int16 = 0,
        missedDays: Int64 = 0,
        longestStreak: Int16 = 0,
        endReason: JourneyEndReason = .none,
        reflectionNote: String? = nil,
        context: NSManagedObjectContext
    ) -> PracticeJourney {
        let journey = PracticeJourney(context: context)
        journey.id = UUID()
        journey.startDate = startDate
        journey.endDate = endDate
        journey.outcome = outcome
        journey.completedDays = completedDays
        journey.missedDays = missedDays
        journey.longestStreak = longestStreak
        journey.endReason = endReason
        journey.reflectionNote = reflectionNote
        journey.createdAt = .now
        return journey
    }
}

extension PracticeJourney {
    static var practiceJourneyFetchRequest: NSFetchRequest<PracticeJourney> {
        NSFetchRequest(entityName: String(describing: self))
    }
}
