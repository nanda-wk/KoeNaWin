//
//  Constants.swift
//  KoeNaWin
//
//  Created by Nanda Win Kyu on 2026-02-08.
//

import Foundation

enum Constants {
    static let appVersion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1.0.0"
    static let email = "nandawinkyu.ix@gmail.com"
    static let appStoreLink = "https://apps.apple.com/us/app/koenawin-practice/id6747106061"
    static let privacyPolicy = "https://sites.google.com/view/koenawin/privacy"
}

enum NotificationID {
    static let scheduleNotificationIdentifier = "scheduleNotificationIdentifier"
    static let oneDayBeforeNotificationIdentifier = "oneDayBeforeNotificationIdentifier"
}

enum NotiMessage {
    static let scheduleNotificationTitle = "KoeNaWin"
    static let scheduleNotificationBody = "Let's practice today!"
    static let oneDayBeforeNotificationTitle = "KoeNaWin"
    static let oneDayBeforeNotificationBody = "One day until our practice day!"
}

enum PracticeState: Equatable {
    case started
    case notStarted
    case scheduled(startDate: Date)
    case missedDay(date: Date)
    case completedAll
}
