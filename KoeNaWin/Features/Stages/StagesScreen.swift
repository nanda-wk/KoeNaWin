//
//  StagesScreen.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import SwiftUI

struct StagesScreen: View {
    @EnvironmentObject private var store: KoeNaWinStore
    @StateObject private var router = Router()

    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationTitle("Stages")
                .navigationBarTitleDisplayMode(.inline)
                .withRouterDestination()
        }
        .environmentObject(router)
    }
}

extension StagesScreen {
    private var content: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(store.stages) { stage in
                    Button {
                        router.navigate(to: .stageDetails(stage))
                    } label: {
                        StageCell(stage: stage.stage)
                    }
                }
            }
            .padding()
        }
        .scrollIndicators(.never)
        .background(.appBackground)
    }

    private func StageCell(stage: Int) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "\(stage).circle.fill")
                .foregroundStyle(.textPrimary)

            Text("Adhitthan Stage (\(stage.description))")
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundStyle(.textPrimary)

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.textSecondary)
        }
        .padding()
        .listSectionBackground
    }
}

#Preview {
    StagesScreen()
        .previewEnviroments()
}
