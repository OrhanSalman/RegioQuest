//
//  BranchenView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 13.11.22.
//

import SwiftUI
import MapKit
import CloudKit

/*
 struct Jobs: Hashable, Identifiable {
 
 
 
 let id = UUID()
 let name: String
 let icon: String
 let fav: Bool = false
 
 static let header1 = Jobs(name: "Favoriten", icon: "star")
 static let header2 = Jobs(name: "Kürzlich hinzugefügt", icon: "timer")
 
 }
 */

struct BranchenView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Job.name, ascending: true)],
        animation: .default) var jobs: FetchedResults<Job>
    
    
    //    let items: [Jobs] = [.header1, .header2]
    @State private var lastSeen: Color = .green
    @State private var arr: [String] = []
    
    var body: some View {
        NavigationView {
            List {
                DisclosureGroup("\(Image(systemName: "star")) Favoriten", content: {
                    ForEach(jobs, id: \.self) { job in
                        if job.isFavorite {
                            NavigationLink(destination: JobView(jobRequest: FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Job.name, ascending: true)], predicate: NSPredicate(format: "id == %@", job.id! as CVarArg), animation: .default))) {
                                HStack {
                                    
                                }
                                .frame(maxWidth: .infinity)
                                .background {
                                    HStack {
                                        Text(job.name ?? "No Name found")
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
                    /*
                     ForEach(jobs, id: \.self) { job in
                     if job.isFavorite {
                     NavigationLink(destination: JobView(jobRequest: FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Job.name, ascending: true)], predicate: NSPredicate(format: "id == %@", job.id! as CVarArg), animation: .default))) {
                     HStack {
                     
                     }
                     .frame(maxWidth: .infinity)
                     .background {
                     HStack {
                     Text(job.name ?? "No Name found")
                     Spacer()
                     Image(systemName: "star.fill")
                     .foregroundColor(.yellow)
                     }
                     }
                     }
                     }
                     }
                     */
                })
                
                DisclosureGroup("\(Image(systemName: "timer")) Kürzlich hinzugefügt", content: {
                    ForEach(jobs) { job in
                        if !job.hasUserSeen  {
                            HStack {
                                NavigationLink(destination: JobView(jobRequest: FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Job.name, ascending: true)], predicate: NSPredicate(format: "id == %@", job.id! as CVarArg), animation: .default))) {
                                    Text(job.name ?? "No Name found")
                                }
                            }
                        }
                    }
                })
                DisclosureGroup("\(Image(systemName: "square.stack.3d.up")) Branchen", content: {
                    
                    let uniqueStrings = removeDuplicates(array: arr.sorted())
                    
                    ForEach(uniqueStrings, id: \.self) { branche in
                        DisclosureGroup("\(Image(systemName: "rectangle.roundedtop")) \(branche)", content: {
                            var filtered = jobs.filter { ($0.branche?.contains(branche))!
                            }
                            ForEach(filtered) { job in
                                NavigationLink(destination: JobView(jobRequest: FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Job.name, ascending: true)], predicate: NSPredicate(format: "id == %@", job.id! as CVarArg), animation: .default))) {
                                    HStack {
                                        
                                    }
                                    .frame(maxWidth: .infinity)
                                    .background {
                                        HStack {
                                            Text(job.name ?? "Keine")
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
                    ForEach(jobs) { job in
                        NavigationLink(destination: JobView(jobRequest: FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Job.name, ascending: true)], predicate: NSPredicate(format: "id == %@", job.id! as CVarArg), animation: .default))) {
                            HStack {
                                
                            }
                            .frame(maxWidth: .infinity)
                            .background {
                                HStack {
                                    Text(job.name ?? "No Name found")
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
            .navigationTitle(Text("Branchen"))
        }
        .onAppear {
            // For tests
            if (jobs.isEmpty) {
    //            let createJob: Bool = createDefaultJobs()
                
                for i in (0..<7) {
                    
                    /*
                    let storeDescription = persistentContainer.persistentStoreDescriptions(p)
                     */
                    let job = Job(context: managedObjectContext)
                    
                    let arr = ["Ducktales", "Bikini Bottom", "Springfield", "Gotham City", "Smaugs Einöde", "Hogwarts", "Narnia", ]
                    let arrBranchen = ["Industrie", "Verwaltung", "Einzelhandel"]
                    let arrCompany = ["Uni Siegen", "Muster GmbH", "Stadt Siegen"]
                    let jobId = UUID()
                    let name = arr[i]
                    
                    job.id = jobId
                    job.company = arrCompany.randomElement()
                    job.contact = "muster@mail.com"
                    job.name = name
                    job.url = URL(string: "https://www.uni-siegen.de/start/")
                    job.branche = arrBranchen.randomElement()
                    job.latitude = 50.9910469
                    job.longitude = 7.9565371
                    job.descripti = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."
                    
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
        }
    }
    
    /*
     Task
     {
        do {
              data = try await fetchUserRecord()
           }
           catch
           {
              print(error)
           }
      }
     */
    
    /*
    func fetchUserRecord() async throws -> [Double]
    {
        CKContainer.default().
        yourContainer.fetchUserRecordIDWithCompletionHandler { (userID, error) -> Void in
            if let userID = userID {
                // here's your userID (recordID) to play with
            }
        }
        
        var data: [Double] = [0, 1, 2]    // you don't really want the
        let aWeekAgo = Date().addingTimeInterval(-604800)

        let reference = CKReference(recordID: userID, action: .None)
        
       let publicDB = CKContainer.default().publicCloudDatabase
       let predicate = NSPredicate(format: "creatorUserRecordID == %@", reference)
       let query = CKQuery(recordType: "Jobs", predicate: predicate)
       let (values, cursor) = try await publicDB.records(matching: query, resultsLimit: 100)


        
       for r in values
       {
           if let rec = try? r.1.get()
           {
               data.append(rec["value"] as! Double)
           }
       }
       
       return data
           
     }
    */
    func arrAppend() async {
        arr.removeAll()
        for branchen in jobs {
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
