//
//  PracticeScreen.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import SwiftUI

struct PracticeScreen: View {
    @State private var count = 0
    @State private var round = 0
    private let totalCount = 108

    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()

            VStack {
                Text("သုဂတော")
                    .lineLimit(2, reservesSpace: true)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 50, weight: .bold, design: .rounded))

                Spacer()

                Text("\(count)")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
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
                    Text("အပတ်ရေ: \(round) /9")
                        .font(.callout)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(
                            Capsule()
                                .fill(.accent)
                        )

                    Button {} label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.callout)
                            .foregroundStyle(.white)
                            .padding(12)
                            .background(
                                Circle()
                                    .fill()
                            )
                    }

                    Text("Count: \(count) /\(totalCount)")
                        .font(.headline)
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
        .navigationTitle("ဒီနေ့ အဓိဌာန်")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension PracticeScreen {
    private func addCount() {
        count += 1
        if count >= totalCount {
            count = 0
            round += 1
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
