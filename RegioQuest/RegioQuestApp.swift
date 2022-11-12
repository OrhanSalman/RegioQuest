//
//  RegioQuestApp.swift
//  RegioQuest
//
//  Created by Orhan Salman on 10.11.22.
//

import SwiftUI

@main
struct RegioQuestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
