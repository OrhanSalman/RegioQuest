/// Copyright (c) 2022 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.l
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

/// Added local store for development purposes
///

import CoreData
import CloudKit
import SwiftUI

/*
    Explanation's:
    https://developer.apple.com/documentation/coredata/mirroring_a_core_data_store_with_cloudkit/syncing_a_core_data_store_with_cloudkit
    https://developer.apple.com/documentation/coredata/mirroring_a_core_data_store_with_cloudkit/setting_up_core_data_with_cloudkit
 */

final class CoreDataStack: ObservableObject {
    static let shared = CoreDataStack()
    
    var ckContainer: CKContainer {
        let storeDescription = persistentContainer.persistentStoreDescriptions.first

        guard let identifier = storeDescription?.cloudKitContainerOptions?.containerIdentifier else {
            fatalError("Unable to get container identifier")
        }
        return CKContainer(identifier: identifier)
    }
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: Containers on the Cloud
    var privatePersistentStore: NSPersistentStore {
        guard let privateStore = _privatePersistentStore else {
            fatalError("Private store is not set")
        }
        return privateStore
    }
    var publicPersistentStore: NSPersistentStore {
        guard let publicStore = _publicPersistentStore else {
            fatalError("Public store is not set")
        }
        return publicStore
    }
    var sharedPersistentStore: NSPersistentStore {
        guard let sharedStore = _sharedPersistentStore else {
            fatalError("Shared store is not set")
        }
        return sharedStore
    }
    
    
    // CloudKit section
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "RegioQuest")
        
        // MARK: Load Container configurations (we have two, Default (for Cloud) and Local
        guard let storeDescription = container.persistentStoreDescriptions.first else {
             fatalError("Unable to get persistentStoreDescription")
         }
        storeDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        storeDescription.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
//        storeDescription.cloudKitContainerOptions?.databaseScope = .public
        
        // MARK: Setting the Containers
        let privateStoreURL = storeDescription.url?.deletingLastPathComponent()
        storeDescription.url = privateStoreURL?.appendingPathComponent("private.sqlite")
        
        let publicStoreURL = storeDescription.url?.deletingLastPathComponent()
        storeDescription.url = publicStoreURL?.appendingPathComponent("public.sqlite")
        
        let sharedStoreURL = privateStoreURL?.appendingPathComponent("shared.sqlite")
        guard let sharedStoreDescription = storeDescription.copy() as? NSPersistentStoreDescription else {
            fatalError("Copying the private store description returned an unexpected value.")
        }
        sharedStoreDescription.url = sharedStoreURL
        
        guard let containerIdentifier = storeDescription.cloudKitContainerOptions?.containerIdentifier else {
            fatalError("Unable to get containerIdentifier")
        }
        let sharedStoreOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: containerIdentifier)
        sharedStoreOptions.databaseScope = .shared
        sharedStoreDescription.cloudKitContainerOptions = sharedStoreOptions
        container.persistentStoreDescriptions.append(sharedStoreDescription)
        
        container.loadPersistentStores { loadedStoreDescription, error in
            if let error = error as NSError? {
                fatalError("Failed to load persistent stores: \(error)")
            } else if let cloudKitContainerOptions = loadedStoreDescription.cloudKitContainerOptions {
                guard let loadedStoreDescritionURL = loadedStoreDescription.url else {
                    return
                }
                
                if cloudKitContainerOptions.databaseScope == .private {
                    let privateStore = container.persistentStoreCoordinator.persistentStore(for: loadedStoreDescritionURL)
                    self._privatePersistentStore = privateStore
                } else if cloudKitContainerOptions.databaseScope == .shared {
                    let sharedStore = container.persistentStoreCoordinator.persistentStore(for: loadedStoreDescritionURL)
                    self._sharedPersistentStore = sharedStore
                } else if cloudKitContainerOptions.databaseScope == .public {
                    let publicStore = container.persistentStoreCoordinator.persistentStore(for: loadedStoreDescritionURL)
                    self._publicPersistentStore = publicStore
                }
            }
        }
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
//        try? context.setQueryGenerationFrom(.current)
        
        do {
            try container.viewContext.setQueryGenerationFrom(.current)
        } catch {
            fatalError("Failed to pin viewContext to the current generation: \(error)")
        }
        // Additionally added
        do {
             try container.initializeCloudKitSchema()
          } catch {
            print("ERROR \(error)")
         }
        
        return container
    }()
    
    
    // self, initialize
    private var _privatePersistentStore: NSPersistentStore?
    private var _sharedPersistentStore: NSPersistentStore?
    private var _publicPersistentStore: NSPersistentStore?
    private init() {}
}

// MARK: Save or delete from Core Data
extension CoreDataStack {
    
    static func fetchUsers(viewContext: NSManagedObjectContext) -> [User] {
        
        let request: NSFetchRequest<User> = User.fetchRequest()
        let sectionSortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        request.sortDescriptors = sortDescriptors
        
        guard let result = try? viewContext.fetch(request) else {
            return []
        }
        return result
    }
    
    static func fetchQueryUserById(viewContext: NSManagedObjectContext, id: UUID, predicate: NSPredicate? = nil) -> [User] {
        let request: NSFetchRequest<User> = User.fetchRequest()
        
        let projectpredicate = NSPredicate(format: "id == %@", id.uuidString)
        
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [projectpredicate, addtionalPredicate])
        } else {
            request.predicate = projectpredicate
        }
        
        guard let result = try? viewContext.fetch(request) else {
            return []
        }
        return result
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("ViewContext save error: \(error)")
            }
        }
    }

    func delete(_ user: User) {
        context.perform {
            self.context.delete(user)
            self.save()
        }
    }
}



/*
// ToDo: Later
// MARK: Share a record from Core Data
extension CoreDataStack {
    func isShared(object: NSManagedObject) -> Bool {
        isShared(objectID: object.objectID)
    }
    
    func canEdit(object: NSManagedObject) -> Bool {
        return persistentContainer.canUpdateRecord(forManagedObjectWith: object.objectID)
    }
    
    func canDelete(object: NSManagedObject) -> Bool {
        return persistentContainer.canDeleteRecord(forManagedObjectWith: object.objectID)
    }
    
    func isOwner(object: NSManagedObject) -> Bool {
        guard isShared(object: object) else { return false }
        guard let share = try? persistentContainer.fetchShares(matching: [object.objectID])[object.objectID] else {
            print("Get ckshare error")
            return false
        }
        if let currentUser = share.currentUserParticipant, currentUser == share.owner {
            return true
        }
        return false
    }
    
    func getShare(_ story: Story) -> CKShare? {
        guard isShared(object: story) else { return nil }
        guard let shareDictionary = try? persistentContainer.fetchShares(matching: [story.objectID]),
              let share = shareDictionary[story.objectID] else {
            print("Unable to get CKShare")
            return nil
        }
        share[CKShare.SystemFieldKey.title] = story.title
        return share
    }
    
    private func isShared(objectID: NSManagedObjectID) -> Bool {
        var isShared = false
        if let persistentStore = objectID.persistentStore {
            if persistentStore == sharedPersistentStore {
                isShared = true
            } else {
                let container = persistentContainer
                do {
                    let shares = try container.fetchShares(matching: [objectID])
                    if shares.first != nil {
                        isShared = true
                    }
                } catch {
                    print("Failed to fetch share for \(objectID): \(error)")
                }
            }
        }
        return isShared
    }
}
*/
