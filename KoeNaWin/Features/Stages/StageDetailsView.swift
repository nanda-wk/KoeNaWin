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
        ScrollView {
            VStack(spacing: 25) {
                Section {
                    VStack(alignment: .leading) {
                        Text("stageDetailsView-section-text-\(stage.stage)")
                            .font(.headline)

                        Divider()

                        Text(stage.benefits)
                            .font(.body)
                    }
                }
                .padding()
                .listSectionBackground

                VStack(spacing: 12) {
                    ForEach(Array(stage.prayers.enumerated()), id: \.element.id) { index, prayer in
                        var completed: Bool {
                            if vm.stage <= stage.stage {
                                vm.stage >= stage.stage && vm.day >= index + 1
                            } else {
                                true
                            }
                        }
                        ListCell(prayer: prayer, completed: completed)
                    }
                }
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("addhithan-stage-\(stage.stage)")
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
                        Text("stagesScreen-listCell-isVegetarian")
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
                    Text("(\(prayer.rounds))ပတ်")
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
            .previewEnvironment()
    }
}
