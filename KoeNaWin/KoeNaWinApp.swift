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

    var body: some Scene {
        WindowGroup {
            TabScreen()
                .environmentObject(koeNaWinStore)
                .onAppear {
                    koeNaWinStore.loadData()
                }
        }
    }
}
