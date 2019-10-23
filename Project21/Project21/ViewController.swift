//
//  ViewController.swift
//  Project21
//
//  Created by Maris Lagzdins on 23/10/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import UserNotifications
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }

    @objc
    func registerLocal() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Yay!")
            } else {
                print("D'oh!")
            }
        }
    }

    @objc
    func scheduleLocal() {
        scheduleLocalNotification(after: 5)
    }

    func scheduleLocalNotification(after time: TimeInterval) {
        registerCategories()

        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default

//        var dateComponents = DateComponents()
//        dateComponents.hour = 10
//        dateComponents.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }

    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let remind = UNNotificationAction(identifier: "remind", title: "Remind me later")
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, remind], intentIdentifiers: [], options:  [.customDismissAction])

        center.setNotificationCategories([category])
    }
}

extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        let identifier = response.notification.request.identifier

        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")

            var message: String? = nil

            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                print("Default identifier")
                message = "Received default action identifier"
            case UNNotificationDismissActionIdentifier:
                // Triggered only if Notification Category has provided option `.customDismissAction`
                print("Default dismiss identifier")
                scheduleLocalNotification(after: 0.1)
            case "show":
                print("Show more information...")
                message = "Received show action identifier"
            case "remind":
                print("Remind me later...")
                scheduleLocal()
            default:
                print("Unknown identifier received - \(response.actionIdentifier)")
                message = "Unknown identifier received - \(response.actionIdentifier)"
            }

            if message != nil {
                let ac = UIAlertController(title: "Notification (\(identifier)) received", message: message, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel))

                present(ac, animated: true)
            }
        }

        completionHandler()
    }
}
