//
//  TabScreen.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import SwiftUI

struct TabScreen: View {
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    var body: some View {
        TabView {
            NavigationStack {
                HomeScreen()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            NavigationStack {
                PracticeScreen()
            }
            .tabItem {
                Label("Practice", systemImage: "leaf.fill")
            }

            NavigationStack {
                StagesScreen()
            }
            .tabItem {
                Label("Stages", systemImage: "squares.leading.rectangle.fill")
            }

            NavigationStack {
                SettingsScreen()
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape.2.fill")
            }
        }
    }
}

#Preview {
    TabScreen()
}
