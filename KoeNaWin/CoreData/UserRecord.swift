//
//  UserRecord.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import CoreData

final class UserRecord: NSManagedObject {
    @NSManaged var startDate: Date
    @NSManaged var endDate: Date
    @NSManaged var stage: Int16
    @NSManaged var day: Int16
    @NSManaged var status: String
}

extension UserRecord {
    static var userRecordFetchRequest: NSFetchRequest<UserRecord> {
        NSFetchRequest(entityName: String(describing: UserRecord.self))
    }

    static func latest() -> NSFetchRequest<UserRecord> {
        let request = userRecordFetchRequest
        request.sortDescriptors = []
        return request
    }
}
