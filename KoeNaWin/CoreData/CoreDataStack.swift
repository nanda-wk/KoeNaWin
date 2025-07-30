//
//  CoreDataStack.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import CoreData
import SwiftUI

final class CoreDataStack {
    private static let appGroupId = "group.com.nandawk.KoeNaWin"
    private static let migrationCompletedKey = "didMigrateToAppGroupStore"

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
        } else {
            guard let groupContainerUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Self.appGroupId) else {
                fatalError("Failed to get App Group container URL. Make sure the App Group ID '\(Self.appGroupId)' is correct and enabled in your project capabilities.")
            }

            let storeUrl = groupContainerUrl.appendingPathComponent("KoeNaWin.sqlite")

            migrateStoreIfNeeded(to: storeUrl)

            let description = NSPersistentStoreDescription(url: storeUrl)
            persistentContainer.persistentStoreDescriptions = [description]
        }
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent store: \(error)")
            }
        }
    }

    func exisits<T: NSManagedObject>(_ object: T, in context: NSManagedObjectContext) -> T? {
        try? context.existingObject(with: object.objectID) as? T
    }

    func delete(_ object: some NSManagedObject, in context: NSManagedObjectContext) throws {
        if let existingObject = exisits(object, in: context) {
            context.delete(existingObject)
            Task(priority: .background) {
                try await context.perform {
                    try context.save()
                }
            }
        }
    }

    func deleteAll(_ type: (some NSManagedObject).Type) throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: String(describing: type))
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: viewContext)
    }

    func persist(in context: NSManagedObjectContext) throws {
        if context.hasChanges {
            try context.save()
        }
    }
}

extension CoreDataStack {
    private func migrateStoreIfNeeded(to newStoreUrl: URL) {
        let userDefault = UserDefaults.standard

        if userDefault.bool(forKey: Self.migrationCompletedKey) {
            print("Migration to App Group already completed. Skipping...")
            return
        }

        let fileManager = FileManager.default
        let oldDefaultUrl = NSPersistentContainer.defaultDirectoryURL()
        let oldStoreUrl = oldDefaultUrl.appendingPathComponent("KoeNaWin.sqlite")

        if fileManager.fileExists(atPath: oldStoreUrl.path(percentEncoded: false)) {
            print("Old store found at default location. starting migration to App Group...")

            let supportFileExtensions = ["sqlite", "sqlite-shm", "sqlite-wal"]
            let oldStoreDirectory = oldStoreUrl.deletingLastPathComponent()
            let newStoreDirectory = newStoreUrl.deletingLastPathComponent()

            do {
                for ext in supportFileExtensions {
                    let sourceUrl = oldStoreDirectory.appendingPathComponent("KoeNaWin.\(ext)")
                    let destUrl = newStoreDirectory.appendingPathComponent("KoeNaWin.\(ext)")

                    if fileManager.fileExists(atPath: sourceUrl.path(percentEncoded: false)) {
                        try fileManager.moveItem(at: sourceUrl, to: destUrl)
                        print("Successfully moved \(sourceUrl.lastPathComponent)")
                    }
                }

                print("Migration successful!")
                userDefault.set(true, forKey: Self.migrationCompletedKey)
            } catch {
                fatalError("FATAL: Failed to migrate persistent store to App Group: \(error)")
            }
        } else {
            print("No old store found. Skipping migration (likely a new install).")
            userDefault.set(true, forKey: Self.migrationCompletedKey)
        }
    }
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
