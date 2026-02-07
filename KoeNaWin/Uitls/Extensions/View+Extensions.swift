//
//  View+Extensions.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-03-29.
//

import SwiftUI

/// Preview states for SwiftUI Previews
enum PreviewState {
    /// Active practice at a specific stage and day (both 1-9)
    case active(stage: Int16, day: Int16)
    /// Practice completed (all 81 days done)
    case completed
    /// Practice not started yet
    case notStarted
    /// Missed a day (will show failure card)
    case missedDay
    /// Scheduled to start on next Monday
    case willStart
    /// Today completed (shows the checkmark state)
    case todayCompleted(stage: Int16, day: Int16)
}

extension View {
    func previewEnvironment(state: PreviewState = .active(stage: 1, day: 4)) -> some View {
        koeNaWinStages = Bundle.main.decode(KoeNaWinStages.self, from: "KoeNaWin.json")
        
        switch state {
        case let .active(stage, day):
            UserProgress.makePreview(stage: stage, day: day, todayCompleted: false)
        case .completed:
            UserProgress.makePreview(stage: 9, day: 9, todayCompleted: true, markAsCompleted: true)
        case .notStarted:
            break
        case .missedDay:
            UserProgress.makePreviewWithMissedDay()
        case .willStart:
            UserProgress.makePreviewWillStart()
        case let .todayCompleted(stage, day):
            UserProgress.makePreview(stage: stage, day: day, todayCompleted: true)
        }
        
        let vm = HomeViewModel()
        vm.checkProgress()
        return environmentObject(ConfigManager())
            .environmentObject(vm)
    }
    
    func previewEnvironment(
        initProgess: Bool = true,
        stage: Int16 = 1,
        day: Int16 = 4
    ) -> some View {
        if initProgess {
            return previewEnvironment(state: .active(stage: stage, day: day))
        } else {
            return previewEnvironment(state: .notStarted)
        }
    }
}

extension View {
    var listSectionBackground: some View {
        background(
            Group {
                if #available(iOS 25, *) {
                    RoundedRectangle(cornerRadius: 26)
                        .fill(Color(UIColor.tertiarySystemBackground))
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(UIColor.tertiarySystemBackground))
                }
            }
        )
    }
}
