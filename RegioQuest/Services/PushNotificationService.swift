//
//  PushNotificationService.swift
//  RegioQuest
//
//  Created by Orhan Salman on 28.12.22.
//

import UserNotifications
import CloudKit
import UIKit
import SwiftUI

class PushNotificationService: ObservableObject {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        sortDescriptors: [],
        animation: .default) var notifications: FetchedResults<Subscriptions>
    
    @State private var returnStatement = false
    
    func requestNotificationPermissions() -> Bool {
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print(error)
                //                self.notificationInCoreData(status: false)
                
                // returnStatement is false
            } else if success {
                print("Notification permissions Success")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                    //                    self.notificationInCoreData(status: true)
                }
                self.returnStatement.toggle() // true
            }
            else {
                print("Notification permissions Failure")
                // returnStatement is false
            }
        }
        return returnStatement
    }
    
    func subscribeToStories() {
        let center = UNUserNotificationCenter.current()
        
        let predicate = NSPredicate(value: true)
        let subscriptions = CKQuerySubscription(recordType: "Story", predicate: predicate, subscriptionID: "story_subscription", options: [.firesOnRecordCreation])
        
        let notification = CKSubscription.NotificationInfo()
        
        notification.title = "RegioQuest"
        notification.alertBody = "Neue Stories verfügbar"
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
                print("SUBSCRIPTIONID: \(subscription?.subscriptionID)")
            } else {
                // Error occurred
                print("Failed to subscribe", error?.localizedDescription)
            }
        })
    }
    
    func subscribeToQuest() {
        let center = UNUserNotificationCenter.current()
        
        let predicate = NSPredicate(value: true)
        let subscriptions = CKQuerySubscription(recordType: "Quest", predicate: predicate, subscriptionID: "quest_subscription", options: [.firesOnRecordCreation])
        
        let notification = CKSubscription.NotificationInfo()
        
        notification.title = "RegioQuest"
        notification.alertBody = "Quest in der Nähe!"
        notification.soundName = "default"
        
        notification.shouldBadge = true
        subscriptions.notificationInfo = notification
        
        CKContainer.default().publicCloudDatabase.save(subscriptions, completionHandler: { subscription, error in
            if error == nil {
                // Subscription saved successfully
                print("Subscribed to Quests!")
                subscription?.subscriptionID
            } else {
                // Error occurred
                print("Failed to subscribe Quests", error?.localizedDescription)
            }
        })
    }
    /*
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
     */
    func unsubscribeFromStories() {
        CKContainer.default().publicCloudDatabase.delete(withSubscriptionID: "story_subscription", completionHandler: { returnedID, returnedError in
            if let error = returnedError {
                print("Failed to unsubscribe Stories: \(error)")
            } else {
                print("Successfully unsubscribed Stores")
            }
        })
        
        /*
        let container = CKContainer.default()
        let database = container.publicCloudDatabase
        
        // Create the predicate for the query
        let predicate = NSPredicate(value: true)
        
        // Create the subscription
        let subscription = CKQuerySubscription(recordType: "Story", predicate: predicate, options: .firesOnRecordCreation)
        
        // Delete the subscription
        database.fetch(withSubscriptionID: subscription.subscriptionID) { (subscription, error) in
            if let error = error {
                print("Error fetching subscription: \(error.localizedDescription)")
            } else if let subscription = subscription {
                database.delete(withSubscriptionID: subscription.subscriptionID) { (subscriptionID, error) in
                    if let error = error {
                        print("Error unsubscribing from stories: \(error.localizedDescription)")
                    } else {
                        print("Successfully unsubscribed from stories")
                        print("SUBSCRIPTIONID: \(String(describing: subscriptionID))")
                    }
                }
            }
        }
        */
    }
    
    func unsubscribeFromQuests() {
        
        CKContainer.default().publicCloudDatabase.delete(withSubscriptionID: "quest_subscription", completionHandler: { returnedID, returnedError in
            if let error = returnedError {
                print("Failed to unsubscribe Quests: \(error)")
            } else {
                print("Successfully unsubscribed Stores")
            }
        })
        
        /*
        let container = CKContainer.default()
        let database = container.publicCloudDatabase
        
        // Create the predicate for the query
        let predicate = NSPredicate(value: true)
        
        // Create the subscription
        let subscription = CKQuerySubscription(recordType: "Quest", predicate: predicate, options: .firesOnRecordCreation)

        // Delete the subscription
        database.fetch(withSubscriptionID: subscription.subscriptionID) { (subscription, error) in
            if let error = error {
                print("Error fetching subscription: \(error.localizedDescription)")
            } else if let subscription = subscription {
                database.delete(withSubscriptionID: subscription.subscriptionID) { (subscriptionID, error) in
                    if let error = error {
                        print("Error unsubscribing from quests: \(error.localizedDescription)")
                    } else {
                        print("Successfully unsubscribed from quests")
                        print("SUBSCRIPTIONID: \(String(describing: subscriptionID))")
                    }
                }
            }
        }
        */
    }
}
