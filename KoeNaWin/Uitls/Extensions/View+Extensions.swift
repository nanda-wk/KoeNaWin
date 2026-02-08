//
//  View+Extensions.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import SwiftUI

extension View {
    func previewEnviroments() -> some View {
        environmentObject(KoeNaWinStore())
            .environmentObject(Router())
            .environmentObject(UserPreferences())
            .environmentObject(UserProgressService())
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
