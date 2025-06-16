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
    var title: LocalizedStringKey = ""
    var message: LocalizedStringKey = ""
    var button: LocalizedStringKey = ""

    init(status: ProgressStatus) {
        switch status {
        case let .active(_, _, _, todayCompleted):
            if todayCompleted {
                icon = "checkmark.circle.fill"
                title = "noticeCard-title"
                message = "noticeCard-active-message"
                button = ""
            }
        case let .missedDay(failureDate):
            icon = "exclamationmark.triangle.fill"
            title = "noticeCard-missedDay-title-\(failureDate.toStringWith(format: .yyyy_MMMM_d))"
            message = "noticeCard-missedDay-message"
            button = "noticeCard-missedDay-button"
        case .completed:
            icon = "checkmark.circle.fill"
            title = "noticeCard-title"
            message = "noticeCard-completed-message"
            button = "noticeCard-completed-button"
        case .notStarted:
            icon = "play.circle.fill"
            title = "noticeCard-notStarted-title"
            message = "noticeCard-notStarted-message"
            button = "noticeCard-button"
        case let .notMonday(nextMonday):
            icon = "exclamationmark.triangle.fill"
            title = "noticeCard-notMonday-title"
            message = "noticeCard-notMonday-message-\(nextMonday.toStringWith(format: .yyyy_MMMM_d))"
            button = "noticeCard-button"
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
