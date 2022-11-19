//
//  Server.swift
//  RegioQuest
//
//  Created by Orhan Salman on 18.11.22.
//
/*
import Foundation
import SwiftUI

class Server {
    private let coreDataStack = CoreDataStack.shared
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \User)])
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)],
        animation: .default)
    
    private var user: FetchedResults<User>
    private var job: FetchedResults<Job>
    private var quest: FetchedResults<Quest>
    private var skill: FetchedResults<Skill>
    private var gameEngine: FetchedResults<GameEngine>
    
    
    
    let fetchRequest: NSFetchRequest<User>
    fetchRequest = User.fetchRequest()

    fetchRequest.predicate = NSPredicate(
        format: "name LIKE %@", "Robert"
    )

    // Get a reference to a NSManagedObjectContext
    let context = coreDataStack.context

    // Perform the fetch request to get the objects
    // matching the predicate
    let objects = try context.fetch(fetchRequest)
    
    
}
// Load all necessary data from server to Device

// Store them on the device

// If any changes are made on the data, upload it to the server

// Every 1/2 Hour ask server for update

// Background process: download / upload data


*/
