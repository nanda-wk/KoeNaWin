//
//  TabScreen.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import SwiftUI

struct TabScreen: View {
    @EnvironmentObject private var configManager: ConfigManager
    @State private var path = NavigationPath()

    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }

    var body: some View {
        TabView(selection: $configManager.selectedTab) {
            NavigationStack {
                HomeScreen(path: $path)
            }
            .tabItem {
                Label("home-tab", systemImage: "house.fill")
            }
            .tag(TabItem.home)

            NavigationStack {
                PracticeScreen()
            }
            .tabItem {
                Label("practice-tab", systemImage: "leaf.fill")
            }
            .tag(TabItem.practice)

            NavigationStack(path: $path) {
                StagesScreen()
            }
            .tabItem {
                Label("stagesScreen-navTitle", systemImage: "squares.leading.rectangle.fill")
            }
            .tag(TabItem.stages)

            NavigationStack {
                SettingsScreen()
            }
            .tabItem {
                Label("settingScreen-navTitle", systemImage: "gearshape.2.fill")
            }
            .tag(TabItem.settings)
        }
        .onChange(of: configManager.selectedTab) { _ in
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
        .previewEnvironment()
}
