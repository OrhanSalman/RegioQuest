//
//  Background.swift
//  RegioQuest
//
//  Created by Orhan Salman on 01.02.23.
//

import CoreLocation
import CoreData
import UserNotifications
import UIKit
import SwiftUI

class BackgroundLocationManager: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    @Environment(\.managedObjectContext) private var viewContext
    let context = CoreDataStack.shared.context
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!
    }
    
    func handleBackgroundTask(taskID: UIBackgroundTaskIdentifier) {
        
        let fetchRequest: NSFetchRequest<Quest> = Quest.fetchRequest()
        do {
            let result = try context.fetch(fetchRequest)
            for i in result {
                let latitude = i.latitude
                let longitude = i.longitude
            /*
            for data in result as [NSManagedObject] {
                let latitude = data.value(forKey: "latitude") as! Double
                let longitude = data.value(forKey: "longitude") as! Double
                */
                let targetLocation = CLLocation(latitude: latitude, longitude: longitude)
                let distance = currentLocation.distance(from: targetLocation)
                
                if distance < 1000 {
                    // send local push notification
                    let content = UNMutableNotificationContent()
                    content.title = "Distance Alert"
                    content.body = "You are now less than 1 km from your target location."
                    content.sound = .default
                    
                    let request = UNNotificationRequest(identifier: "distance_alert", content: content, trigger: nil)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                }
            }
        } catch {
            print("Failed")
        }
        
        UIApplication.shared.endBackgroundTask(taskID)
    }
}

