//
//  PracticeScreen.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import SwiftUI

struct PracticeScreen: View {
    @EnvironmentObject private var store: KoeNaWinStore
    @EnvironmentObject private var journeyService: JourneyService
    @EnvironmentObject private var userPreferences: UserPreferences

    @State private var isPresented = false
    @State private var resetPresented = false
    @State private var finishPresented = false

    @State private var message: LocalizedStringKey = ""

    private var isLocked: Bool {
        if journeyService.isTodayCompleted {
            return true
        }

        switch journeyService.practiceState {
        case .started:
            return false
        default:
            return true
        }
    }

    private var width: CGFloat {
        UIScreen.current?.bounds.size.width ?? 0
    }

    var body: some View {
        content
            .navigationTitle("Today's Adhitthan")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Do you want to reset beads count?", isPresented: $resetPresented) {
                Button("Yes", role: .destructive, action: resetBeads)
                Button("Cancel", role: .cancel, action: {})
                    .tint(.textPrimary)
            }
            .alert("Today’s Adhitthan finished.", isPresented: $finishPresented) {
                Button("Cancel", role: .cancel, action: {})
                Button("Finished", action: saveDailyProgress)
            }
            .alert("", isPresented: $isPresented, actions: {}) {
                Text(message)
            }
            .toolbar {
                if !isLocked {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Finished") {
                            finishPresented.toggle()
                        }
                    }
                }
            }
    }
}

extension PracticeScreen {
    private var content: some View {
        VStack {
            prayerInfo
            Spacer()
            beadButton
            Spacer()
            beadsCountInfo
        }
        .padding()
        .background(.appBackground, ignoresSafeAreaEdges: .all)
    }

    @ViewBuilder
    private var prayerInfo: some View {
        if let prayer = journeyService.currentPrayer {
            VStack(spacing: 24) {
                Text(prayer.day.localized(to: userPreferences.appLanguage))
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(.accent)

                Text(prayer.mantra)
                    .font(.title)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.textPrimary)

                Text(userPreferences.buddhaAttributes[prayer.mantra] ?? "")
                    .font(.caption)
                    .italic()
                    .foregroundStyle(.accent)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .minimumScaleFactor(0.8)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    @ViewBuilder
    private var beadButton: some View {
        let outerSize: CGFloat = width * 0.6
        let innerSize: CGFloat = width * 0.6 - 20

        VStack {
            if let _ = journeyService.currentPrayer {
                Text("\(userPreferences.count)")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .monospaced()
                    .foregroundStyle(.accent)
                    .contentTransition(.numericText())
            }

            Button(action: addBead) {
                ZStack {
                    Circle()
                        .stroke(.accent, lineWidth: 10)
                        .frame(width: outerSize, height: outerSize)

                    Circle()
                        .fill(.accent.opacity(0.5))
                        .frame(width: innerSize, height: innerSize)

                    VStack {
                        if isLocked {
                            Image(systemName: "lock")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(.accent)
                        }

                        Text("Count")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.accent)
                            .opacity(isLocked ? 0.2 : 1)
                    }
                }
            }
            .buttonStyle(PressableButtonStyle())
        }
        .padding(.vertical, 15)
    }

    private var beadsCountInfo: some View {
        HStack(spacing: 20) {
            Text("Total beads: \(userPreferences.round) / \(journeyService.currentPrayer?.rounds ?? 0)")
                .font(.footnote)
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    Capsule()
                        .fill(.accent)
                )

            Button {
                resetPresented.toggle()
            } label: {
                Image(systemName: "arrow.clockwise")
                    .font(.footnote)
                    .foregroundStyle(.white)
                    .padding(12)
                    .background(
                        Circle()
                            .fill(.accent)
                    )
            }
            .buttonStyle(.plain)

            Text("Count: \(userPreferences.count) / \(userPreferences.beadsType)")
                .font(.footnote)
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    Capsule()
                        .fill(.accent)
                )
        }
    }
}

extension PracticeScreen {
    private func addBead() {
        guard isValid() else {
            isPresented.toggle()
            return
        }
        userPreferences.count += 1
        if userPreferences.count == userPreferences.beadsType {
            userPreferences.count = 0
            userPreferences.round += 1
        }
        Haptic.impact(.soft).generate()
        if userPreferences.round == journeyService.currentPrayer?.rounds ?? 0 {
            saveDailyProgress()
        }
    }

    private func saveDailyProgress() {
        Haptic.notification(.success).generate()
        userPreferences.resetbeads()
        try? journeyService.completeToday()
    }

    private func resetBeads() {
        userPreferences.resetbeads()
    }

    private func isValid() -> Bool {
        if journeyService.isTodayCompleted {
            message = "You have already completed today’s Adhitthan."
            return false
        }

        switch journeyService.practiceState {
        case .started:
            message = ""
            return true
        case .notStarted:
            message = "You have no active Adhitthan"
            return false
        case let .scheduled(startDate):
            message = "Adhitthan will start on \(startDate.toStringWith(format: .yyyy_MMMM_d))."
            return false
        case let .missedDay(date):
            message = "Missed Adhitthan on \(date.toStringWith(format: .yyyy_MMMM_d))."
            return false
        case .completedAll:
            message = "You have achieved your Adhitthan."
            return false
        }
    }
}

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.smooth, value: configuration.isPressed)
    }
}

#Preview("Started") {
    NavigationStack {
        PracticeScreen()
            .previewEnviroments(state: .started)
    }
}

#Preview("Completed") {
    NavigationStack {
        PracticeScreen()
            .previewEnviroments(state: .completedAll)
    }
}

#Preview("Not Started") {
    NavigationStack {
        PracticeScreen()
            .previewEnviroments(state: .notStarted)
    }
}
