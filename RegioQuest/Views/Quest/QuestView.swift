//
//  QuestView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 10.11.22.
//

import SwiftUI
import MapKit


struct QuestView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Job.id, ascending: true)],
        animation: .default)
    private var jobs: FetchedResults<Job>
    private let stack = CoreDataStack.shared
    
    //    @EnvironmentObject var model: Job
    
//    @EnvironmentObject var modelDataObject: ModelData
    @EnvironmentObject var locationManager: LocationManager
    @State private var showFilterScreen = false
    @State private var showFiltered = false
    
/*
    var modelData: [Job] {
        modelDataObject.jobsDataStorage
    }
 */
    /*
     var filter: [Job] {
     modelData.landmarks.filter { landmark in
     (!showFavoritesOnly || landmark.isFavorite)
     }
     }
     */
    
    var body: some View {

        
        NavigationStack {
            /*
            Toggle(isOn: $showFiltered) {
                Text("Favorites only")
            }
            */
            GeometryReader { gr in
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(alignment: .top, spacing: 0) {
                        ForEach(jobs, id: \.self) { data in
                            GeometryReader { geometry in
                                LinearGradient(gradient: Gradient(colors: [Color(.sRGB, red: 30/255, green: 30/255, blue: 30/255), .white.opacity(0.5), .black]), startPoint: .top, endPoint: .bottom)
                                .clipped()
                                
                                .rotation3DEffect(
                                    Angle(
                                        degrees: Double((geometry.frame(in: .global).minX) / -20)
                                    ),
                                    axis: (x: 0, y: 1, z: 0),
                                    anchor: .center,
                                    anchorZ: 0.0,
                                    perspective: 1.0
                                )
                                .padding(1)
                                .overlay {
                                    Text(data.description)
                                }
                            }
                            .frame(width: gr.size.width, height: gr.size.height)
                        }
                    }
                    .onAppear {
                        UIScrollView.appearance().isPagingEnabled = true
                    }
                }
            }
            .navigationTitle("Regionale Quest")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showFilterScreen.toggle()
                } label: {
                    Label("Filter", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showFilterScreen) {
            FilterView()
        }
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

/*
struct ColorMode {
    @State private var sysColor = Color(UIColor.systemBackground)
    @State private var primary = Color(.black)
    @State private var secondary = Color(.white)
    
    init(sysColor: Color = Color(UIColor.systemBackground), black: Color = Color(.black), white: Color = Color(.white)) {
        self.sysColor = sysColor
        self.primary = primary
        self.secondary = secondary
        
        if(sysColor == primary) {
            return
        } else if(sysColor == secondary) {
            primary = Color(.white)
            secondary = Color(.black)
        }
    }
    
}
*/
struct QuestView_Previews: PreviewProvider {
    static var previews: some View {
        QuestView()
 //           .environmentObject(ModelData())
            .environmentObject(LocationManager())
    }
}
