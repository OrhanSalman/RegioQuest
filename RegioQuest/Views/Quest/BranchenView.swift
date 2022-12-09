//
//  BranchenView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 13.11.22.
//

import SwiftUI

struct Jobs: Hashable, Identifiable {
    
    
    
    let id = UUID()
    let name: String
    let icon: String
    let fav: Bool = false
    
    static let header1 = Jobs(name: "Favoriten", icon: "star")
    static let header2 = Jobs(name: "Kürzlich hinzugefügt", icon: "timer")
    
}

struct BranchenView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Job.name, ascending: true)],
        animation: .default) var jobs: FetchedResults<Job>
    
    
    let items: [Jobs] = [.header1, .header2]
    @State private var lastSeen: Color = .green
    @State private var arr: [String] = []
    var body: some View {
        
        // For tests
        /*
         if (jobs.isEmpty) {
         let createJob: Bool = createDefaultJobs()
         }
         */
        
        List {
            DisclosureGroup("\(Image(systemName: "star")) Favoriten", content: {
                ForEach(jobs) { job in
                    if job.isFavorite {
                        HStack {
                            Text(job.name ?? "No Name found")
                            Spacer()
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                    }
                }
            })
            DisclosureGroup("\(Image(systemName: "timer")) Kürzlich hinzugefügt", content: {
                ForEach(jobs) { job in
                    if !job.hasUserSeen  {
                        HStack {
                            Text(job.name ?? "No Name found")
                        }
                        .onTapGesture {
                            job.hasUserSeen = true
                        }
                    }
                }
            })
            DisclosureGroup("\(Image(systemName: "rectangle.roundedtop")) Alle", content: {
                ForEach(jobs) { job in
                    HStack {
                        Text(job.name ?? "No Name found")
                        if job.isFavorite {
                            Spacer()
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                    }
                    .onTapGesture {
                        job.hasUserSeen = true
                    }
                }
            })
            DisclosureGroup("\(Image(systemName: "rectangle.roundedtop")) Branchen", content: {
                
                let uniqueStrings = removeDuplicates(array: arr.sorted())
                
                ForEach(uniqueStrings, id: \.self) { branche in
                    DisclosureGroup("\(Image(systemName: "rectangle.roundedtop")) \(branche)", content: {
                        var filtered = jobs.filter { ($0.branche?.contains(branche))! }
                        ForEach(filtered) { job in
                            HStack {
                                Text(job.name ?? "Keine")
                            }
                        }

                    })
                }
                
                
            })
            .task {
                await arrAppend()
            }
            
            
            /*
             DisclosureGroup("\(Image(systemName: "timer")) Kürzlich hinzufgefügt", content: {
             ForEach(jobss) { job in
             Text(job.name ?? "No Name found")
             }
             })
             */
        }
    }
    
    func arrAppend() async {
        for branchen in jobs {
            arr.append(String(branchen.branche ?? ""))
        }
        print("MeinArray: \(arr.sorted())")
    }
    
    func removeDuplicates(array: [String]) -> [String] {
        //Create an empty Set to track unique items
        var set = Set<String>()
        let result = array.filter {
            guard !set.contains($0) else {
                //If the set already contains this object, return false
                //so we skip it
                return false
            }
            //Add this item to the set since it will now be in the array
            set.insert($0)
            //Return true so that filtered array will contain this item.
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


/*
 private func adder() -> FetchedResults<Job> {
 
 
 @FetchRequest(
 sortDescriptors: [NSSortDescriptor(keyPath: \Job.name, ascending: true)],
 animation: .default) var jobs: FetchedResults<Job>
 
 var array = jobs
 
 return array
 }
 */



struct BranchenView_Previews: PreviewProvider {
    static var previews: some View {
        BranchenView()
    }
}
