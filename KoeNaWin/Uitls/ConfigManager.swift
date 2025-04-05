//
//  ConfigManager.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import Foundation
import SwiftUI

var koeNaWinStages = KoeNaWinStages()

@MainActor
final class ConfigManager: ObservableObject {
    @AppStorage("isEnableHaptic") var isEnableHaptic: Bool = true
    @AppStorage("appTheme") var appTheme: AppTheme = .system
    @Published private(set) var hasLoaded = false

    func loadData() {
        koeNaWinStages = Bundle.main.decode(KoeNaWinStages.self, from: "KoeNaWin.json")
        UserDefaults.standard.register(defaults: ["isEnableHaptic": true])
        hasLoaded = true
    }
}

let buddhaAttributes: [String: String] = [
    "အရဟံ": "ကိလေသာကင်းစင်၍ အမြတ်ဆုံး ပုဂ္ဂိုလ်ဖြစ်ခြင်း၊ လူနတ်ဗြဟ္မာတို့၏ ပူဇော်အထူးကို ခံယူထိုက်တော်မူထိုက်သော မြတ်စွာဘုရား။",
    "သမ္မာသမ္ဗုဒ္ဓေါ": "တရားအလုံးစုံကို သဗ္ဗညုတဉာဏ်ဖြင့် အလိုလိုသိခြင်း၊ ဉာဏ်ပညာအကြီးဆုံးပုဂ္ဂိုလ်ဖြစ်တော်မူသော မြတ်စွာဘုရား။",
    "ဝိဇ္ဇာစရဏသမ္ပန္နော": "ဝိဇ္ဇာဉာဏ် ၃ ပါး၊ ဝိဇ္ဇာဉာဏ် ၈ ပါး၊ စရဏ အကျင့် ၁၅ ပါးတို့နှင့် ပြည့်စုံတော်မူခြင်း၊ အကြီးဆုံး ဝိဇ္ဇာနှင့် အကောင်းဆုံး အကျင့်ရှိသူဖြစ်တော်မူသော မြတ်စွာဘုရား။",
    "သုဂတော": "အကျိုးရှိသော ဟုတ်မှန်သောစကားကိုသာ ကောင်းစွာဆိုတတ်သောမြတ်စွာဘုရား။",
    "လောကဝိဒူ": "လောက ၃ ပါးကို အကြွင်းမဲ့ သိတော်မူ မြတ်စွာဘုရား။",
    "အနုတ္တရောပုရိသဓမ္မသာရထိ": "အတုမရှိ မြတ်တော်မူသည်ဖြစ်၍ မယဉ်ကျေးသောသူတို့ကို ယဉ်ကျေးအောင် ဆုံးမတော်မူတတ်သော မြတ်စွာဘုရား။",
    "သတ္ထာဒေဝမနုဿာနံ": "လူ၊ နတ်၊ ဗြဟ္မာ သတ္တဝါအားလုံးတို့၏ ဆရာတစ်ဆူဖြစ်တော်မူသော မြတ်စွာဘုရား။",
    "ဗုဒ္ဓေါ": "သစ္စာလေးပါးကို ကိုယ်ပိုင်ဉာဏ်ဖြင့် သိတော်မူပြီး တစ်ပါးသူတို့အားလည်း ဟောကြားညွှန်ပြနိုင်သောမြတ်စွာဘုရား။",
    "ဘဂဝါ": "ဘုန်းတော် ၆ ပါးနှင့် ပြည့်စုံတော်မူခြင်း၊ ဘုန်းတန်ခိုးအကြီးဆုံးပုဂ္ဂိုလ်ဖြစ်သော မြတ်စွာဘုရား။",
]
