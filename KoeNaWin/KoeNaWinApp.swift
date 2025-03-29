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

    var body: some Scene {
        WindowGroup {
            Group {
                if configManager.hasLoaded {
                    TabScreen()
                } else {
                    LaunchScreen()
                        .onAppear {
                            configManager.loadData()
                        }
                }
            }
            .environmentObject(configManager)
        }
    }
}
