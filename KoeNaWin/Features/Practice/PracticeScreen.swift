//
//  PracticeScreen.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import SwiftUI

struct PracticeScreen: View {
    @EnvironmentObject private var configManager: ConfigManager
    @EnvironmentObject private var vm: HomeViewModel
    @AppStorage("count") private var count = 0
    @AppStorage("round") private var round = 0
    @State private var showDialog = false
    @State private var showComplete = false
    @State private var showAlert = false
    @State private var alertMessage: LocalizedStringKey = ""
    private let totalCount = 108

    private var isLocked: Bool {
        if vm.todayCompleted { return true }

        switch vm.status {
        case .active: return false
        case .missedDay, .completed, .notStarted, .notMonday, .willStart:
            return true
        }
    }

    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()

            VStack {
                VStack {
                    Text(vm.currentPrayer?.day.localized(to: configManager.appLanguage) ?? "")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundStyle(.accent)
                        .padding(.bottom, 4)

                    Text(vm.currentPrayer?.mantra ?? "")
                        .lineLimit(2, reservesSpace: true)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                }

                Spacer()

                VStack {
                    Text("\(count.description)")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .monospaced()
                        .foregroundStyle(.accent)

                    Button {
                        Haptic.impact(.soft).generate()
                        addCount()
                    } label: {
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
                    .buttonStyle(PressableButtonStyle())
                }
                .padding(.vertical, 15)

                Spacer()

                HStack(spacing: 20) {
                    Text("practiceScreen-total-beads-\(round.description) /\((vm.currentPrayer?.rounds ?? 0).description)")
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
                        showDialog.toggle()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.footnote)
                            .foregroundStyle(.white)
                            .padding(12)
                            .background(
                                Circle()
                                    .fill()
                            )
                    }

                    Text("Count: \(count.description) /\(totalCount.description)")
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
            .padding()
            .padding(.bottom)
        }
        .confirmationDialog("practiceScreen-confirmDialog", isPresented: $showDialog, titleVisibility: .visible) {
            Button("yes", action: resetCount)
        }
        .alert("practiceScreen-alert", isPresented: $showComplete) {
            Button("finished", action: markTodayComplete)
            Button("cancel", role: .cancel, action: {})
        }
        .alert("", isPresented: $showAlert, actions: {}) {
            Text(alertMessage)
        }
        .navigationTitle("practiceScreen-navTitle")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if case .active = vm.status, !vm.todayCompleted {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("finished") {
                        showComplete.toggle()
                    }
                }
            }
        }
    }
}

extension PracticeScreen {
    private func addCount() {
        if checkStatus() {
            showAlert.toggle()
            return
        }

        count += 1
        if count > totalCount {
            count = 1
            round += 1
        }

        let prayerRound = vm.currentPrayer?.rounds ?? 0
        if round == prayerRound {
            markTodayComplete()
        }
    }

    private func resetCount() {
        count = 0
        round = 0
        Haptic.notification(.warning).generate()
    }

    private func markTodayComplete() {
        Haptic.notification(.success).generate()
        vm.markTodayComplete()
    }

    private func checkStatus() -> Bool {
        var result = false

        if vm.todayCompleted {
            alertMessage = "practiceScreen-todayCompleted-alertMessage"
            return true
        }

        switch vm.status {
        case .active:
            result = false
        case let .missedDay(failureDate):
            alertMessage = "noticeCard-missedDay-title-\(failureDate.toStringWith(format: .yyyy_MMMM_d))"
            result = true
        case .completed:
            alertMessage = "noticeCard-completed-message"
            result = true
        case .notStarted:
            alertMessage = "noticeCard-notStarted-title"
            result = true
        case let .notMonday(nextMonday):
            alertMessage = "noticeCard-notMonday-message-\(nextMonday.toStringWith(format: .yyyy_MMMM_d))"
            result = true
        case .willStart:
            alertMessage = "noticeCard-willStart-title"
            result = true
        }

        return result
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
            .previewEnvironment()
    }
}
