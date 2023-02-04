//
//  RegioQuestApp.swift
//  RegioQuest
//
//  Created by Orhan Salman on 10.11.22.
//

import SwiftUI
import CloudKit

@main
struct RegioQuestApp: App {
    let cloudPersistanceController = CoreDataStack.shared.context
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        sortDescriptors: [],
        animation: .default) var notifications: FetchedResults<Subscriptions>
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Quest.title, ascending: true)],
        animation: .default) var quests: FetchedResults<Quest>
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Quest.title, ascending: true)],
        animation: .default) var user: FetchedResults<User>
    
    @StateObject private var pushService = PushNotificationService()
    
    @AppStorage("userOnboarded") var userOnboarded: Bool = false
    @State private var load: Bool = false
    @State private var onboard: Bool = true
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject private var vm_q = FetchQuestModel()
    @StateObject private var vm_s = FetchStoryModel()
    @StateObject private var vm_sk = FetchSkillModel()
    
    @State private var progressText: String = ""
    @State private var fetch: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if load {
                ProgressView(label: {
                    Text("Laden...")
                        .font(.headline)
                })
                .onAppear {
                    userOnboarded = true
                    fetch = true
                }
            }
            
            if userOnboarded {
                if fetch {
                    ProgressView(label: {
                        Text(progressText)
                            .font(.headline)
                    })
                    .task {
                        load = false
                        progressText = "Lade Datensätze aus der Cloud"
                        
                        // Quests
                        await vm_q.fetch()
                        
                        // ToDo ERROR: Geht nur wenn Profil vorhanden ist!
                        if user.isEmpty {
                            fetch.toggle()
                            return
                        }
                        else {
                            // Save Quest to CoreData
                            for quest in vm_q.allQuests {
                                
                                // Check if questID already exists, if yes, skip to next CKRecord
                                if quests.contains(where:  {
                                    $0.title == quest.title
                                }) {
                                    print("Quest exists")
                                }
                                else {
                                    let quests = Quest(context: managedObjectContext)
                                    quests.title = quest.title
                                    quests.latitude = quest.latitude
                                    quests.longitude = quest.longitude
                                    quests.branche = quest.branche
                                    //                        quests.id = String("\(quest.record.recordID)")
                                    quests.id = UUID()
                                    quests.descripti = quest.description
                                    quests.hasUserFinished = false
                                    quests.hasUserSeen = false
                                    quests.isFavorite = false
                                    quests.score = 0.0
                                    
                                    do {
                                        try managedObjectContext.save()
                                    } catch {
                                        let nsError = error as NSError
                                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                    }
                                }
                            }
                            // Stories
                            await vm_s.fetch()
                            // Skills
                            await vm_sk.fetch()
                            
                            fetch.toggle()
                        }
                    }
                }
                else {
                    MainView()
                        .environment(\.managedObjectContext, cloudPersistanceController)
                        .onAppear {
                            
                            UIApplication.shared.applicationIconBadgeNumber = 0
                            pushService.requestNotificationPermissions()
                            load = false
                        }
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
                                    /*
                                    let options = Notis(context: viewContext)
                                    options.story = false
                                    options.temp = "temp"
                                    
                                    do {
                                        try viewContext.save()
                                    } catch {
                                        let nsError = error as NSError
                                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                    }
                                     */
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
/*
class AppDelegate: UIResponder, UIApplicationDelegate {

    @StateObject private var pushService = PushNotificationService()
    @FetchRequest(
        sortDescriptors: [],
        animation: .default) var notifications: FetchedResults<Notis>
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UNUserNotificationCenter.current().delegate = self
        
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print(error)
                for el in self.notifications {
                    el.story = false
                    print("BENACHRICHTIGUNG: \(el.story)")
                }
            } else if success {
                print("Notification permissions Success")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                for el in self.notifications {
                    el.story = true
                    print("BENACHRICHTIGUNG: \(el.story)")
                }
            }
            else {
                print("Notification permissions Failure")
            }
        }
        
        
        /*
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (authorized, error) in
            if error != nil {
                print(error?.localizedDescription)
                for el in self.notifications {
                    el.story = false
                }
            }
            
            if authorized {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
                for el in self.notifications {
                    el.story = true
                }
            }
        }
        */
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

*/
