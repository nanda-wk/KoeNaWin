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
    @NSManaged var reflection: String
    @NSManaged var totalDays: Int16
    @NSManaged var categoryRaw: Int16
    @NSManaged var createdAt: Date

    @NSManaged var journeys: Set<Journey>

    @discardableResult
    static func create(
        id: UUID = UUID(),
        totalDays: Int16 = 81,
        category: CommitmentCategory = .koeNaWin,
        reflection: String? = nil,
        context: NSManagedObjectContext
    ) -> Commitment {
        let commitment = Commitment(context: context)
        commitment.id = id
        commitment.totalDays = totalDays
        commitment.category = category
        commitment.reflection = reflection ?? "ကိုးနဝင်း မိုးလင်းမှသိမယ်"
        commitment.createdAt = .now
        return commitment
    }
}

extension Commitment {
    var category: CommitmentCategory {
        get { CommitmentCategory(rawValue: categoryRaw) ?? .koeNaWin }
        set { categoryRaw = newValue.rawValue }
    }
}

enum CommitmentCategory: Int16 {
    case koeNaWin = 0
    case custom = 1
}

extension Commitment {
    static var commitmentFetchRequest: NSFetchRequest<Commitment> {
        NSFetchRequest(entityName: String(describing: self))
    }
}
