//
//  UserProgressService.swift
//  KoeNaWin
//
//  Created by Nanda Win Kyu on 2026-02-08.
//

import Foundation

@MainActor
final class UserProgressService: ObservableObject {
    private let stack: CoreDataStack
    private lazy var context = stack.viewContext

    init(stack: CoreDataStack = .shared) {
        self.stack = stack
    }

    func startNewCommitment(startDate: Date, commitmentReflection: String? = nil) throws {
        let commitment = Commitment.create(
            startDate: startDate,
            commitmentReflection: commitmentReflection,
            context: context
        )

        let context = commitment.managedObjectContext ?? context

        try stack.persist(in: context)
    }

    func setDailyReminder(_ date: Date) {
        NotificationService.shared.cancelNotification(id: NotificationID.scheduleNotificationIdentifier)
        NotificationService.shared.scheduleNotification(
            id: NotificationID.scheduleNotificationIdentifier,
            title: NotiMessage.scheduleNotificationTitle,
            subtitle: NotiMessage.scheduleNotificationBody,
            date: date,
            repeats: true
        )
    }

    func setNewCommitmentReminder(_ date: Date) {
        NotificationService.shared.cancelNotification(id: NotificationID.oneDayBeforeNotificationIdentifier)
        NotificationService.shared.scheduleNotification(
            id: NotificationID.oneDayBeforeNotificationIdentifier,
            title: NotiMessage.oneDayBeforeNotificationTitle,
            subtitle: NotiMessage.oneDayBeforeNotificationBody,
            date: date,
            repeats: false
        )
    }
}
