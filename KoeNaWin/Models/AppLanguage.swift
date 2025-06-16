//
//  AppLanguage.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-06-16.
//

import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
    var id: String {
        rawValue
    }

    case english
    case myanmar

    var title: String {
        switch self {
        case .english:
            "English"
        case .myanmar:
            "Myanmar"
        }
    }

    var desc: String {
        switch self {
        case .english:
            "(အင်္ဂလိပ်)"
        case .myanmar:
            "(မြန်မာ)"
        }
    }

    var icon: ImageResource {
        switch self {
        case .english:
            .english
        case .myanmar:
            .myanmar
        }
    }

    var locale: Locale {
        switch self {
        case .english:
            .init(identifier: "en")
        case .myanmar:
            .init(identifier: "my")
        }
    }
}
