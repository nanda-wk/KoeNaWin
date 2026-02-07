//
//  TabScreen.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import SwiftUI

struct TabScreen: View {
    @State private var selectedTab: TabItem = .home

    //    init() {
    //        let tabBarAppearance = UITabBarAppearance()
    //        tabBarAppearance.configureWithDefaultBackground()
    //        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    //    }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeScreen()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(TabItem.home)

            PracticeScreen()
                .tabItem {
                    Label("Practice", systemImage: "leaf.fill")
                }
                .tag(TabItem.practice)

            StagesScreen()
                .tabItem {
                    Label("Stages", systemImage: "squares.leading.rectangle.fill")
                }
                .tag(TabItem.stages)

            SettingsScreen()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.2.fill")
                }
                .tag(TabItem.settings)
        }
        .onChange(of: selectedTab) { _ in
            Haptic.selection.generate()
        }
    }
}

enum TabItem: Int, Identifiable {
    var id: Int { rawValue }
    case home, practice, stages, settings
}

#Preview {
    TabScreen()
        .previewEnviroments()
}
