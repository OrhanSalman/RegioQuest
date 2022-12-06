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
//    @StateObject var inMemoryDataStorage = InMemoryDataStorage()
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)],
    animation: .default) var user: FetchedResults<User>

    @State var homeBadgeCount = 0
    @State var branchenBadgeCount = 0
    @State var profileBadgeCount = 0
    @State var scoreBadgeCount = 0
    
    var body: some View {

        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
//                .environment(\.managedObjectContext, coreDataStack.context)
                .environmentObject(locationManager)
//                .environmentObject(inMemoryDataStorage)
                .badge(homeBadgeCount)
                .onTapGesture {
                    self.homeBadgeCount = 0
                }
            BranchenView()
                .tabItem {
                    Label("Berufe", systemImage: "map.circle.fill")
                }
//                .environment(\.managedObjectContext, coreDataStack.context)
                .environmentObject(locationManager)
//                .environmentObject(inMemoryDataStorage)
                .badge(branchenBadgeCount)
                .onTapGesture {
                    self.branchenBadgeCount = 0
                }
            ScoreView()
                .tabItem {
                    Label("Score", systemImage: "bell.fill")
                }
                .badge(scoreBadgeCount)
                .onTapGesture {
                    self.scoreBadgeCount = 0
                }
//                .environment(\.managedObjectContext, coreDataStack.context)
//                .environmentObject(inMemoryDataStorage)
            CustomTabView()
                .tabItem {
                    Label("Profil", systemImage: "person.crop.circle.fill")
                }
                .badge(profileBadgeCount)
                .onTapGesture {
                    self.profileBadgeCount = 0
                }
//                .environmentObject(inMemoryDataStorage)
        }
        .onAppear {
            if(user.isEmpty) {
                self.profileBadgeCount = 1
            }
        }
    }
}


