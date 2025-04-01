//
//  StageDetailsView.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import SwiftUI

struct StageDetailsView: View {
    @EnvironmentObject private var vm: HomeViewModel
    let stage: KoeNaWinStage

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading) {
                    Text("အဓိဌာန်အဆင့် (\(stage.stage.toMyanmarDigits())) အောင်မြင်ပြီးပါက")
                        .font(.headline)

                    Divider()

                    Text(stage.benefits)
                        .font(.body)
                }
            }

            ForEach(Array(stage.prayers.enumerated()), id: \.element.id) { index, prayer in
                let completed = vm.stage == stage.stage && vm.day == index + 1
                Section {
                    ListCell(prayer: prayer, completed: completed)
                }
                .listSectionSpacing(12)
            }
        }
        .listSectionSpacing(25)
        .navigationTitle("အဓိဌာန်အဆင့် (\(stage.stage.toMyanmarDigits()))")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            vm.checkProgress()
        }
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
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 10) {
                    Text(prayer.day.desc)
                        .font(.title2)
                        .fontWeight(.bold)

                    if completed {
                        Image(systemName: "checkmark.seal.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .accent)
                    }

                    if prayer.isVegetarian {
                        Text("သတ်သတ်လွတ်စားရန်။")
                            .font(.callout)
                            .foregroundStyle(.red)
                    }
                }

                HStack {
                    Text(prayer.mantra)
                        .font(.body)
                        .fontWeight(.medium)
                    Spacer()
                    Text("(\(prayer.rounds.toMyanmarDigits()))ပတ်")
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
