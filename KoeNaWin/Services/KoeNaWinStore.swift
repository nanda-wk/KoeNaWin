//
//  KoeNaWinStore.swift
//  KoeNaWin
//
//  Created by Antigravity on 2026-02-08.
//

import Combine
import Foundation

@MainActor
final class KoeNaWinStore: ObservableObject {
    static let shared = KoeNaWinStore()
    @Published private(set) var stages: [KoeNaWinStage] = []
    @Published private(set) var isLoading = false

    private init() {
        loadData()
    }

    func loadData() {
        isLoading = true
        defer { isLoading = false }
        stages = Bundle.main.decode(KoeNaWinStages.self, from: "KoeNaWin.json")
    }
}
