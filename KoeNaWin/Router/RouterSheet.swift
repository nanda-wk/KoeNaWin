//
//  RouterSheet.swift
//  KoeNaWin
//
//  Created by Nanda Win Kyu on 2026-02-12.
//

import SwiftUI

enum RouterSheet: Hashable, Identifiable {
    var id: Int { hashValue }
    case journey(JourneyScreen.JourneyMode)
    case achievement
}

struct SheetDestinations: ViewModifier {
    @ObservedObject var router: Router

    func body(content: Content) -> some View {
        content
            .fullScreenCover(item: $router.presentedSheet) { sheet in
                Group {
                    switch sheet {
                    case let .journey(mode):
                        JourneyScreen(mode: mode)
                    case .achievement:
                        AchievementScreen()
                    }
                }
                .environmentObject(router)
            }
    }
}
