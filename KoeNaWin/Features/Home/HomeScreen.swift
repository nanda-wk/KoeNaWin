//
//  HomeScreen.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import Charts
import Combine
import SwiftUI

private var shownAchievement = false

struct HomeScreen: View {
    @EnvironmentObject private var store: KoeNaWinStore
    @EnvironmentObject private var journeyService: JourneyService
    @EnvironmentObject private var userPreferences: UserPreferences
    @EnvironmentObject private var router: Router

    var body: some View {
        content
            .navigationTitle("KoeNaWin")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                achievement
            }
    }
}

extension HomeScreen {
    @ViewBuilder
    private var content: some View {
        ZStack {
            Color(.appBackground)
                .ignoresSafeArea()

            switch journeyService.practiceState {
            case .started, .completedAll:
                startedView
            case .notStarted:
                NotStartedView()
            case let .scheduled(startDate):
                ScheduledView(date: startDate)
            case let .missedDay(date):
                MissedDayView(date: date)
            }
        }
    }

    private var startedView: some View {
        ScrollView {
            VStack(spacing: 25) {
                topSection
                todayMantra
                completedTodayView
                currentStageCompletion
                completionSection
            }
            .padding()
        }
        .scrollIndicators(.never)
        .onAppear {
            if journeyService.practiceState == .completedAll, !shownAchievement {
                router.presentSheet(.achievement)
                shownAchievement = true
            }
        }
    }

    @ViewBuilder
    private var topSection: some View {
        if journeyService.practiceState == .completedAll {
            congratulation
        } else {
            vegetarianSection
        }
    }

    private var congratulation: some View {
        Button {
            router.presentSheet(.achievement)
        } label: {
            Text("You did it, Well Done!")
                .font(.headline)
                .foregroundStyle(.accent)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                .listSectionBackground
                .contentShape(.rect)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var vegetarianSection: some View {
        if let prayer = journeyService.currentPrayer, journeyService.vegetarianDayIn > 0 {
            let message: LocalizedStringKey = prayer.isVegetarian ? "Today is vegetarian day." : "Vegetarian day in \(journeyService.vegetarianDayIn)"
            Text(message)
                .font(.headline)
                .foregroundStyle(.red)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                .listSectionBackground
        }
    }

    @ViewBuilder
    private var todayMantra: some View {
        if let prayer = journeyService.currentPrayer {
            VStack(spacing: 10) {
                HStack {
                    Text(prayer.day.localized(to: userPreferences.appLanguage))
                    Spacer()
                    Text("Adhitthan Stage (\(journeyService.displayStage))")
                }
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.accent)

                Text(prayer.mantra)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.textPrimary)
                    .multilineTextAlignment(.center)

                Text("Bead count (\(prayer.rounds))")
                    .font(.body)
                    .foregroundStyle(.textSecondary)
            }
            .padding()
            .listSectionBackground
            .contentShape(.rect)
            .onTapGesture {
                router.selectedTab = .practice
            }
        }
    }

    private var currentStageCompletion: some View {
        let currentDay = journeyService.displayDay + (journeyService.isTodayCompleted ? 1 : 0)
        let progress = Double(currentDay) / 9.0
        let percentage = progress * 100

        return VStack {
            Text("Adhitthan Stage (\(journeyService.displayStage))")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.textPrimary)

            ProgressView(value: Double(currentDay), total: 9) {} currentValueLabel: {
                HStack {
                    Text("\(String(format: "%.1f", percentage))%")
                    Spacer()
                    Text("\(currentDay) / 9 Days")
                }
                .font(.subheadline)
                .foregroundStyle(.textPrimary)
            }
            .progressViewStyle(CustomProgressViewStyle(height: 20))
        }
        .padding()
        .listSectionBackground
        .contentShape(.rect)
        .onTapGesture {
            if let currentStage = journeyService.currentStage {
                router.selectedTab = .stages
                router.navigateTo(.stageDetails(currentStage), for: .stages)
            }
        }
    }

    private var completionSection: some View {
        VStack {
            Text("Adhitthan Progress")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.textPrimary)

            HStack {
                ZStack {
                    CircularProgressView(progress: journeyService.totalProgress)

                    // Center text
                    Text("\(journeyService.totalCompletedDays) / \(journeyService.totalDays)")
                        .font(.headline)
                        .foregroundStyle(.textPrimary)
                }
                .padding()

                VStack(spacing: 20) {
                    Text("\(String(format: "%.1f", journeyService.totalProgress * 100)) %")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .frame(maxWidth: .infinity)
                        .background(
                            Capsule(style: .circular)
                                .fill(.accent)
                        )
                    HStack {
                        Image(systemName: "staroflife.fill")
                            .font(.caption2)

                        Text("\(journeyService.daysRemaining) days left.")
                            .lineLimit(1, reservesSpace: true)
                            .foregroundStyle(.textPrimary)
                    }
                }
            }
        }
        .padding()
        .listSectionBackground
    }

    @ViewBuilder
    private var completedTodayView: some View {
        if journeyService.isTodayCompleted {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                Text("Completed for Today")
                    .fontWeight(.bold)
                    .foregroundStyle(.textPrimary)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green.opacity(0.1))
            .cornerRadius(26)
        }
    }

    @ViewBuilder
    private var achievement: some View {
        #if DEBUG
            Button("", systemImage: "star.hexagon") {
                router.presentSheet(.achievement)
            }
        #endif
    }
}

#Preview("Not Started") {
    HomeScreen()
        .previewEnviroments(state: .notStarted)
}

#Preview("Scheduled") {
    HomeScreen()
        .previewEnviroments(state: .scheduled(startDate: .now))
}

#Preview("Missed Day") {
    HomeScreen()
        .previewEnviroments(state: .missedDay(date: .now))
}

#Preview("Completed All") {
    HomeScreen()
        .previewEnviroments(state: .completedAll)
}
