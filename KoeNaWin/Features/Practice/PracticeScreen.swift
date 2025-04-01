//
//  PracticeScreen.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import SwiftUI

struct PracticeScreen: View {
    @EnvironmentObject private var vm: HomeViewModel
    @AppStorage("count") private var count = 0
    @AppStorage("round") private var round = 0
    @State private var showDialog = false
    private let totalCount = 108

    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()

            if case .active = vm.status, !vm.todayCompleted {
                VStack {
                    Text(vm.currentPrayer?.day.desc ?? "")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundStyle(.accent)
                        .padding(.bottom, 4)

                    Text(vm.currentPrayer?.mantra ?? "")
                        .lineLimit(2, reservesSpace: true)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 40, weight: .bold, design: .rounded))

                    Spacer()

                    Text("\(count.toMyanmarDigits())")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .monospaced()
                        .foregroundStyle(.accent)

                    Button {
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

                            Text("Count")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundStyle(.accent)
                        }
                    }
                    .buttonStyle(PressableButtonStyle())

                    Spacer()

                    HStack(spacing: 20) {
                        Text("အပတ်ရေ: \(round.toMyanmarDigits()) /\((vm.currentPrayer?.rounds ?? 0).toMyanmarDigits())")
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

                        Text("Count: \(count.toMyanmarDigits()) /\(totalCount.toMyanmarDigits())")
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
            } else {
                NoticeCard(status: vm.status)
            }
        }
        .confirmationDialog("အဓိဌာန် အစမှ ပြန်စမလား?", isPresented: $showDialog, titleVisibility: .visible) {
            Button("အစမှ ပြန်စမည်။", role: .destructive, action: resetCount)
            Button("မလုပ်တော့ပါ", role: .cancel, action: {})
        }
        .navigationTitle("ဒီနေ့ အဓိဌာန်")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension PracticeScreen {
    private func addCount() {
        count += 1
        if count > totalCount {
            count = 1
            round += 1
        }

        let prayerRound = vm.currentPrayer?.rounds ?? 0
        if round == prayerRound {
            vm.markTodayComplete()
        }
    }

    private func resetCount() {
        count = 0
        round = 0
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
