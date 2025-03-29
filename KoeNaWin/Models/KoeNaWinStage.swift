//
//  KoeNaWinStage.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import Foundation

typealias KoeNaWinStages = [KoeNaWinStage]

struct KoeNaWinStage: Decodable, Identifiable {
    var id = UUID()
    let stage: Int
    let benefits: String
    let prayers: [Prayer]

    enum CodingKeys: CodingKey {
        case id
        case stage
        case benefits
        case prayers
    }

    init(stage: Int, benefits: String, prayers: [Prayer]) {
        self.stage = stage
        self.benefits = benefits
        self.prayers = prayers
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        stage = try container.decode(Int.self, forKey: .stage)
        benefits = try container.decode(String.self, forKey: .benefits)
        prayers = try container.decode([Prayer].self, forKey: .prayers)
    }
}

extension KoeNaWinStage {
    static var preview: KoeNaWinStage {
        KoeNaWinStage(stage: 1, benefits: "ငွေကြေးအပေးအယူကိစ္စ၊ ခရီးနဲ့ပတ်သက်တဲ့ကိစ္စ၊ ပညာရေးနဲ့ပတ်သက်တဲ့ကိစ္စ၊ မိမိ၏အသိဉာဏ်များပွင့်လင်းခြင်း၊ ဆုံးဖြတ်ချက်ခိုင်မာသွားခြင်းများ မုချကြုံရမည်။", prayers: Prayer.previews)
    }
}
