//
//  OptionsView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 19.11.22.
//

import SwiftUI

struct OptionsView: View {
    
    @FetchRequest(
        sortDescriptors: [],
        animation: .default) var notifications: FetchedResults<Notis>
    @StateObject private var pushService = PushNotificationService()
    
    @State private var storyNotifications: Bool?
    var body: some View {
        
        ForEach(notifications) { el in
            List {
                Section(header: Text("Präferenzen")) {
                    Toggle("Benachrichtigungen erhalten", isOn: Binding<Bool>(
                        get: { el.story },
                        set: {
                            el.story = $0
                            if el.story {
                                pushService.requestNotificationPermissions()
                            }
                            else if !el.story {
                                pushService.unsubscribeToNotifications()
                            }
                        }))
                }
            }
            .onAppear {
                UNUserNotificationCenter.current()
                    .getNotificationSettings(completionHandler: { settings in
                        switch settings.authorizationStatus {
                        case .authorized, .provisional, .ephemeral:
                            print("authorized")
                        case .denied:
                            print("denied")
                        case .notDetermined:
                            print("not determined, ask user for permission now")
                        @unknown default:
                            print("What tha heck")
                        }
                    })
            }
        }
        
        //        .onChange(of: notifications, perform: {
        //            if notifications {
        //                pushService.requestNotificationPermissions()
        //            }
        //
        //            if !notifications {
        //                pushService.unsubscribeToNotifications()
        //            }
        //        })
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView()
    }
}
