//
//  KoeNaWinApp.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import SwiftUI

@main
struct KoeNaWinApp: App {
    @StateObject private var configManager = ConfigManager()
    @StateObject private var vm = HomeViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                if configManager.hasLoaded {
                    TabScreen()
                } else {
                    LaunchScreen()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                configManager.loadData()
                            }
                        }
                }
            }
            .environmentObject(configManager)
            .environmentObject(vm)
        }
    }
}
