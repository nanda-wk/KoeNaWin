//
//  PracticeScreen.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import SwiftUI

struct PracticeScreen: View {
    @EnvironmentObject private var store: KoeNaWinStore
    @EnvironmentObject private var progressService: UserProgressService
    @EnvironmentObject private var userPreferences: UserPreferences

    @State private var isPresented = false
    @State private var resetPresented = false
    @State private var finishPresented = false

    @State private var message: LocalizedStringKey = ""

    private var isLocked: Bool {
        if progressService.isTodayCompleted {
            return true
        }

        switch progressService.practiceState {
        case .started:
            return false
        default:
            return true
        }
    }

    var body: some View {
        VStack {
            prayerInfo
            Spacer()
            beadButton
            Spacer()
            beadsCountInfo
        }
        .padding()
        .padding(.bottom)
        .background(.appBackground, ignoresSafeAreaEdges: .all)
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
        .navigationTitle("Today's Adhitthan")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !isLocked {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Finished") {}
                }
            }
        }
    }
}

extension PracticeScreen {
    @ViewBuilder
    private var prayerInfo: some View {
        if let prayer = progressService.currentPrayer {
            VStack {
                Text(prayer.day.localized(to: userPreferences.appLanguage))
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(.accent)
                    .padding(.bottom, 4)

                Text(prayer.mantra)
                    .lineLimit(2, reservesSpace: true)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 30, weight: .bold, design: .rounded))

                Text(userPreferences.buddhaAttributes[prayer.mantra] ?? "")
                    .font(.caption)
                    .italic()
                    .foregroundStyle(.accent)
            }
        }
    }

    private var beadButton: some View {
        VStack {
            if let _ = progressService.currentPrayer {
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
                        .frame(width: 250, height: 250)

                    Circle()
                        .fill(
                            .accent.opacity(0.5)
                        )
                        .frame(width: 230, height: 230)

                    VStack {
                        if isLocked {
                            Image(systemName: "lock")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(.accent)
                        }

                        Text("Count")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundStyle(.accent)
                            .opacity(isLocked ? 0.2 : 1)
                    }
                }
            }
        }
        .padding(.vertical, 15)
    }

    private var beadsCountInfo: some View {
        HStack(spacing: 20) {
            Text("Total beads: \(userPreferences.round) / \(progressService.currentPrayer?.rounds ?? 0)")
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
        if userPreferences.round == progressService.currentPrayer?.rounds ?? 0 {
            saveDailyProgress()
        }
    }

    private func saveDailyProgress() {
        Haptic.notification(.success).generate()
        try? progressService.saveDailyProgress(status: .completed)
    }

    private func resetBeads() {
        userPreferences.count = 0
        userPreferences.round = 0
    }

    private func isValid() -> Bool {
        if progressService.isTodayCompleted {
            message = "You have already completed today’s Adhitthan."
            return false
        }

        switch progressService.practiceState {
        case .started:
            message = ""
            return true
        case .notStarted:
            message = "No Adhitthan yet."
            return false
        case let .scheduled(startDate):
            message = "Adhitthan will start on \(startDate.toStringWith(format: .yyyy_MMMM_d))."
            return false
        case let .missedDay(date):
            message = "Missed Adhitthan on \(date.toStringWith(format: .yyyy_MMMM_d))."
            return false
        case .completedAll:
            message = "No Adhitthan yet."
            return false
        }
    }
}

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.2), value: configuration.isPressed)
    }
}

#Preview {
    NavigationStack {
        PracticeScreen()
            .previewEnviroments(state: .completedAll)
    }
}
