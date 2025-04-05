//
//  AppTheme.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-04-05.
//

import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    var id: String {
        rawValue
    }

    case light = "Light"
    case dark = "Dark"
    case system = "System"

    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            .light
        case .dark:
            .dark
        case .system:
            nil
        }
    }
}
