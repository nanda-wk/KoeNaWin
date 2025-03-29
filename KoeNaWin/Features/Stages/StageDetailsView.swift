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
        List {
            Section {
                VStack(alignment: .leading) {
                    Text("အဓိဌာန်အဆင့် (\(stage.stage)) အောင်မြင်ပြီးပါက")
                        .font(.headline)

                    Divider()

                    Text(stage.benefits)
                        .font(.body)
                }
            }

            ForEach(stage.prayers) { prayer in
                Section {
                    ListCell(prayer: prayer)
                }
                .listSectionSpacing(12)
            }
        }
        .listSectionSpacing(25)
        .navigationTitle("အဓိဌာန်အဆင့် (\(stage.stage))")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ListCell: View {
    @State private var isExpanded = false
    var prayer: Prayer

    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            Text(buddhaAttributes[prayer.mantra] ?? "")
                .font(.body)
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(prayer.day.desc)
                        .font(.title2)
                        .fontWeight(.bold)

                    Image(systemName: "checkmark.seal.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, .accent)

                    if prayer.isVegetarian {
                        Text("ဒီနေ့ အသားမစားရပါ။")
                            .font(.footnote)
                            .foregroundStyle(.red)
                    }
                }

                HStack {
                    Text(prayer.mantra)
                        .font(.body)
                        .fontWeight(.medium)
                    Spacer()
                    Text("(\(prayer.rounds))ပတ်")
                        .font(.body)
                }
            }
        }
        .disclosureGroupStyle(CustomDisclosureStyle())
    }
}

struct CustomDisclosureStyle: DisclosureGroupStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .topTrailing) {
            Image(systemName: "chevron.down")
                .rotationEffect(.degrees(configuration.isExpanded ? 180 : 0))
                .animation(.easeInOut, value: configuration.isExpanded)
                .foregroundColor(.accent)
                .padding(.top)

            configuration.label
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                configuration.isExpanded.toggle()
            }
        }

        if configuration.isExpanded {
            configuration.content
                .disclosureGroupStyle(self)
        }
    }
}

#Preview {
    NavigationStack {
        StageDetailsView(stage: .preview)
            .previewEnvironment()
    }
}
