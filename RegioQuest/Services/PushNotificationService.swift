//
//  PushNotificationService.swift
//  RegioQuest
//
//  Created by Orhan Salman on 28.12.22.
//

import UserNotifications
import CloudKit
import UIKit

final class PushNotificationService: ObservableObject {
    
    func requestNotificationPermissions() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge, .provisional]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print(error)
            } else if success {
                print("Notification permissions Success")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
            else {
                print("Notification permissions Failure")
            }
        }
    }
    
    func subscribeToNotifications(body: String) {
        /*
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized) ||
                  ((settings.authorizationStatus) == .provisional) else { return }

            if settings.alertSetting == .enabled {
                //Schedule an alert-only notification
            } else {
                //Schedule a notification with a badge and sound
            }

        }
        */
        let predicate = NSPredicate(value: true)
//        let subscriptions = CKQuerySubscription(recordType: "Story", predicate: predicate, subscriptionID: "story_added_to_database", options: .firesOnRecordCreation)
        let subscriptions = CKQuerySubscription(recordType: "Story", predicate: predicate, options: .firesOnRecordCreation)
        
        let notification = CKSubscription.NotificationInfo()
        
        notification.title = "Neue Story"
        notification.alertBody = body
        notification.soundName = "default"
        
        /*
        // Wenn die Record-Types für "Notifications" gesetzt sind (google mal, sind title, content und noch eins)
         // Damit kann man händisch in der Cloud benachrichtigungen eingeben
        notification.titleLocalizationKey = "%1$@"
        notification.titleLocalizationArgs = ["title"]

        notification.alertLocalizationKey = "%1$@"
        notification.alertLocalizationArgs = ["content"]
         */
        notification.shouldBadge = true
        subscriptions.notificationInfo = notification
        
        CKContainer.default().publicCloudDatabase.save(subscriptions, completionHandler: { subscription, error in
            if error == nil {
                // Subscription saved successfully
                print("Subscribed!")
            } else {
                // Error occurred
                print("Failed to subscribe", error?.localizedDescription)
            }
        })
        
        /*
        CKContainer.default().publicCloudDatabase.save(subscriptions) { returnedSubscription, returnedError in
            if let error = returnedError {
                print(error)
            } else {
                print("Successfully subscribed to Notifications")
            }
        }
         */
    }
    
    func unsubscribeToNotifications() {
        
        
        CKContainer.default().publicCloudDatabase.fetchAllSubscriptions(completionHandler: { subscriptions, error in
                  if error != nil {
                    // failed to fetch all subscriptions, handle error here
                    // end the function early
                    print("failed to fetch all subscriptions: ", error?.localizedDescription)
                    return
                  }

                  if let subscriptions = subscriptions {
                    for subscription in subscriptions {
                      CKContainer.default().publicCloudDatabase.delete(withSubscriptionID: subscription.subscriptionID, completionHandler: { string, error in
                        if(error != nil){
                            // deletion of subscription failed, handle error here
                            print("Deletion of subscription failed: ", error?.localizedDescription)
                        }
                        print("Canceled")
                      })
                    }
                  }

                })
            }
        
        /*
        CKContainer.default().publicCloudDatabase.delete(withSubscriptionID: "story_added") { returnedID, returnedError in
            if let error = returnedID {
                print(error)
            } else {
                print("Successfully unsubscribed")
            }
        }
    }
    */
}
