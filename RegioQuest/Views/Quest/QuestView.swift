//
//  QuestView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 10.11.22.
//

import SwiftUI
import MapKit


/*
 struct Nutzer: Identifiable, Hashable {
 var id = UUID()
 var name: String
 }
 */
struct QuestView: View {
    
    //    @EnvironmentObject var model: Job
    
    @EnvironmentObject var modelDataObject: ModelData
    @EnvironmentObject var locationManager: LocationManager
    @State private var showFilterScreen = false
    @State private var showFiltered = false
    
    
    
    var modelData: [Job] {
        modelDataObject.jobsDataStorage
    }
    /*
     var filter: [Job] {
     modelData.landmarks.filter { landmark in
     (!showFavoritesOnly || landmark.isFavorite)
     }
     }
     */
    
    
    var body: some View {
        Text("A")
        /*
        NavigationView {
            /*
            Toggle(isOn: $showFiltered) {
                Text("Favorites only")
            }
            */
            GeometryReader { gr in
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(alignment: .top, spacing: 6) {
                        ForEach(modelData, id: \.self) { data in
                            GeometryReader { geometry in
                                
                                
                                .clipped()
                                
                                .rotation3DEffect(
                                    Angle(
                                        degrees: Double((geometry.frame(in: .global).minX) / -10)
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
        */
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

struct QuestView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ModelData())
            .environmentObject(LocationManager())
    }
}
