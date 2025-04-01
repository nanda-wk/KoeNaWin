//
//  NoticeCard.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-30.
//

import SwiftUI

struct NoticeCard: View {
    @EnvironmentObject private var vm: HomeViewModel

    var icon: String = "progress.indicator"
    var title: String = ""
    var message: String = ""
    var button: String = ""

    init(status: ProgressStatus) {
        switch status {
        case let .active(_, _, _, todayCompleted):
            if todayCompleted {
                icon = "checkmark.circle.fill"
                title = "ဒီနေ့အတွက်အဓိဌာန် ပြီးဆုံးပါပြီ"
                message = "ဒီနေ့အတွက်အဓိဌာန်ကို အောင်မြင်စွာ ပြီးဆုံးခဲ့ပါပြီ"
                button = ""
            }
        case let .missedDay(failureDate):
            icon = "exclamationmark.triangle.fill"
            title = "သင်သည် အဓိဌာန်ကို \(failureDate.toStringWith(format: .yyyy_MMMM_d)) ရက်နေ့တွင် ပျက်ကွက်ခဲ့သည်"
            message = "အဓိဌာန်ကို ပြန်လည်စတင်ရန် အောက်ပါခလုတ်ကို နှိပ်ပါ"
            button = "ပြန်လည်စတင်ရန်"
        case .completed:
            icon = "checkmark.circle.fill"
            title = "အဓိဌာန် ပြီးဆုံးပါပြီ"
            message = "သင်သည် ကိုးနဝင်း အဓိဌာန်ကို အောင်မြင်စွာ ပြီးဆုံးခဲ့ပါပြီ"
            button = "ပြန်လည်စတင်ရန်"
        case .notStarted:
            icon = "play.circle.fill"
            title = "အဓိဌာန် မစတင်ရသေးပါ"
            message = "အဓိဌာန်ကို စတင်ရန် အောက်ပါခလုတ်ကို နှိပ်ပါ"
            button = "စတင်ရန်"
        case let .notMonday(nextMonday):
            icon = "exclamationmark.triangle.fill"
            title = "တနင်္လာနေ့ မဟုတ်သေးပါ"
            message = "အဓိဌာန်ကို တနင်္လာနေ့ မှသာ စတင်နိုင်ပါသည်။ လာမည့် \(nextMonday.toStringWith(format: .yyyy_MMMM_d)) (တနင်္လာနေ့)  တွင်စတင်နိုင်ပါသည်။"
            button = "စတင်ရန်"
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundStyle(.accent)

            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()

            if case .notMonday = vm.status {
            } else if !vm.todayCompleted {
                Button {
                    vm.startNewProgress()
                } label: {
                    Text(button)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.accent)
                        )
                }
                .padding(.horizontal)
            }
        }
        .padding()
    }
}

#Preview {
    NoticeCard(status: .notStarted)
        .previewEnvironment()
}
