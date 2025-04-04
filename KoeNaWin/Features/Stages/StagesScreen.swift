//
//  StagesScreen.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import SwiftUI

struct StagesScreen: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(koeNaWinStages) { stage in
                    NavigationLink(value: stage) {
                        LevelCell(title: "အဓိဌာန်အဆင့် (\(stage.stage.toMyanmarDigits()))", level: stage.stage)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("အဓိဌာန်အဆင့်")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: KoeNaWinStage.self) { stage in
            StageDetailsView(stage: stage)
        }
    }
}

extension StagesScreen {
    private func LevelCell(title: String, level: Int) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "\(level).circle.fill")
                .foregroundStyle(.primary)

            Text(title)
                .font(.footnote)
                .fontWeight(.bold)

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.gray)
        }
        .padding()
        .listSectionBackground
    }
}

#Preview {
    NavigationStack {
        StagesScreen()
            .previewEnvironment()
    }
}
