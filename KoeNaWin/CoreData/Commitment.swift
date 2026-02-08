//
//  Commitment.swift
//  KoeNaWin
//
//  Created by Nanda Win Kyu on 2026-02-08.
//

import CoreData
import Foundation

@objc(Commitment)
final class Commitment: NSManagedObject, Identifiable {
    @NSManaged var id: UUID
    @NSManaged var startDate: Date
    @NSManaged var totalDays: Int16
    @NSManaged var commitmentReflection: String?
    @NSManaged var isActive: Bool
    @NSManaged var createdAt: Date

    @NSManaged var dailyProgresses: Set<DailyProgress>
    @NSManaged var practiceJourney: PracticeJourney?
}

extension Commitment {
    static func create(
        startDate: Date,
        commitmentReflection: String? = nil,
        totalDays: Int16 = 81,
        isActive: Bool = true,
        context: NSManagedObjectContext
    ) -> Commitment {
        let commitment = Commitment(context: context)
        commitment.id = UUID()
        commitment.startDate = startDate
        commitment.commitmentReflection = commitmentReflection
        commitment.totalDays = totalDays
        commitment.isActive = isActive
        commitment.createdAt = .now
        commitment.dailyProgresses = []
        return commitment
    }
}
