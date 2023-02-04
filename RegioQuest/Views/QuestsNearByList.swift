//
//  QuestsNearByList.swift
//  RegioQuest
//
//  Created by Orhan Salman on 25.01.23.
//

import SwiftUI
import CoreLocation

struct QuestsNearByList: View {
    @State private var showAlert: Bool = false
    @State private var alertShown: Bool = false
    @State private var load: Bool = false
    @State private var calculateDistanceProgress: Bool = true
    @State private var gameView: Bool = false
    
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Quest.title, ascending: true)],
        animation: .default) var quests: FetchedResults<Quest>
    
    let backgroundLocationManager = BackgroundLocationManager()
    
    /*
     @State private var locNotAvView: Bool = false
     @State private var noQuestsNearByView: Bool = false
     @State private var loadQuests: Bool = true
     */
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Quests nahe deiner aktuellen Position")) {
                    ForEach(quests) { data in
                        if let location = locationManager.location {
                            
                            let questLocation: CLLocation = CLLocation(latitude: data.latitude, longitude: data.longitude)
                            
                            let userLocFromCLL2d: CLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                            
                            let distance = questLocation.distance(from: userLocFromCLL2d) / 1000
                            
                            if distance < 1 {
                                LabeledContent(content: {
                                    
                                }, label: {
                                    Button(action: {
                                        if !alertShown {
                                            showAlert = true
                                        }
                                    }, label: {
                                        HStack {
                                            Text(data.title ?? "Leer")
                                            Spacer()
                                            HStack(spacing: 0) {
                                                Image(systemName: "star.fill")
                                                Image(systemName: "star")
                                                Image(systemName: "star")
                                            }
                                            Spacer()
                                            Text("\(String(format:"%.02f", distance)) km")
                                            /*
                                             if load {
                                             Spacer()
                                             ProgressView()
                                             }
                                             */
                                        }
                                    })
                                })
                                .alert(isPresented: $showAlert) {
                                    Alert(
                                        title: Text("Quest starten?"),
                                        message: Text("Möchtest Du die Quest starten?"),
                                        primaryButton: .default(Text("Los")) {
                                            load = true
                                            showAlert = false
                                            alertShown = true
                                            gameView.toggle()
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                                .fullScreenCover(isPresented: $gameView, content: {
                                    QuestGameView(quest: data)
                                        .onDisappear {
                                            load = false
                                            alertShown = false
                                            gameView = false
                                        }
                                        .onAppear {
                                            print("TITLE: \(data.title)")
                                        }
                                        .ignoresSafeArea()
                                })
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            locationManager.requestLocation()
        }
    }
}

struct QuestsNearByList_Previews: PreviewProvider {
    static var previews: some View {
        QuestsNearByList()
    }
}
