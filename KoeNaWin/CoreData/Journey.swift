//
//  Journey.swift
//  KoeNaWin
//
//  Created by Nanda Win Kyu on 2026-02-08.
//

import CoreData
import Foundation

@objc(Journey)
final class Journey: NSManagedObject, Identifiable {
    @NSManaged var id: UUID
    @NSManaged var startDate: Date
    @NSManaged var endDate: Date?
    @NSManaged var outcomeRaw: Int16
    @NSManaged var completedDays: Int16
    @NSManaged var missedDays: Int16
    @NSManaged var longestStreak: Int16
    @NSManaged var endedReasonRaw: Int16
    @NSManaged var createdAt: Date

    @NSManaged var commitment: Commitment
    @NSManaged var dailyProgress: Set<DailyProgress>

    @discardableResult
    static func create(
        id: UUID = UUID(),
        startDate: Date,
        outcome: JourneyOutcome = .inProgress,
        commitment: Commitment,
        context: NSManagedObjectContext
    ) -> Journey {
        let journey = Journey(context: context)
        journey.id = id
        journey.startDate = startDate
        journey.outcome = outcome
        journey.completedDays = 0
        journey.missedDays = 0
        journey.longestStreak = 0
        journey.endedReason = .none
        journey.createdAt = .now
        journey.commitment = commitment
        return journey
    }
}

extension Journey {
    var outcome: JourneyOutcome {
        get { JourneyOutcome(rawValue: outcomeRaw) ?? .failed }
        set { outcomeRaw = newValue.rawValue }
    }

    var endedReason: JourneyEndReason {
        get { JourneyEndReason(rawValue: endedReasonRaw) ?? .none }
        set { endedReasonRaw = newValue.rawValue }
    }
}

enum JourneyOutcome: Int16 {
    case inProgress = 0
    case succeeded = 1
    case failed = 2
    case abandoned = 3
}

enum JourneyEndReason: Int16 {
    case completed = 0
    case missed = 1
    case userStopped = 2
    case none = 3
}

extension Journey {
    static var journeyFetchRequest: NSFetchRequest<Journey> {
        NSFetchRequest(entityName: String(describing: self))
    }
}
