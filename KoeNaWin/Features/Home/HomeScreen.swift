//
//  HomeScreen.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import SwiftUI
import Charts

struct HomeScreen: View {
    var body: some View {
        List {
            completionSection

            currentStageCompletion

            todayMantra

            vegetarianSection
        }
        .listSectionSpacing(25)
        .navigationTitle("ကိုးနဝင်း")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension HomeScreen {
    var completionSection: some View {
        Section {
            VStack {
                Text("အဓိဌာန်ပြီးမြောက်မှု")
                    .font(.title2)
                    .fontWeight(.bold)

                HStack {
                    Chart {
                        SectorMark(
                            angle: .value("Done", 10),
                            innerRadius: .ratio(0.65),
                            angularInset: 2
                        )
                        .cornerRadius(10)

                        SectorMark(
                            angle: .value("In Progress", 81 - 10),
                            innerRadius: .ratio(0.65),
                            angularInset: 2
                        )
                        .foregroundStyle(.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                    .chartBackground{ proxy in
                        Text("10 / 81")
                    }
                    .padding()

                    VStack(spacing: 20) {
                        Text("10%")
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

                            Text("71 ရက်ကျန်သည်")
                                .lineLimit(1, reservesSpace: true)
                        }
                    }
                }
            }
        }
    }

    var currentStageCompletion: some View {
        Section {
            VStack {
                Text("အဓိဌာန်အဆင့် (2)")
                    .font(.title2)
                    .fontWeight(.bold)

                ProgressView(value: 1, total: 9) {
                } currentValueLabel: {
                    HStack {
                        Text("10%")
                        Spacer()
                        Text("1 / 9 ရက်")
                    }
                    .font(.subheadline)
                }
                .progressViewStyle(CustomProgressViewStyle(height: 20))
            }
        }
    }

    var todayMantra: some View {
        Section {
            VStack(spacing: 10) {
                HStack {
                    Text("တနင်္လာ")
                    Spacer()
                    Text("အဓိဌာန်အဆင့် (2)")
                }
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.accent)


                Text("ဘဂဝါ")
                    .font(.title)
                    .fontWeight(.bold)

                Text("အပတ်ရေ (9)ပတ်")
                    .font(.body)
                    .foregroundStyle(.secondary)

            }
        }
    }

    var vegetarianSection: some View {
        Section {
            Text("3 day untail vegetarian.")
                .foregroundStyle(.white)
        }
        .listRowBackground(
            RoundedRectangle(cornerRadius: 10)
                .fill(.accent)
        )
    }
}

#Preview {
    NavigationStack {
        HomeScreen()
    }
}
