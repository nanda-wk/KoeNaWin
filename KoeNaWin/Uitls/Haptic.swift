//
//  Haptic.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-04-05.
//

import Foundation
import UIKit

enum Haptic {
    case impact(UIImpactFeedbackGenerator.FeedbackStyle)
    case selection
    case notification(UINotificationFeedbackGenerator.FeedbackType)

    func generate() {
        guard UserDefaults.standard.bool(forKey: "isEnableHaptic") else { return }

        switch self {
        case let .impact(feedbackStyle):
            let generator = UIImpactFeedbackGenerator(style: feedbackStyle)
            generator.prepare()
            generator.impactOccurred()
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        case let .notification(feedbackType):
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(feedbackType)
        }
    }
}
