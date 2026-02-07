//
//  StageDetailsView.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import SwiftUI

struct StageDetailsView: View {
    let stage: KoeNaWinStage

    var body: some View {
        content
            .navigationTitle("Adhitthan Stage (\(stage.stage))")
            .navigationBarTitleDisplayMode(.inline)
    }
}

extension StageDetailsView {
    private var content: some View {
        ScrollView {
            VStack(spacing: 25) {
                VStack(alignment: .leading) {
                    Text("အဓိဌာန်အဆင့် (\(stage.stage)) အောင်မြင်ပြီးပါက")
                        .font(.headline)

                    Divider()
                        .foregroundStyle(.appDivider)

                    Text(stage.benefits)
                        .font(.body)
                        .kerning(1)
                }
                .foregroundStyle(.textPrimary)
                .padding()
                .listSectionBackground

                VStack(spacing: 12) {
                    ForEach(Array(stage.prayers.enumerated()), id: \.element.id) { _, prayer in
                        ListCell(prayer: prayer, completed: false)
                    }
                }
            }
            .padding()
        }
        .background(.appBackground)
    }
}

struct ListCell: View {
    @State private var isExpanded = false
    let prayer: Prayer
    let completed: Bool

    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            Text(buddhaAttributes[prayer.mantra] ?? "")
                .font(.body)
                .foregroundStyle(.textPrimary)
                .kerning(1)
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 10) {
                    Text(prayer.day.desc)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.textPrimary)

                    if completed {
                        Image(systemName: "checkmark.seal.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .accent)
                    }

                    if prayer.isVegetarian {
                        Text("သတ်သတ်လွတ်စားရန်။")
                            .font(.callout)
                            .foregroundStyle(.red)
                            .padding(.leading, 15)
                    }
                }

                HStack {
                    Text(prayer.mantra)
                        .font(.body)
                        .fontWeight(.medium)
                    Spacer()
                    Text("(\(prayer.rounds.description))ပတ်")
                        .font(.body)
                }
            }
        }
        .disclosureGroupStyle(CustomDisclosureStyle())
        .padding()
        .listSectionBackground
    }
}

struct CustomDisclosureStyle: DisclosureGroupStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(configuration.isExpanded ? 180 : 0))
                    .animation(.easeInOut, value: configuration.isExpanded)
                    .foregroundColor(.accent)
                    .padding(.top)

                configuration.label
            }

            if configuration.isExpanded {
                Divider()
                    .padding(.vertical, 5)
                    .foregroundStyle(.appDivider)

                configuration.content
                    .disclosureGroupStyle(self)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                configuration.isExpanded.toggle()
            }
        }
    }
}

#Preview {
    NavigationStack {
        StageDetailsView(stage: .preview)
    }
}
