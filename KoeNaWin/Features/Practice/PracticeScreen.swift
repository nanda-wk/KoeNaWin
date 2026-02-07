//
//  PracticeScreen.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import SwiftUI

struct PracticeScreen: View {
    @EnvironmentObject var store: KoeNaWinStore

    private var isLocked: Bool {
        true
    }

    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()

            VStack {
                VStack {
                    Text("Tuesday")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundStyle(.accent)
                        .padding(.bottom, 4)

                    Text("ဘဂဝါ")
                        .lineLimit(2, reservesSpace: true)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                }

                Spacer()

                VStack {
                    Text("8")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .monospaced()
                        .foregroundStyle(.accent)
                        .contentTransition(.numericText())

                    Button {
                        Haptic.impact(.soft).generate()
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
                }
                .padding(.vertical, 15)

                Spacer()

                HStack(spacing: 20) {
                    Text("Total beads: 1 /8")
                        .font(.footnote)
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
                            .font(.footnote)
                            .foregroundStyle(.white)
                            .padding(12)
                            .background(
                                Circle()
                                    .fill(.accent)
                            )
                    }
                    .buttonStyle(.plain)

                    Text("Count: 0 /108")
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
        .alert("Do you want to reset beads count?", isPresented: .constant(false)) {
            Button("Yes", role: .destructive, action: {})
            Button("Cancel", role: .cancel, action: {})
        }
        .alert("Today’s Adhitthan finished.", isPresented: .constant(false)) {
            Button("Cancel", action: {})
            Button("Finished", action: {})
        }
        .alert("", isPresented: .constant(false), actions: {}) {
            Text("alertMessage")
        }
        .navigationTitle("Today's Adhitthan")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Finished") {}
            }
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
    }
}
