//
//  FailureRecord.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import CoreData

final class FailureRecord: NSManagedObject {
    @NSManaged var startDate: Date
    @NSManaged var failureDate: Date
    @NSManaged var stage: Int16
    @NSManaged var day: Int16
}

extension FailureRecord {
    static var failureRecordFetchRequest: NSFetchRequest<FailureRecord> {
        NSFetchRequest(entityName: "FailureRecord")
    }

    static func latest() -> NSFetchRequest<FailureRecord> {
        let request = failureRecordFetchRequest
        request.sortDescriptors = []
        return request
    }
}
