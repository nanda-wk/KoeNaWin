//
//  View+Extensions.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import SwiftUI

extension View {
    func previewEnviroments(state: PracticeState = .notStarted, isFirstLaunch: Bool = true) -> some View {
        let userPreferences = UserPreferences()
        userPreferences.isFirstLaunch = isFirstLaunch
        let journeyService = JourneyService()
        journeyService.setupForPreview(state: state)

        return environmentObject(KoeNaWinStore.shared)
            .environmentObject(Router())
            .environmentObject(userPreferences)
            .environmentObject(journeyService)
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
