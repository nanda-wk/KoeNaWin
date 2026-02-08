//
//  UserProgressService.swift
//  KoeNaWin
//
//  Created by Nanda Win Kyu on 2026-02-08.
//

import Foundation

@MainActor
final class UserProgressService: ObservableObject {
    let stack: CoreDataStack
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
}
