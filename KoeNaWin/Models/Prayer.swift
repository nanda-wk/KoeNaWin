//
//  Prayer.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import Foundation

struct Prayer: Decodable, Equatable, Identifiable {
    var id = UUID()
    let day: Day
    let mantra: String
    let rounds: Int
    let isVegetarian: Bool

    enum CodingKeys: CodingKey {
        case id
        case day
        case mantra
        case rounds
        case isVegetarian
    }

    init(day: Day, mantra: String, rounds: Int, isVegetarian: Bool) {
        self.day = day
        self.mantra = mantra
        self.rounds = rounds
        self.isVegetarian = isVegetarian
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        day = try container.decode(Day.self, forKey: .day)
        mantra = try container.decode(String.self, forKey: .mantra)
        rounds = try container.decode(Int.self, forKey: .rounds)
        isVegetarian = try container.decode(Bool.self, forKey: .isVegetarian)
    }
}

extension Prayer {
    static var previews: [Prayer] {
        [
            .init(day: .monday, mantra: "သမ္မာသမ္ဗုဒ္ဓေါ", rounds: 2, isVegetarian: false),
            .init(day: .tuesday, mantra: "ဘဂဝါ", rounds: 9, isVegetarian: false),
            .init(day: .wednesday, mantra: "သုဂတော", rounds: 9, isVegetarian: false),
            .init(day: .thursday, mantra: "သတ္ထာဒေဝမနုဿာနံ", rounds: 7, isVegetarian: false),
            .init(day: .friday, mantra: "လောကဝိဒူ", rounds: 5, isVegetarian: true),
            .init(day: .saturday, mantra: "ဝိဇ္ဇာစရဏသမ္ပန္နော", rounds: 3, isVegetarian: false),
            .init(day: .sunday, mantra: "အနုတ္တရောပုရိသဓမ္မသာရထိ", rounds: 6, isVegetarian: false),
            .init(day: .monday, mantra: "အရဟံ", rounds: 1, isVegetarian: false),
            .init(day: .tuesday, mantra: "ဗုဒ္ဓေါ", rounds: 8, isVegetarian: false),
        ]
    }
}
