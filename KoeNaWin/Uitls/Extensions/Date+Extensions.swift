//
//  Date+Extensions.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-31.
//

import Foundation
import SwiftUI

enum DateFormat: String {
    case yyyy_MMMM_d = "yyyy MMMM d"
    case hMMa = "h:mm a"
}

extension Date {
    func toStringWith(format: DateFormat) -> String {
        @AppStorage("appLanguage") var lang: AppLanguage = .myanmar
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: lang == .english ? "en_US_POSIX" : "my")
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }

    static func from(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: string)
    }

    func isMonday(using calendar: Calendar = .current) -> Bool {
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday == 2
    }

    func startOfDay(using calendar: Calendar = .current) -> Date {
        calendar.startOfDay(for: self)
    }

    static func today(using calendar: Calendar = .current) -> Date {
        calendar.startOfDay(for: .now)
    }
}
