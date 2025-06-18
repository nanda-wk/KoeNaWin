//
//  Day.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-04-02.
//

enum Day: String, Decodable, Equatable, Identifiable, Hashable {
    var id: String { rawValue }
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case sunday = "Sunday"

    var desc: String {
        switch self {
        case .monday:
            "တနင်္လာ"
        case .tuesday:
            "အင်္ဂါ"
        case .wednesday:
            "ဗုဒ္ဓဟူး"
        case .thursday:
            "ကြာသပတေး"
        case .friday:
            "သောကြာ"
        case .saturday:
            "စနေ"
        case .sunday:
            "တနင်္ဂနွေ"
        }
    }

    func localized(to language: AppLanguage) -> String {
        language == .english ? rawValue : desc
    }
}
