//
//  AchievementScreen.swift
//  KoeNaWin
//
//  Created by Nanda Win Kyu on 2026-02-08.
//

import SwiftUI

struct AchievementScreen: View {
    private let parchmentColor = Color(red: 0.98, green: 0.96, blue: 0.95)

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                // Background Card
                RoundedRectangle(cornerRadius: 40, style: .continuous)
                    .fill(parchmentColor)
                    .shadow(color: Color.black.opacity(0.05), radius: 20, x: 0, y: 10)

                // Corner Brackets
                VStack {
                    HStack {
                        CornerBracket(orientation: .topLeft)
                        Spacer()
                        CornerBracket(orientation: .topRight)
                    }
                    Spacer()
                    HStack {
                        CornerBracket(orientation: .bottomLeft)
                        Spacer()
                        CornerBracket(orientation: .bottomRight)
                    }
                }
                .padding(32)

                // Content
                VStack(spacing: 24) {
                    Text("ACHIEVEMENT UNLOCKED")
                        .font(.system(size: 14, weight: .semibold, design: .monospaced))
                        .kerning(4)
                        .foregroundStyle(.textSecondary)

                    // Progress Circle
                    ZStack {
                        Circle()
                            .stroke(.accent.opacity(0.1), lineWidth: 4)
                            .frame(width: 140, height: 140)

                        Circle()
                            .stroke(.accent, lineWidth: 8)
                            .frame(width: 140, height: 140)

                        VStack(spacing: -4) {
                            Text("9/9")
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                                .foregroundStyle(.accent)
                            Text("STAGES")
                                .font(.system(size: 12, weight: .medium))
                                .kerning(2)
                                .foregroundStyle(.textSecondary)
                        }
                    }
                    .padding(.vertical, 8)

                    VStack(spacing: 12) {
                        Text("Koe Na Win")
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color(red: 0.1, green: 0.15, blue: 0.25))

                        HStack(spacing: 6) {
                            Circle().fill(.accent.opacity(0.3)).frame(width: 4, height: 4)
                            Text("ZEN MASTER MASTERY")
                                .font(.system(size: 12, weight: .bold))
                                .kerning(1)
                                .foregroundStyle(.textSecondary)
                            Circle().fill(.accent.opacity(0.3)).frame(width: 4, height: 4)
                        }

                        Text("\"The mind is everything. What you\nthink you become.\"")
                            .font(.system(size: 16, weight: .medium).italic())
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.textSecondary)
                            .padding(.horizontal, 20)
                    }

                    Spacer(minLength: 0)

                    Text("OCTOBER 24, 2023")
                        .font(.system(size: 12, weight: .medium))
                        .kerning(2)
                        .foregroundStyle(.textSecondary)
                }
                .padding(.vertical, 50)
                .padding(.horizontal, 30)
            }
            .aspectRatio(0.75, contentMode: .fit)
            .padding(24)
        }
    }
}

private struct CornerBracket: View {
    enum Orientation {
        case topLeft, topRight, bottomLeft, bottomRight
    }

    let orientation: Orientation
    let length: CGFloat = 20
    let thickness: CGFloat = 1

    var body: some View {
        ZStack {
            if orientation == .topLeft || orientation == .bottomLeft {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: thickness, height: length)
                    .offset(x: -length / 2)
            }
            if orientation == .topLeft || orientation == .topRight {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: length, height: thickness)
                    .offset(y: -length / 2)
            }
            if orientation == .topRight || orientation == .bottomRight {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: thickness, height: length)
                    .offset(x: length / 2)
            }
            if orientation == .bottomLeft || orientation == .bottomRight {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: length, height: thickness)
                    .offset(y: length / 2)
            }
        }
        .frame(width: length, height: length)
    }
}

#Preview {
    AchievementScreen()
}
