//
//  HomeScreen.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import Charts
import Combine
import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject private var store: KoeNaWinStore
    @EnvironmentObject private var progressService: UserProgressService

    @State private var isPresented = false

    private var stage: Int {
        progressService.stage
    }

    var body: some View {
        content
            .navigationTitle("KoeNaWin")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isPresented) {
                CompletedAllView()
            }
    }
}

extension HomeScreen {
    @ViewBuilder
    private var content: some View {
        ZStack {
            Color(.appBackground)
                .ignoresSafeArea()

            switch progressService.practiceState {
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
                vegetarianSection
                todayMantra
                completedTodayView
                currentStageCompletion
                completionSection
            }
            .padding()
        }
        .scrollIndicators(.never)
        .onAppear {
            isPresented = progressService.practiceState == .completedAll
        }
    }

    private var vegetarianSection: some View {
        Text("Today is vegetarian day.")
            .font(.headline)
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 10)
            .listSectionBackground
    }

    private var todayMantra: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Monday")
                Spacer()
                Text("Adhitthan Stage (8)")
            }
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundStyle(.accent)

            Text("ဘဂဝါ")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.textPrimary)

            Text("Bead count (2)")
                .font(.body)
                .foregroundStyle(.textSecondary)
        }
        .padding()
        .listSectionBackground
        .contentShape(Rectangle())
    }

    private var currentStageCompletion: some View {
        let progress = Double(2) / 9.0
        let percentage = Int(progress * 100)

        return VStack {
            Text("Adhitthan Stage (\(stage))")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.textPrimary)

            ProgressView(value: Double(2), total: 9) {} currentValueLabel: {
                HStack {
                    Text("\(percentage)%")
                    Spacer()
                    Text("\(2) / 9 Days")
                }
                .font(.subheadline)
                .foregroundStyle(.textPrimary)
            }
            .progressViewStyle(CustomProgressViewStyle(height: 20))
        }
        .padding()
        .listSectionBackground
        .contentShape(Rectangle())
    }

    private var completionSection: some View {
        VStack {
            Text("Adhitthan Progress")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.textPrimary)

            HStack {
                ZStack {
                    CircularProgressView(progress: 0.75)

                    // Center text
                    Text("70 / 81")
                        .font(.headline)
                        .foregroundStyle(.textPrimary)
                }
                .padding()

                VStack(spacing: 20) {
                    Text("44.4 %")
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

                        Text("\(8) days left.")
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
        if progressService.isTodayCompleted {
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
}

#Preview("Started") {
    NavigationStack {
        HomeScreen()
            .previewEnviroments(state: .started)
    }
}

#Preview("Not Started") {
    NavigationStack {
        HomeScreen()
            .previewEnviroments(state: .notStarted)
    }
}

#Preview("Scheduled") {
    NavigationStack {
        HomeScreen()
            .previewEnviroments(state: .scheduled(startDate: .now))
    }
}

#Preview("Missed Day") {
    NavigationStack {
        HomeScreen()
            .previewEnviroments(state: .missedDay(date: .now))
    }
}

#Preview("Completed All") {
    NavigationStack {
        HomeScreen()
            .previewEnviroments(state: .completedAll)
    }
}
