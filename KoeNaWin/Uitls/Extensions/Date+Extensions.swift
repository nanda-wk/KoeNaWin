//
//  Date+Extensions.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-31.
//

import Foundation

enum DateFormat: String {
    case yyyy_MMMM_d = "yyyy MMMM d"
    case hMMa = "h:mm a"
}

extension Date {
    func toStringWith(format: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }

    static func from(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: string)
    }

    func startOfDay(using calendar: Calendar = .current) -> Date {
        calendar.startOfDay(for: self)
    }
}
