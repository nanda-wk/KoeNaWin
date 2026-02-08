//
//  KoeNaWinApp.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import SwiftUI

@main
struct KoeNaWinApp: App {
    @StateObject private var koeNaWinStore = KoeNaWinStore()
    @StateObject private var preferences = UserPreferences()
    @StateObject private var userProgressService = UserProgressService()

    var body: some Scene {
        WindowGroup {
            Group {
                if koeNaWinStore.isLoading {
                    LaunchScreen()
                } else {
                    TabScreen()
                }
            }
            .environmentObject(koeNaWinStore)
            .environmentObject(preferences)
            .environmentObject(userProgressService)
            .onAppear {
                koeNaWinStore.loadData()
            }
        }
    }
}
