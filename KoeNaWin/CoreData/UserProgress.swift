//
//  UserProgress.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import CoreData

final class UserProgress: NSManagedObject {
    @NSManaged var startDate: Date
    @NSManaged var currentStage: Int16
    @NSManaged var dayOfStage: Int16
}

extension UserProgress {
    static var userProgressFetchRequest: NSFetchRequest<UserProgress> {
        NSFetchRequest(entityName: String(describing: UserProgress.self))
    }

    static func latest() -> NSFetchRequest<UserProgress> {
        let request = userProgressFetchRequest
        request.sortDescriptors = []
        return request
    }
}

extension UserProgress {
    static func makePreview(start: Date = .now, stage: Int16 = 1, day: Int16 = 4) {
        let progress = UserProgress(context: CoreDataStack.shared.viewContext)
        progress.startDate = start
        progress.currentStage = stage
        progress.dayOfStage = day
    }
}
