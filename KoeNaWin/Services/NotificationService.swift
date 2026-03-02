//
//  NotificationService.swift
//  KoeNaWin
//
//  Created by Nanda Win Kyu on 2026-02-08.
//

import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()

    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { _, error in
            if let error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Success")
            }
        }
    }

    func scheduleNotification(id: String, title: String, subtitle: String, date: Date, repeats: Bool) {
        requestAuthorization()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = subtitle
        content.sound = .default

        let calendar = Calendar.current
        var components: DateComponents = if repeats {
            calendar.dateComponents([.hour, .minute], from: date)
        } else {
            calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        }

        components.second = 0
        components.timeZone = TimeZone.current

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)

        let request = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    func cancelNotification(id: String = NotificationID.scheduleNotificationIdentifier) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
