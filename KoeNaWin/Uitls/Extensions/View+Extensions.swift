//
//  View+Extensions.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import SwiftUI

extension View {
    func previewEnviroments(state: PracticeState = .notStarted) -> some View {
        environmentObject(KoeNaWinStore.shared)
            .environmentObject(Router())
            .environmentObject(UserPreferences())
            .environmentObject(UserProgressService(initialState: state))
    }
}

extension View {
    var listSectionBackground: some View {
        background(
            RoundedRectangle(cornerRadius: 26)
                .fill(.appContent)
        )
    }
}
