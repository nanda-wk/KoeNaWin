//
//  View+Extensions.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import SwiftUI

extension View {
    func previewEnvironment() -> some View {
        koeNaWinStages = Bundle.main.decode(KoeNaWinStages.self, from: "KoeNaWin.json")
        return environmentObject(ConfigManager())
    }
}
