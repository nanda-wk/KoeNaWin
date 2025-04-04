//
//  View+Extensions.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import SwiftUI

extension View {
    func previewEnvironment(
        initProgess: Bool = true,
        start: Date = .now,
        stage: Int16 = 1,
        day: Int16 = 4
    ) -> some View {
        koeNaWinStages = Bundle.main.decode(KoeNaWinStages.self, from: "KoeNaWin.json")
        if initProgess {
            UserProgress.makePreview(start: start, stage: stage, day: day)
        }
        return environmentObject(ConfigManager())
            .environmentObject(HomeViewModel())
    }
}

extension View {
    var listSectionBackground: some View {
        background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.tertiarySystemBackground))
        )
    }
}
