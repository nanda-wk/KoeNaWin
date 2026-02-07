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
    @EnvironmentObject var store: KoeNaWinStore

    var body: some View {
        content
            .navigationTitle("KoeNaWin")
            .navigationBarTitleDisplayMode(.inline)
    }
}

extension HomeScreen {
    private var content: some View {
        ScrollView {
            VStack(spacing: 25) {
                vegetarianSection
                todayMantra
                currentStageCompletion
                completionSection
            }
            .padding()
        }
        .scrollIndicators(.never)
        .background(.appBackground)
    }

    private var completionSection: some View {
        VStack {
            Text("Adhitthan Progress")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.textPrimary)

            HStack {
                ZStack {
                    // Background circle (remaining days)
                    Circle()
                        .trim(from: 0, to: 1)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 24)
                        .frame(width: 120, height: 120)

                    // Progress circle (completed days)
                    Circle()
                        .trim(from: 0, to: max(0.02, CGFloat(70) / 81.0 - 0.08))
                        .stroke(.accent, style: StrokeStyle(lineWidth: 24, lineCap: .round))
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))

                    // Center text
                    Text("70 / 81")
                        .font(.headline)
                        .foregroundStyle(.textPrimary)
                }
                .padding()

                VStack(spacing: 20) {
                    Text("\(String(format: "%.1f", 44.4)) %")
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

                        Text("11 days left.")
                            .lineLimit(1, reservesSpace: true)
                            .foregroundStyle(.textPrimary)
                    }
                }
            }
        }
        .padding()
        .listSectionBackground
    }

    private var currentStageCompletion: some View {
        VStack {
            Text("Adhitthan Stage (1)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.textPrimary)

            ProgressView(value: Double(7), total: 9) {} currentValueLabel: {
                HStack {
                    Text("\(String(format: "%.1f", 22)) %")
                    Spacer()
                    Text("7 / 9 Days")
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

    @ViewBuilder
    private var vegetarianSection: some View {
        Text("Today is vegetarian day.")
            .font(.headline)
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 10)
            .listSectionBackground
    }
}

#Preview {
    NavigationStack {
        HomeScreen()
            .previewEnviroments()
    }
}
