//
//  String+Extensions.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-31.
//

import Foundation

extension String {
    func toMyanmarDigits() -> String {
        let myanmarDigits = ["၀", "၁", "၂", "၃", "၄", "၅", "၆", "၇", "၈", "၉"]
        var result = ""

        for char in self {
            if let digit = Int(String(char)) {
                result += myanmarDigits[digit]
            } else {
                result += String(char)
            }
        }

        return result
    }
}

extension Int {
    func toMyanmarDigits() -> String {
        String(self).toMyanmarDigits()
    }

    func toMyanmarDigitsWithFormat(_ format: String) -> String {
        String(format: format, self).toMyanmarDigits()
    }
}

extension Double {
    func toMyanmarDigits(specifier: String = "%.1f") -> String {
        String(format: specifier, self).toMyanmarDigits()
    }
}
