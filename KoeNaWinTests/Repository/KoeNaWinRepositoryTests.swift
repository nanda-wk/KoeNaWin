//
//  KoeNaWinRepositoryTests.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-04-08.
//

import Combine
import CoreData
@testable import KoeNaWin
import XCTest

final class KoeNaWinRepositoryTests: XCTestCase {
    var repository: KoeNaWinRepository!
    var mockCoreDataStack: CoreDataStack = .shared
    var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        try super.setUpWithError()

        // Load test data
        koeNaWinStages = loadTestStages()

        // Create repository with test dependencies
        repository = KoeNaWinRepository()
    }

    override func tearDownWithError() throws {
        repository = nil
        cancellables.removeAll()
        UserDefaults.standard.removeObject(forKey: "koenawin-notification-end-date")
        UserDefaults.standard.removeObject(forKey: "count")
        UserDefaults.standard.removeObject(forKey: "round")
        try super.tearDownWithError()
    }

    // MARK: - Helper Methods

    private func loadTestStages() -> KoeNaWinStages {
        // Create test stages with prayers
        let prayers1 = [
            Prayer(day: .monday, mantra: "Test Mantra 1", rounds: 3, isVegetarian: false),
            Prayer(day: .tuesday, mantra: "Test Mantra 2", rounds: 3, isVegetarian: false),
            Prayer(day: .wednesday, mantra: "Test Mantra 3", rounds: 3, isVegetarian: false),
            Prayer(day: .thursday, mantra: "Test Mantra 4", rounds: 3, isVegetarian: false),
            Prayer(day: .friday, mantra: "Test Mantra 5", rounds: 3, isVegetarian: false),
            Prayer(day: .saturday, mantra: "Test Mantra 6", rounds: 3, isVegetarian: false),
            Prayer(day: .sunday, mantra: "Test Mantra 7", rounds: 3, isVegetarian: false),
            Prayer(day: .monday, mantra: "Test Mantra 8", rounds: 3, isVegetarian: false),
            Prayer(day: .tuesday, mantra: "Test Mantra 9", rounds: 3, isVegetarian: false),
        ]

        let prayers2 = [
            Prayer(day: .wednesday, mantra: "Test Mantra 10", rounds: 3, isVegetarian: false),
            Prayer(day: .thursday, mantra: "Test Mantra 11", rounds: 3, isVegetarian: false),
            Prayer(day: .friday, mantra: "Test Mantra 12", rounds: 3, isVegetarian: false),
            Prayer(day: .saturday, mantra: "Test Mantra 13", rounds: 3, isVegetarian: false),
            Prayer(day: .sunday, mantra: "Test Mantra 14", rounds: 3, isVegetarian: true),
            Prayer(day: .monday, mantra: "Test Mantra 15", rounds: 3, isVegetarian: false),
            Prayer(day: .tuesday, mantra: "Test Mantra 16", rounds: 3, isVegetarian: false),
            Prayer(day: .wednesday, mantra: "Test Mantra 17", rounds: 3, isVegetarian: false),
            Prayer(day: .thursday, mantra: "Test Mantra 18", rounds: 3, isVegetarian: false),
        ]

        return [
            KoeNaWinStage(stage: 1, benefits: "Test Benefits 1", prayers: prayers1),
            KoeNaWinStage(stage: 2, benefits: "Test Benefits 2", prayers: prayers2),
        ]
    }

    private func createMockUserProgress(
        startDate: Date = Date.now,
        currentStage: Int16 = 1,
        dayOfStage: Int16 = 1,
        completedDays: [Date] = []
    ) {
        try? mockCoreDataStack.deleteAll(UserProgress.self)
        try? mockCoreDataStack.deleteAll(UserRecord.self)
        let progress = UserProgress(context: mockCoreDataStack.viewContext)
        progress.startDate = startDate
        progress.currentStage = currentStage
        progress.dayOfStage = dayOfStage
        progress.completedDaysArray = completedDays
        progress.reminder = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: Date())!
        try? mockCoreDataStack.persist(in: progress.managedObjectContext ?? mockCoreDataStack.viewContext)
    }

    // MARK: - Test Cases

    func testCheckProgressWhenNoUserProgress() {
        // When
        try? mockCoreDataStack.deleteAll(UserProgress.self)
        repository.checkProgress()

        // Then
        var receivedStatus: ProgressStatus?
        let expectation = expectation(description: "Receive status update")

        repository.progressPublisher
            .sink { status in
                receivedStatus = status
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 1)

        if case .notStarted = receivedStatus {
            // Test passed
        } else {
            XCTFail("Expected .notStarted status, got \(String(describing: receivedStatus))")
        }
    }

    func testCheckProgressWithMissedDays() {
        // Given
        let calendar = Calendar.current
        let today = Date()
        let startDate = calendar.date(byAdding: .day, value: -3, to: today)!
        let completedDays = [
            startDate, // Day 1 completed
            calendar.date(byAdding: .day, value: -1, to: today)!, // Day 3 completed (skipped day 2)
        ]

        createMockUserProgress(
            startDate: startDate,
            currentStage: 1,
            dayOfStage: 3,
            completedDays: completedDays
        )

        // When
        repository.checkProgress()

        // Then
        var receivedStatus: ProgressStatus?
        let expectation = expectation(description: "Receive status update")

        let progress = repository.loadUserProgress()
        let records = repository.loadUserRecords()

        repository.progressPublisher
            .sink { status in
                receivedStatus = status
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 1)

        if case .missedDay = receivedStatus {
            // Test passed
        } else {
            XCTFail("Expected .missedDay status, got \(String(describing: receivedStatus))")
        }

        // Verify user record was saved
        XCTAssertNotEqual(progress, nil)
        XCTAssertEqual(records.first?.status, Status.fail.rawValue)
    }

    func testCheckProgressWithActiveProgress() {
        // Given
        let calendar = Calendar.current
        let today = Date()
        let startDate = calendar.date(byAdding: .day, value: -2, to: today)!
        let completedDays = [
            startDate, // Day 1 completed
            calendar.date(byAdding: .day, value: -1, to: today)!, // Day 2 completed
        ]

        createMockUserProgress(
            startDate: startDate,
            currentStage: 1,
            dayOfStage: 3,
            completedDays: completedDays
        )

        // When
        repository.checkProgress()

        // Then
        var receivedStatus: ProgressStatus?
        let expectation = expectation(description: "Receive status update")

        repository.progressPublisher
            .sink { status in
                receivedStatus = status
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 1)

        if case let .active(progress, prayer, dayUntilVegetarian, todayCompleted) = receivedStatus {
            XCTAssertEqual(progress.currentStage, 1)
            XCTAssertEqual(progress.dayOfStage, 3)
            XCTAssertEqual(prayer.day, .wednesday)
            XCTAssertEqual(dayUntilVegetarian, 2)
            XCTAssertFalse(todayCompleted)
        } else {
            XCTFail("Expected .active status, got \(String(describing: receivedStatus))")
        }
    }

    func testCheckProgressWithCompletedProgress() {
        // Given
        let calendar = Calendar.current
        let today = Date()
        let startDate = calendar.date(byAdding: .day, value: -80, to: today)!
        var completedDays: [Date] = []

        // Create 81 completed days
        for i in 0 ..< 81 {
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                completedDays.append(date)
            }
        }

        createMockUserProgress(
            startDate: startDate,
            currentStage: 9,
            dayOfStage: 9,
            completedDays: completedDays
        )

        // When
        repository.checkProgress()

        // Then
        var receivedStatus: ProgressStatus?
        let expectation = expectation(description: "Receive status update")
        let records = repository.loadUserRecords()

        repository.progressPublisher
            .sink { status in
                receivedStatus = status
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 1)

        if case .completed = receivedStatus {
            // Test passed
        } else {
            XCTFail("Expected .completed status, got \(String(describing: receivedStatus))")
        }

        // Verify user record was saved
        XCTAssertEqual(records.count, 1)
        XCTAssertEqual(records.first?.status, Status.complete.rawValue)
    }

    func testMarkTodayAsCompleted() {
        // Given
        let calendar = Calendar.current
        let today = Date()
        let startDate = calendar.date(byAdding: .day, value: -2, to: today)!
        let completedDays = [
            startDate, // Day 1 completed
            calendar.date(byAdding: .day, value: -1, to: today)!, // Day 2 completed
        ]

        createMockUserProgress(
            startDate: startDate,
            currentStage: 1,
            dayOfStage: 3,
            completedDays: completedDays
        )

        // When
        repository.markTodayAsCompleted()

        let progress = repository.loadUserProgress()

        // Then
        XCTAssertEqual(progress?.dayOfStage, 4)
        XCTAssertEqual(progress?.completedDaysArray.count, 3)

        // Verify today was added to completed days
        let todayCompleted = progress?.completedDaysArray.contains { date in
            calendar.isDate(date, inSameDayAs: today)
        } ?? false
        XCTAssertTrue(todayCompleted)

        // Verify UserDefaults were reset
        XCTAssertEqual(UserDefaults.standard.integer(forKey: "count"), 0)
        XCTAssertEqual(UserDefaults.standard.integer(forKey: "round"), 0)
    }

    func testMarkTodayAsCompletedWithStageTransition() {
        // Given
        let calendar = Calendar.current
        let today = Date()
        let startDate = calendar.date(byAdding: .day, value: -8, to: today)!
        var completedDays: [Date] = []

        // Create 8 completed days
        for i in 0 ..< 8 {
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                completedDays.append(date)
            }
        }

        createMockUserProgress(
            startDate: startDate,
            currentStage: 1,
            dayOfStage: 9,
            completedDays: completedDays
        )

        // When
        repository.markTodayAsCompleted()

        let progress = repository.loadUserProgress()

        // Then
        XCTAssertEqual(progress?.currentStage, 2)
        XCTAssertEqual(progress?.dayOfStage, 1)
        XCTAssertEqual(progress?.completedDaysArray.count, 9)
    }

    func testStartNewProgressOnNonMonday() {
        try? mockCoreDataStack.deleteAll(UserProgress.self)
        // Given
        let calendar = Calendar.current
        let today = Date()
        var nonMondayDate = today

        // Mock a non-Monday date
        let components = calendar.dateComponents([.weekday], from: today)
        if components.weekday == 2 {
            nonMondayDate = calendar.date(byAdding: .day, value: 1, to: today)!

            // When
            repository.startNewProgress(date: nonMondayDate)

            // Then
            var receivedStatus: ProgressStatus?
            let expectation = expectation(description: "Receive status update")

            let progress = repository.loadUserProgress()

            repository.progressPublisher
                .sink { status in
                    receivedStatus = status
                    expectation.fulfill()
                }
                .store(in: &cancellables)

            waitForExpectations(timeout: 1)

            if case .notMonday = receivedStatus {
                // Test passed
            } else {
                XCTFail("Expected .notMonday status, got \(String(describing: receivedStatus))")
            }

            // Verify no user progress was created
            XCTAssertNil(progress)
        }

        func testStartNewProgressOnMonday() {
            try? mockCoreDataStack.deleteAll(UserProgress.self)
            // Given
            let calendar = Calendar.current

            // Find the previous Monday
            let components = calendar.dateComponents([.weekday], from: Date())
            var mondayDate = Date.now
            let weekday = components.weekday!
            if weekday == 2 {
                mondayDate = calendar.date(byAdding: .day, value: 0, to: Date())!
            } else if weekday < 2 {
                mondayDate = calendar.date(byAdding: .day, value: 1, to: Date())!
            } else {
                let value = weekday - 2
                mondayDate = calendar.date(byAdding: .day, value: -value, to: Date())!
            }

            // When
            repository.startNewProgress(date: mondayDate)

            let progress = repository.loadUserProgress()

            // Then
            XCTAssertNotNil(progress)
            XCTAssertEqual(progress?.currentStage, 1)
            XCTAssertEqual(progress?.dayOfStage, 0)
            XCTAssertEqual(progress?.completedDaysArray.count, 0)

            // Verify UserDefaults were reset
            XCTAssertEqual(UserDefaults.standard.integer(forKey: "count"), 0)
            XCTAssertEqual(UserDefaults.standard.integer(forKey: "round"), 0)
        }

        func testChangeStartDate() {
            // Given
            let calendar = Calendar.current
            let today = Date()
            let originalStartDate = calendar.date(byAdding: .day, value: -5, to: today)!
            let newStartDate = calendar.date(byAdding: .day, value: -3, to: today)!

            createMockUserProgress(
                startDate: originalStartDate,
                currentStage: 1,
                dayOfStage: 6,
                completedDays: []
            )

            // When
            repository.changeStartDate(newStartDate)

            let progress = repository.loadUserProgress()

            // Then
            XCTAssertEqual(progress?.startDate, newStartDate)

            // Should be day 4 (3 days since start)
            XCTAssertEqual(progress?.dayOfStage, 3)

            // Should have 3 completed days (days 1-3)
            XCTAssertEqual(progress?.completedDaysArray.count, 3)
        }

        func testChangeReminderDate() {
            // Given
            let calendar = Calendar.current
            let today = Date()
            let startDate = calendar.date(byAdding: .day, value: -2, to: today)!

            createMockUserProgress(
                startDate: startDate,
                currentStage: 1,
                dayOfStage: 3,
                completedDays: []
            )

            // Create a new reminder time (10:30 AM)
            var components = calendar.dateComponents([.year, .month, .day], from: today)
            components.hour = 10
            components.minute = 30
            let newReminderDate = calendar.date(from: components)!

            // When
            repository.changeReminderDate(newReminderDate)

            let progress = repository.loadUserProgress()

            // Then
            let savedReminderHour = calendar.component(.hour, from: progress?.reminder ?? Date())
            let savedReminderMinute = calendar.component(.minute, from: progress?.reminder ?? Date())

            XCTAssertEqual(savedReminderHour, 10)
            XCTAssertEqual(savedReminderMinute, 30)
        }

        func testCalculateDaysUntilVegetarian() {
            // Test days before vegetarian period (days 1-5)
            XCTAssertEqual(repository.calculateDaysUntilVegetarian(dayInStage: 1), 4) // 5 - 1 = 4
            XCTAssertEqual(repository.calculateDaysUntilVegetarian(dayInStage: 2), 3) // 5 - 2 = 3
            XCTAssertEqual(repository.calculateDaysUntilVegetarian(dayInStage: 3), 2) // 5 - 3 = 2
            XCTAssertEqual(repository.calculateDaysUntilVegetarian(dayInStage: 4), 1) // 5 - 4 = 1
            XCTAssertEqual(repository.calculateDaysUntilVegetarian(dayInStage: 5), 0) // 5 - 5 = 0

            // Test days during vegetarian period (days 6-9)
            XCTAssertEqual(repository.calculateDaysUntilVegetarian(dayInStage: 6), 8) // 9 - (6 - 5) = 8
            XCTAssertEqual(repository.calculateDaysUntilVegetarian(dayInStage: 7), 7) // 9 - (7 - 5) = 7
            XCTAssertEqual(repository.calculateDaysUntilVegetarian(dayInStage: 8), 6) // 9 - (8 - 5) = 6
            XCTAssertEqual(repository.calculateDaysUntilVegetarian(dayInStage: 9), 5) // 9 - (9 - 5) = 5
        }
    }
}
