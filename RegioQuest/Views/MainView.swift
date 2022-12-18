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
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)],
    animation: .default) var user: FetchedResults<User>
    
    @State var homeBadgeCount = 0
    @State var branchenBadgeCount = 0
    @State var profileBadgeCount = 0
    @State var scoreBadgeCount = 0
    
    var body: some View {
        
        TabView() {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
//                .preferredColorScheme(.dark)
                .environmentObject(locationManager)
                .environmentObject(ViewRouter())
                .badge(homeBadgeCount)
                .onSubmit {
                    self.homeBadgeCount = 0
                }
            BranchenView()
                .tabItem {
                    Label("Berufe", systemImage: "map.circle.fill")
                }
                .environmentObject(locationManager)
                .badge(branchenBadgeCount)
                .onSubmit {
                    self.branchenBadgeCount = 0
                }
            SwiftUIView()
                .tabItem {
                    Label("Score", systemImage: "bell.fill")
                }
                .badge(scoreBadgeCount)
                .onSubmit {
                    self.scoreBadgeCount = 0
                }
//                .environment(\.managedObjectContext, coreDataStack.context)
//                .environmentObject(inMemoryDataStorage)
            CustomTabView()
                .tabItem {
                    Label("Profil", systemImage: "person.crop.circle.fill")
                }
                .badge(profileBadgeCount)
                .onSubmit {
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(ViewRouter())
    }
}
