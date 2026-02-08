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
                    Text("22%")
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
