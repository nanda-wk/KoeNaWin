//
//  KoeNaWinApp.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import SwiftUI

@main
struct KoeNaWinApp: App {
    @Environment(\.scenePhase) private var scenePhase

    @StateObject private var koeNaWinStore = KoeNaWinStore.shared
    @StateObject private var preferences = UserPreferences()
    @StateObject private var journeyService = JourneyService()
    @StateObject private var router = Router()

    var body: some Scene {
        WindowGroup {
            Group {
                if koeNaWinStore.isLoading {
                    LaunchScreen()
                } else {
                    TabScreen()
                }
            }
            .id(preferences.appLanguage)
            .environmentObject(koeNaWinStore)
            .environmentObject(preferences)
            .environmentObject(journeyService)
            .environmentObject(router)
            .preferredColorScheme(preferences.appTheme.colorScheme)
            .environment(\.locale, preferences.appLanguage.locale)
            .onAppear {
                koeNaWinStore.loadData()
            }
            .onChange(of: scenePhase) { newValue in
                if newValue == .active {
                    journeyService.refreshState()
                }
            }
        }
    }
}
