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
                Label("ပင်မစာမျက်နှာ", systemImage: "house.fill")
            }

            NavigationStack {
                PracticeScreen()
            }
            .tabItem {
                Label("အဓိဌာန်ကျင့်စဉ်", systemImage: "leaf.fill")
            }

            NavigationStack {
                StagesScreen()
            }
            .tabItem {
                Label("အဓိဌာန်အဆင့်", systemImage: "squares.leading.rectangle.fill")
            }

            NavigationStack {
                SettingsScreen()
            }
            .tabItem {
                Label("ပြင်ဆင်ချက်", systemImage: "gearshape.2.fill")
            }
        }
    }
}

#Preview {
    TabScreen()
        .previewEnvironment()
}
