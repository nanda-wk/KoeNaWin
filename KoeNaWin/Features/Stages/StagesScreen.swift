//
//  StagesScreen.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import SwiftUI

struct StagesScreen: View {
    var body: some View {
        List {
            ForEach(koeNaWinStages) { stage in
                Section {
                    NavigationLink {
                        StageDetailsView(stage: stage)
                        Text("Stage \(stage.stage)")
                    } label: {
                        LevelCell(title: "အဓိဌာန်အဆင့် (\(stage.stage))", level: stage.stage)
                    }
                }
            }
        }
        .listSectionSpacing(12)
        .navigationTitle("အဓိဌာန်အဆင့်")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension StagesScreen {
    private func LevelCell(title: String, level: Int) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "\(level).circle.fill")
                .foregroundStyle(.black)

            Text(title)
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    NavigationStack {
        StagesScreen()
            .previewEnvironment()
    }
}
