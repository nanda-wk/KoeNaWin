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
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            Group {
                if configManager.hasLoaded {
                    TabScreen()
                } else {
                    LaunchScreen()
                }
            }
            .environmentObject(configManager)
            .environmentObject(vm)
            .preferredColorScheme(configManager.appTheme.colorScheme)
        }
        .onChange(of: scenePhase) { phase in
            if case .active = phase {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("Permission approved!")
                    } else if let error {
                        print(error.localizedDescription)
                    }
                }
                configManager.loadData()
                vm.checkProgress()
                vm.checkNotificationValidity()
            }
        }
    }
}
