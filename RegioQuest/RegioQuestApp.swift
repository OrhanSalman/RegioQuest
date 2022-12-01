//
//  RegioQuestApp.swift
//  RegioQuest
//
//  Created by Orhan Salman on 10.11.22.
//

import SwiftUI

@main
struct RegioQuestApp: App {
//    let persistenceController = PersistenceController.shared
//    let persistanceController = PersistenceController.shared
    let cloudPersistanceController = CoreDataStack.shared
    
    var body: some Scene {
        WindowGroup {
            MainView()
//                .environment(\.managedObjectContext, persistanceController.container.viewContext)
//                .environment(\.managedObjectContext, cloudPersistanceController.context)
                .environment(\.managedObjectContext, cloudPersistanceController.context)

            // Implementieren: Hinweis darauf, dass es sich um einen Prototypen
            // zur Veranschaulichung handelt, und gewisse Teile der App nicht die Gegenwart repräsentieren können, insbesondere die Quests. Die Quests sind inszeniert, daher führt auch kein Abschluss einer zu einem wirklichen Ausbildungsplatz
        }
    }
    

}

/*
struct StoryboardViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(identifier: "Main")
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
*/
