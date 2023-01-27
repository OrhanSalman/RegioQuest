//
//  NotificationHandler.swift
//  RegioQuest
//
//  Created by Orhan Salman on 23.01.23.
//


/*
import Foundation
import UserNotifications
import UIKit

class NotificationHandler: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let message = response.notification.request.content.body {
            // Handle the notification here
            /*
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationViewController = storyboard.instantiateViewController(withIdentifier: "DestinationViewController") as! DestinationViewController
            let navigationController = UIApplication.shared.windows.first?.rootViewController as! UINavigationController
            navigationController.pushViewController(destinationViewController, animated: true)
            */
        }
        completionHandler()
    }
}


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    let notificationHandler = NotificationHandler()
    // ...
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        UNUserNotificationCenter.current().delegate = notificationHandler
        // ...
    }
}
*/
