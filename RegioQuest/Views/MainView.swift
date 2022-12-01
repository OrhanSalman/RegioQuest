//
//  MainView.swift
//  RegioQuestApp
//
//  Created by Orhan Salman on 31.08.22.
//

import Foundation
import SwiftUI

struct MainView: View {
    
    
    @StateObject var locationManager = LocationManager()
    @ObservedObject var inMemoryDataStorage = InMemoryDataStorage()
    
    @State var homeBadgeCount = 0
    @State var branchenBadgeCount = 0
    @State var profileBadgeCount = 0
    @State var scoreBadgeCount = 0
    
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)],
    animation: .default) var userData: FetchedResults<User>

    
    var body: some View {

        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
//                .environment(\.managedObjectContext, coreDataStack.context)
                .environmentObject(locationManager)
                .environmentObject(inMemoryDataStorage)
                .badge(homeBadgeCount)
                .onTapGesture {
                    homeBadgeCount = 0
                }
            BranchenView()
                .tabItem {
                    Label("Berufe", systemImage: "map.circle.fill")
                }
//                .environment(\.managedObjectContext, coreDataStack.context)
                .environmentObject(locationManager)
                .environmentObject(inMemoryDataStorage)
                .badge(branchenBadgeCount)
                .onTapGesture {
                    branchenBadgeCount = 0
                }
            ScoreView()
                .tabItem {
                    Label("Score", systemImage: "bell.fill")
                }
                .badge(scoreBadgeCount)
                .onTapGesture {
                    scoreBadgeCount = 0
                }
//                .environment(\.managedObjectContext, coreDataStack.context)
                .environmentObject(inMemoryDataStorage)
            CustomTabView()
                .tabItem {
                    Label("Profil", systemImage: "person.crop.circle.fill")
                }
                .badge(profileBadgeCount)
                .onTapGesture {
                    profileBadgeCount = 0
                }
                .environmentObject(inMemoryDataStorage)
        }
        .onAppear {
            if(userData.isEmpty) {
                profileBadgeCount = 1
            }
        }
    }
}


