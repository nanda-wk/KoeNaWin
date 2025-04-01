//
//  CompletedDay.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import CoreData

final class CompletedDay: NSManagedObject {
    @NSManaged var date: Date
}

extension CompletedDay {
    static var completedDayFetchRequest: NSFetchRequest<CompletedDay> {
        NSFetchRequest(entityName: "CompletedDay")
    }

    static func latest() -> NSFetchRequest<CompletedDay> {
        let request = completedDayFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \CompletedDay.date, ascending: false),
        ]
        return request
    }
}
