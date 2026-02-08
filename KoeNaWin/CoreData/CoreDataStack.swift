//
//  CoreDataStack.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import CoreData
import SwiftUI

final class CoreDataStack {
    static let shared = CoreDataStack()

    private let persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    var newContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }

    private init() {
        persistentContainer = NSPersistentContainer(name: "KoeNaWin")
        if EnvironmentValues.isPreview || Thread.current.isRunningXCTest {
            persistentContainer.persistentStoreDescriptions.first?.url = .init(fileURLWithPath: "/dev/null")
        }
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent store: \(error)")
            }
        }
    }

    func delete(_ object: some NSManagedObject,
                in context: NSManagedObjectContext) async throws
    {
        try await context.perform {
            if let existing = try? context.existingObject(with: object.objectID) {
                context.delete(existing)
                if context.hasChanges {
                    try context.save()
                }
            }
        }
    }

    func deleteAll<T: NSManagedObject>(_: T.Type) throws {
        let request = NSFetchRequest<NSFetchRequestResult>(
            entityName: T.entity().name!
        )

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        deleteRequest.resultType = .resultTypeObjectIDs

        let result = try persistentContainer.persistentStoreCoordinator
            .execute(deleteRequest, with: viewContext) as? NSBatchDeleteResult

        if let objectIDs = result?.result as? [NSManagedObjectID] {
            let changes = [NSDeletedObjectsKey: objectIDs]
            NSManagedObjectContext.mergeChanges(
                fromRemoteContextSave: changes,
                into: [viewContext]
            )
        }
    }

    func persist(in context: NSManagedObjectContext) throws {
        if context.hasChanges {
            try context.save()
        }
    }
}

enum CoreDataError: Error, LocalizedError {
    case failedToSave
}

extension EnvironmentValues {
    static var isPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}

extension Thread {
    var isRunningXCTest: Bool {
        for key in threadDictionary.allKeys {
            guard let keyAsString = key as? String else {
                continue
            }

            if keyAsString.split(separator: ".").contains("xctest") {
                return true
            }
        }
        return false
    }
}
