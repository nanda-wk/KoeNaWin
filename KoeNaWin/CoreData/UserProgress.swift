//
//  UserProgress.swift
//  KoeNaWin
//
//  Created by Nanda Win Kyu on 2026-03-02.
//

import CoreData

final class UserProgress: NSManagedObject {
    @NSManaged var startDate: Date
    @NSManaged var currentStage: Int16
    @NSManaged var dayOfStage: Int16
    @NSManaged var completedDays: Data
    @NSManaged var reminder: Date
}
