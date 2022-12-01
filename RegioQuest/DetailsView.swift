//
//  DetailsView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 16.11.22.
//

import SwiftUI
import CloudKit
import CoreData

struct DetailsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)],
        animation: .default) var user: FetchedResults<User>
    
    var body: some View {
        
        VStack {
            if(user.isEmpty) {
                Text("IsEmpty!!!")
            }
            else {
                ForEach(user) { data in
                    VStack {
                        Text(data.id?.uuidString ?? "Null")
                        Text(data.name ?? "Null")
                        Text(data.region ?? "Null")
                    }
                }
            }
        }
        .onAppear {
            Task {
                await processFetchUser()
            }
        }
    }
    
    
    private func myUserFunc() async -> FetchedResults<User> {
        viewContext.performAndWait {
            @FetchRequest(
                sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)],
                animation: .default) var user: FetchedResults<User>
        }
        return user
    }
    
    
    func processFetchUser() async {
        Task { @MainActor in
            await myUserFunc()
//            await fetchUser(viewContext: viewContext)
        }
    }
    func fetchUser(viewContext: NSManagedObjectContext) async -> [User] {

        let request: NSFetchRequest<User> = User.fetchRequest()
        let sectionSortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        request.sortDescriptors = sortDescriptors
        
        guard let result = try? viewContext.fetch(request) else {
            return []
        }
        return result
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView()
    }
}

