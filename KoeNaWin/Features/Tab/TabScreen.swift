//
//  TabScreen.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import SwiftUI

struct TabScreen: View {
    @EnvironmentObject private var preferences: UserPreferences
    @EnvironmentObject private var router: Router

    var body: some View {
        TabView(selection: $router.selectedTab) {
            ForEach(TabItem.allCases) { tab in
                NavigationStack(path: $router[tab]) {
                    tab.view
                        .withRouterDestination()
                }
                .tabItem {
                    Label(tab.title, systemImage: tab.icon)
                }
                .tag(tab)
            }
        }
        .onChange(of: router.selectedTab) { _ in
            Haptic.selection.generate()
        }
        .modifier(SheetDestinations(router: router))
        .onAppear {
            if preferences.isFirstLaunch {
                router.presentSheet(.journey(.onboarding))
            }
        }
    }
}

enum TabItem: Int, Identifiable, CaseIterable {
    var id: Int { rawValue }
    case home, practice, stages, settings

    var title: LocalizedStringKey {
        switch self {
        case .home:
            "Home"
        case .practice:
            "Practice"
        case .stages:
            "Stages"
        case .settings:
            "Settings"
        }
    }

    var icon: String {
        switch self {
        case .home:
            "house.fill"
        case .practice:
            "leaf.fill"
        case .stages:
            "squares.leading.rectangle.fill"
        case .settings:
            "gearshape.2.fill"
        }
    }

    @ViewBuilder
    var view: some View {
        switch self {
        case .home:
            HomeScreen()
        case .practice:
            PracticeScreen()
        case .stages:
            StagesScreen()
        case .settings:
            SettingsScreen()
        }
    }
}

#Preview {
    TabScreen()
        .previewEnviroments()
}
