//
//  RegioQuestApp.swift
//  RegioQuest
//
//  Created by Orhan Salman on 10.11.22.
//

import SwiftUI
import CloudKit

class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (authorized, error) in
            if error != nil {
                print(error?.localizedDescription)
            }
            
            if authorized {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

// MARK: Push notifications
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Notification tapped!")
        
        completionHandler()
    }
}

@main
struct RegioQuestApp: App {
    
    let cloudPersistanceController = CoreDataStack.shared.context
    
    @StateObject private var pushService = PushNotificationService()
    
    @AppStorage("userOnboarded") var userOnboarded: Bool = false
    @State private var load: Bool = false
    @State private var onboard: Bool = true
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            if load {
                ProgressView(label: {
                    Text("Laden...")
                        .font(.headline)
                })
                .onAppear {
                    userOnboarded = true
                }
            }
            
            if userOnboarded {
                MainView()
                    .environment(\.managedObjectContext, cloudPersistanceController)
                    .onAppear {
                        pushService.requestNotificationPermissions()
                        load = false
                    }
            }
            else if onboard && !userOnboarded {
                VStack {
                    HStack {
                        Text("Regionale Karriere App")
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.vertical, 76)
                    .padding(.horizontal, 24)
                    .foregroundColor(.white)
                    Spacer()
                    VStack(alignment: .leading, spacing: 11) {
                        Text("Universitätsstadt Siegen")
                            .font(.system(size: 22, weight: .medium, design: .default))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .clipped()
                        Text("Lerne deine Stadt und ihre vielfältigen Angebote an Karrieremöglichkeiten besser kennen")
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(.white)
                        
                        ZStack(alignment: .topLeading) {
                            withAnimation {
                                Button(action: {
                                    onboard = false
                                    load = true
                                    
//                                    userOnboarded = true

                                }){
                                    Text("Loslegen")
                                        .font(.system(.body, design: .serif))
                                        .padding(.vertical, 12)
                                        .padding(.horizontal, 15)
                                        .background(.green)
                                        .foregroundColor(.black)
                                        .mask { RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        }
                                        .padding(.top, 8)
                                        .shadow(color: .white.opacity(1.0), radius: 20, x: 0, y: 5)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    Spacer()
                        .frame(height: 70)
                        .clipped()
                }
                .background {
                    Image("siegenufer")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
