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
                        StageCell(stage: stage.stage)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("stagesScreen-navTitle")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: KoeNaWinStage.self) { stage in
            StageDetailsView(stage: stage)
        }
    }
}

extension StagesScreen {
    private func StageCell(stage: Int) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "\(stage).circle.fill")
                .foregroundStyle(.primary)

            Text("addhithan-stage-\(stage.description)")
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
