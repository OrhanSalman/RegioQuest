//
//  OptionsView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 19.11.22.
//

import SwiftUI
import UserNotifications

struct OptionsView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        sortDescriptors: [],
        animation: .default) var notifications: FetchedResults<Subscriptions>
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)],
        animation: .default) var user: FetchedResults<User>
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)],
        animation: .default) var quest: FetchedResults<Quest>
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)],
        animation: .default) var skill: FetchedResults<Skill>
    
    @StateObject private var pushService = PushNotificationService()
    
    @State private var storyNotifications: Bool?
    @State private var showingAlert: Bool = false
    
    private var timer: Timer?
    private let interval: TimeInterval = 1.0 // 1 second
    
    var body: some View {
        
        if notifications.isEmpty {
            VStack {
                
            }
            .onAppear {
                getNotificationPermission()
            }
        }
        else {
            List {
                ForEach(notifications) { el in
                    Section(header: Text("Push-Benachrichtigungen")) {
                        Toggle("Stories", isOn: Binding<Bool>(
                            get: { el.story },
                            set: {
                                el.story = $0
                                try? self.managedObjectContext.save()
                                if el.story {
                                    pushService.requestNotificationPermissions()
                                    pushService.subscribeToStories()
                                }
                                else if !el.story {
                                    pushService.unsubscribeFromStories()
                                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["story_subscription"])

                                }
                            }))
                        
                        Toggle("Quest", isOn: Binding<Bool>(
                            get: { el.quest },
                            set: {
                                el.quest = $0
                                try? self.managedObjectContext.save()
                                if el.quest {
                                    pushService.requestNotificationPermissions()
                                    pushService.subscribeToQuest()
                                }
                                else if !el.quest {
                                    // ToDo
                                    pushService.unsubscribeFromQuests()
                                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["distance_alert"])

                                }
                            }))
                    }
                }
                if !user.isEmpty {
                    Section(header: Text("Profil löschen")) {
                        HStack {
                            Button("Profildaten löschen", role: .destructive, action: {
                                showingAlert = true
                            })
                            Spacer()
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .alert(isPresented: $showingAlert) {
                                    Alert(
                                        title: Text("Profildaten löschen"),
                                        message: Text("Möchtest Du dein Profil und deine Fortschritte unwiderruflich löschen?"),
                                        primaryButton: .destructive(Text("Löschen")) {
                                            withAnimation {
                                                for data in user {
                                                    managedObjectContext.delete(data)
                                                }
                                                for data in quest {
                                                    managedObjectContext.delete(data)
                                                }
                                                for data in skill {
                                                    managedObjectContext.delete(data)
                                                }
                                                for data in notifications {
                                                    managedObjectContext.delete(data)
                                                }
                                                
                                                /*
                                                do {
                                                    try managedObjectContext.save()
                                                } catch {
                                                    print(error)
                                                }
                                                 */
                                            }
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                    }
                }
            }
            .task {
                getNotificationPermission()
            }
        }
    }
    
    func getNotificationPermission() {
        UNUserNotificationCenter.current()
            .getNotificationSettings(completionHandler: { settings in
                switch settings.authorizationStatus {
                case .authorized, .provisional, .ephemeral:
                    print("NOTIFICATIONS authorized")
                    notificationInCoreData(status: true)
                case .denied:
                    print("NOTIFICATIONS denied")
                    notificationInCoreData(status: false)
                case .notDetermined:
                    print("NOTIFICATIONS not determined, ask user for permission now")
                    pushService.requestNotificationPermissions()
                @unknown default:
                    print("What tha heck")
                }
            })
    }
    
    func notificationInCoreData(status: Bool) {
        if notifications.isEmpty {
            let subs = Subscriptions(context: managedObjectContext)
            // Setting temp default value
            subs.quest = false
            subs.story = false
            
            if status {
                subs.quest = true
                subs.story = true
            }
            if !status {
                subs.quest = false
                subs.story = false
            }
        }
        /*
        else {
            for i in notifications {
                if status {
                    i.quest = true
                    i.story = true
                }
                if !status {
                    i.quest = false
                    i.story = false
                }
            }
        }
        */
        do {
            try managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView()
    }
}
