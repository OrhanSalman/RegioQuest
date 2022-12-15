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
    @State private var calculateDistanceProgress: Bool = true
    @State private var latitude: Double?
    @State private var longitude: Double?
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 600.0, longitudinalMeters: 600.0)
    
//    @StateObject private var vm: JobViewModel

    
    // Init is required for @FetchRequest!
    var jobRequest: FetchRequest<Job>
    init(jobRequest: FetchRequest<Job>) {
        self.jobRequest = jobRequest
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: jobRequest.wrappedValue.first?.latitude ?? 0, longitude: jobRequest.wrappedValue.first?.longitude ?? 0), latitudinalMeters: 600.0, longitudinalMeters: 600.0)
    }
    /*
    init(jobRequest: FetchRequest<Job>, vm: JobViewModel) {
        _vm = StateObject(wrappedValue: vm)
        self.jobRequest = jobRequest
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: jobRequest.wrappedValue.first?.latitude ?? 0, longitude: jobRequest.wrappedValue.first?.longitude ?? 0), latitudinalMeters: 600.0, longitudinalMeters: 600.0)
    }
    */
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
                                if calculateDistanceProgress {
                                    ProgressView()
                                        .padding()
                                }
                                if let location = locationManager.location {
                                    
                                    let questLocation: CLLocation = CLLocation(latitude: data.latitude, longitude: data.longitude)
                                    
                                    let userLocFromCLL2d: CLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                                    
                                    let distance = questLocation.distance(from: userLocFromCLL2d) / 1000
                                    Text("ca. \(String(format:"%.02f", distance)) km")
                                        .font(.subheadline.weight(.light))
                                        .onAppear {
                                            self.calculateDistanceProgress = false
                                        }
                                }
                            }
                        }
                        VStack(alignment: .leading, spacing: 20) {
                            Divider()
                            Text(data.descripti ?? "Keine Beschreibung")
                        }
                        .font(.system(.subheadline, design: .rounded).weight(.thin))
                        Divider()
                        /*
                        VStack(spacing: 10) {
                            Text("Unternehmen: \(data.name ?? "Keine Angaben")")
                            Text("Kontakt: \(data.contact ?? "Keine Angaben")")
                            Text("Anschrift: Keine Angaben")
                        }
                        .font(.system(.subheadline, design: .rounded).weight(.thin))
                        */
                    }
                    .padding(30)
                    VStack {
                        ZStack {
                            /*
                            Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50.9910469, longitude: 7.9565371), latitudinalMeters: 600.0, longitudinalMeters: 600.0)),
                                annotationItems: [PlacePin(latitude: 50.9910469, longitude: 7.9565371)],
                                annotationContent: {
                                MapMarker(coordinate: $0.location, tint: nil)
                            })
                            .frame(width: UIScreen.main.bounds.width, height: 250)
                            .clipped()
                            */
                            Map(coordinateRegion: $region,
                                annotationItems: [PlacePin(latitude: self.latitude ?? 0, longitude: self.longitude ?? 0)],
                                annotationContent: {
                                MapMarker(coordinate: $0.location, tint: nil)
                            })
                            .frame(width: UIScreen.main.bounds.width, height: 250)
                            .clipped()
                            Circle()
                                .fill(Color(.quaternaryLabel))
                                .frame(width: 30, height: 30)
                                .clipped()
                                .overlay {
                                    Image(systemName: "paperplane.fill")
                                        .imageScale(.small)
                                        .symbolRenderingMode(.monochrome)
                                        .foregroundColor(.white)
                                }
                                .offset(x: 160, y: -100)
                                .onTapGesture {
                                    let url = URL(string: "maps://?saddr=&daddr=\(50.9910469),\(7.9565371)")
                                    if UIApplication.shared.canOpenURL(url!) {
                                        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                    }
                                }
                            Circle()
                                .fill(Color(.quaternaryLabel))
                                .frame(width: 30, height: 30)
                                .clipped()
                                .overlay {
                                    Image(systemName: "arrow.turn.down.left")
                                        .imageScale(.small)
                                        .symbolRenderingMode(.monochrome)
                                        .foregroundColor(.white)
                                }
                                .offset(x: 160, y: 80)
                                .onTapGesture {
                                    self.latitude = data.latitude
                                    self.longitude = data.longitude
                                    self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude), latitudinalMeters: 600.0, longitudinalMeters: 600.0)
                                }
                        }
                        Spacer()
                        Divider()
                    }
                }
                .onAppear {
//                    vm.saveJob(name: "PUBLIC", title: "PUBLIC")
                    
                    locationManager.requestLocation()
                    self.latitude = data.latitude
                    self.longitude = data.longitude
                    self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude), latitudinalMeters: 600.0, longitudinalMeters: 600.0)
                    /*
                    self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: data.latitude ?? 0, longitude: data.longitude ?? 0), latitudinalMeters: 600.0, longitudinalMeters: 600.0)
                     */
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

    
    // If the cloud container contains an array of pic
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
