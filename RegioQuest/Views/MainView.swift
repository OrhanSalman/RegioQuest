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
    /*
    @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Badges.id, ascending: true)],
    animation: .default) var badges: FetchedResults<Badges>
*/
    
    @State var homeBadgeCount = 0
    @State var branchenBadgeCount = 0
    @State var profileBadgeCount = 0
    @State var scoreBadgeCount = 0
    
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some View {
        
        TabView() {
            Group {
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
                    .edgesIgnoringSafeArea(.top)
                
                BranchenView()
                    .tabItem {
                        Label("Suche", systemImage: "location.magnifyingglass")
                    }
                    .environmentObject(locationManager)
                    .badge(branchenBadgeCount)
                    .onSubmit {
                        self.branchenBadgeCount = 0
                    }
//                QuestGameView()
                QuestsNearByList()
                    .tabItem {
                        Label("Quests", systemImage: "gamecontroller")
                    }
                    .environmentObject(locationManager)
                    .badge(scoreBadgeCount)
                    .onSubmit {
                        self.scoreBadgeCount = 0
                    }
                 /*
                SkillView()
                    .tabItem {
                        Label("Skills", systemImage: "brain.head.profile")
                    }
                    .badge(scoreBadgeCount)
                    .onSubmit {
                        self.scoreBadgeCount = 0
                    }
                  */
                CustomTabView()
                    .tabItem {
                        Label("Profil", systemImage: "person.crop.circle.fill")
                    }
                    .badge(profileBadgeCount)
                    .onSubmit {
                        self.profileBadgeCount = 0
                    }
            }
            .toolbar(.visible , for: .tabBar)
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
//            appearance.backgroundColor = UIColor(Color.primary.opacity(0.2))
            
            // Use this appearance when scrolling behind the TabView:
            UITabBar.appearance().standardAppearance = appearance
            // Use this appearance when scrolled all the way up:
            UITabBar.appearance().scrollEdgeAppearance = appearance
            
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
