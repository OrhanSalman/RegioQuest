//
//  BranchenView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 13.11.22.
//

import SwiftUI
import MapKit
import CloudKit

struct BranchenView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Quest.title, ascending: true)],
        animation: .default) var quests: FetchedResults<Quest>
    
    @StateObject private var vm = FetchQuestModel()
    
    @State private var lastSeen: Color = .green
    @State private var arr: [String] = []
    
    var body: some View {
        NavigationView {
            List {
                DisclosureGroup("\(Image(systemName: "star")) Favoriten", content: {
                    ForEach(quests, id: \.self) { job in
                        if job.isFavorite {
                            NavigationLink(destination: JobView(jobRequest: FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Quest.title, ascending: true)], predicate: NSPredicate(format: "id == %@", job.id! as CVarArg), animation: .default))) {
                                HStack {
                                    
                                }
                                .frame(maxWidth: .infinity)
                                .background {
                                    HStack {
                                        Text(job.title ?? "No Title found")
                                        Spacer()
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                    }
                                }
                            }
                        }
                    }
                })
                
                DisclosureGroup("\(Image(systemName: "waveform.path.ecg.rectangle")) Für dich empfohlen", content: {
                    Text("Not implemented yet")
                })
                
                DisclosureGroup("\(Image(systemName: "timer")) Kürzlich hinzugefügt", content: {
                    ForEach(quests) { job in
                        if !job.hasUserSeen  {
                            HStack {
                                NavigationLink(destination: JobView(jobRequest: FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Quest.title, ascending: true)], predicate: NSPredicate(format: "id == %@", job.id! as CVarArg), animation: .default))) {
                                    Text(job.title ?? "No Name found")
                                }
                            }
                        }
                    }
                })
                DisclosureGroup("\(Image(systemName: "square.stack.3d.up")) Branchen", content: {
                    
                    let uniqueStrings = removeDuplicates(array: arr.sorted())
                    
                    ForEach(uniqueStrings, id: \.self) { branche in
                        DisclosureGroup("\(Image(systemName: "rectangle.roundedtop")) \(branche)", content: {
                            var filtered = quests.filter { ($0.branche?.contains(branche))!
                            }
                            ForEach(filtered) { job in
                                NavigationLink(destination: JobView(jobRequest: FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Quest.title, ascending: true)], predicate: NSPredicate(format: "id == %@", job.id! as CVarArg), animation: .default))) {
                                    HStack {
                                        
                                    }
                                    .frame(maxWidth: .infinity)
                                    .background {
                                        HStack {
                                            Text(job.title ?? "Keine")
                                            Spacer()
                                            if job.isFavorite {
                                                Image(systemName: "star.fill")
                                                    .foregroundColor(.yellow)
                                            }
                                        }
                                    }
                                }
                            }
                        })
                    }
                })
                .task {
                    await arrAppend()
                }
                DisclosureGroup("\(Image(systemName: "rectangle.roundedtop")) Alle", content: {
                    ForEach(quests) { job in
                        NavigationLink(destination: JobView(jobRequest: FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Quest.title, ascending: true)], predicate: NSPredicate(format: "id == %@", job.id! as CVarArg), animation: .default))) {
                            HStack {
                                
                            }
                            .frame(maxWidth: .infinity)
                            .background {
                                HStack {
                                    Text(job.title ?? "No Name found")
                                    Spacer()
                                    if job.isFavorite {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                    }
                                }
                            }
                        }
                    }
                })
            }
            .navigationTitle(Text("Quests"))
        }
        .task {
            // Fetch Quests from CloudKit
            await vm.fetch()
            // Save to CoreData
            for quest in vm.allQuests {
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
        }
    }
    func arrAppend() async {
        arr.removeAll()
        for branchen in quests {
            arr.append(String(branchen.branche ?? ""))
        }
        print("ArrayOfBranches: \(arr.sorted())")
    }
    
    func removeDuplicates(array: [String]) -> [String] {
        var set = Set<String>()
        let result = array.filter {
            guard !set.contains($0) else {
                return false
            }
            set.insert($0)
            
            return true
        }
        return result
    }
}

/*
 private func createDefaultJobs() -> Bool {
 var status: Bool = false
 
 
 for i in (0...7) {
 let arr = ["Ducktales", "Bikini Bottom", "Springfield", "Gotham City", "Smaugs Einöde", "Hogwarts", "Narnia", ]
 
 let job = Job(context: managedObjectContext)
 
 let jobId = UUID()
 let name = arr[i]
 
 job.id = jobId
 job.name = name
 job.latitude = 50.9910469
 job.longitude = 7.9565371
 job.descripti = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."
 
 do {
 try managedObjectContext.save()
 status = true
 } catch {
 // Replace this implementation with code to handle the error appropriately.
 // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
 let nsError = error as NSError
 fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
 }
 
 }
 return status
 }
 */


struct BranchenView_Previews: PreviewProvider {
    static var previews: some View {
        BranchenView()
    }
}
