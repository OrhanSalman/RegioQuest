//
//  JobView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 10.12.22.
//

import SwiftUI
import MapKit

struct JobView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var locationManager: LocationManager
    
    // Init is required!
    var jobRequest: FetchRequest<Job>
    init(jobRequest: FetchRequest<Job>) {
        self.jobRequest = jobRequest
    }
    
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(jobRequest.wrappedValue, id: \.self) { data in
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
                            Text(data.name ?? "Kein Name")
                            Spacer()
                            VStack {
                                if let location = locationManager.location {
                                    
                                    let questLocation: CLLocation = CLLocation(latitude: 50.99092883399603, longitude: 7.954069521589132)
                                    
                                    let userLocFromCLL2d: CLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                                    
                                    let distance = questLocation.distance(from: userLocFromCLL2d) / 1000
                                    Text(" \(String(format:"%.02f", distance)) km")
                                        .font(.subheadline.weight(.light))
                                }
                            }
                        }
                        VStack(alignment: .leading, spacing: 20) {
                            Divider()
                            Text(data.descripti ?? "Keine Beschreibung")
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
                        .allowsHitTesting(false)
                        .frame(width: UIScreen.main.bounds.width, height: 250)
                        .clipped()
                        Divider()
                        Spacer()
                    }
                }
                .onDisappear {
                    if !data.hasUserSeen {
                        data.hasUserSeen = true
                        try? self.managedObjectContext.save()
                    }
                }
            }
            
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
