//
//  HomeViewModel.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-31.
//

import Combine
import Foundation

final class HomeViewModel: ObservableObject {
    @Published private(set) var stage = 0
    @Published private(set) var day = 0
    @Published private(set) var totalDay = 0
    @Published private(set) var currentPrayer: Prayer?
    @Published private(set) var todayCompleted = false
    @Published private(set) var dayUntilVegetarian = 0
    @Published private(set) var totalProgressPercentage = 0.0
    @Published private(set) var currentProgressPercentage = 0.0
    @Published private(set) var startDate = Date.now
    @Published private(set) var reminderDate = Date.now

    @Published private(set) var status: ProgressStatus = .notStarted

    private let repository: KoeNaWinRepository
    private var cancellables = Set<AnyCancellable>()

    init(repository: KoeNaWinRepository = .init()) {
        self.repository = repository

        repository.progressPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.status = status

                if case let .active(progress, prayer, dayUntilVegetarian, todayCompleted) = status {
                    let totalDay = (progress.currentStage * 9) - (9 - progress.dayOfStage)
                    self?.stage = Int(progress.currentStage)
                    self?.day = Int(progress.dayOfStage)
                    self?.totalDay = Int(totalDay)
                    self?.currentPrayer = prayer
                    self?.todayCompleted = todayCompleted
                    self?.dayUntilVegetarian = dayUntilVegetarian
                    self?.totalProgressPercentage = (Double(totalDay) / 81) * 100
                    self?.currentProgressPercentage = (Double(progress.dayOfStage) / 9) * 100
                    self?.startDate = progress.startDate
                    self?.reminderDate = progress.reminder
                }
            }
            .store(in: &cancellables)
    }

    func checkProgress() {
        repository.checkProgress()
    }

    func startNewProgress() {
        repository.startNewProgress()
    }

    func markTodayComplete() {
        repository.markTodayAsCompleted()
    }

    func changeStartDate(_ date: Date) {
        repository.changeStartDate(date)
    }

    func changeReminder(_ date: Date) {
        repository.changeReminderDate(date)
    }

    func checkNotificationValidity() {
        repository.checkNotificationValidity()
    }
}
