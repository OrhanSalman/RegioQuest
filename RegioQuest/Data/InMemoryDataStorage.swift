//
//  InMemoryDataStorage.swift
//  RegioQuest
//
//  Created by Orhan Salman on 01.12.22.
//

import CoreData
import CloudKit
import SwiftUI

class InMemoryDataStorage: ObservableObject {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)],
    animation: .default) var userData: FetchedResults<User>
    
    /*
    @FetchRequest var userData: FetchedResults<User>
    var user: User
    
    init(user: User) {
        self.user = user
        self._userData = FetchRequest(
            entity: User.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)],
            animation: .default)
    }
    */
    /*
    class FetchedUser: ObservableObject {
        @FetchRequest var userData: FetchedResults<User>
        @Published var user: User
        
        init(user: User) {
            self.user = user
            self._userData = FetchRequest(
                entity: User.entity(),
                sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)],
                animation: .default)
        }
    }
    */
}
