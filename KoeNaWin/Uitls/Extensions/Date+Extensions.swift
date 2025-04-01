//
//  Date+Extensions.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-31.
//

import Foundation

enum DateFormat: String {
    case yyyy_MMM_d = "yyyy MMMM d"
}

extension Date {
    func toStringWith(format: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "my_MM")
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }

    static func from(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "my_MM")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: string)
    }
}
