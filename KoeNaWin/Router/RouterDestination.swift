//
//  RouterDestination.swift
//  KoeNaWin
//
//  Created by Nanda Win Kyu on 2026-02-08.
//

import SwiftUI

enum RouterDestination: Hashable {
    case home
    case practice
    case stages
    case stageDetails(KoeNaWinStage)
    case settings
}

extension View {
    func withRouterDestination() -> some View {
        navigationDestination(for: RouterDestination.self) { destination in
            switch destination {
            case .home:
                HomeScreen()
            case .practice:
                PracticeScreen()
            case .stages:
                StagesScreen()
            case let .stageDetails(stage):
                StageDetailsView(stage: stage)
            case .settings:
                SettingsScreen()
            }
        }
    }
}
