//
//  BranchenView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 13.11.22.
//

import SwiftUI
import MapKit
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
        
        // For tests
        /*
         if (jobs.isEmpty) {
         let createJob: Bool = createDefaultJobs()
         }
         */
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
                DisclosureGroup("\(Image(systemName: "rectangle.roundedtop")) Branchen", content: {
                    
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
            }
        }
        .navigationBarTitle(Text("Branchen"))
    }
    
    func arrAppend() async {
        for branchen in jobs {
            arr.append(String(branchen.branche ?? ""))
        }
        print("MeinArray: \(arr.sorted())")
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
/*
struct JobView: View {
    
    @EnvironmentObject var locationManager: LocationManager

    var selectedJob: Job
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Text("Dinge die man markiert erscheinen in Quest Push Notification")
                VStack {
                    ScrollView(.horizontal, showsIndicators: true) {
                        Image("regio")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: UIScreen.main.bounds.width)
                    }
                    
                    VStack {
                        HStack {
                            Text("Kein Name")
                            Spacer()
                            Text("2.7 km")
                        }
                        VStack(alignment: .leading, spacing: 20) {
                            Divider()
                            Text("Keine Beschreibung")
                        }
                        .font(.system(.subheadline, design: .rounded).weight(.thin))
                        
                        
                        Divider()
                    }
                    .padding(30)
                    
                    VStack(spacing: 10) {
                        Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50.99092883399603, longitude: 7.954069521589132), latitudinalMeters: 6549.32, longitudinalMeters: 6566.81)),
                            annotationItems: [PlacePin(latitude: 50.9910469, longitude: 7.9565371)],
                            annotationContent: {
                            MapMarker(
                                coordinate: $0.location, tint: nil)
                            
                        })
                        .onTapGesture {
                            print("asdasd")
                        }
                        .allowsHitTesting(false)
                        .frame(width: UIScreen.main.bounds.width, height: 250)
                        .clipped()
                        Divider()
                        Spacer()
                    }
                }
            }
            
        

        .edgesIgnoringSafeArea(.top)
        
    }
    
    func stringSeperator(imagePaths: String) -> [String] {
        let seperatedImages = imagePaths.components(separatedBy: ";")
        return seperatedImages
    }
}

struct PlacePin: Identifiable {
    let id: String
    let location: CLLocationCoordinate2D
    
    init(id: String = UUID().uuidString, latitude: Double, longitude: Double) {
        self.id = id
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
*/

struct BranchenView_Previews: PreviewProvider {
    static var previews: some View {
        BranchenView()
    }
}
