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
//    @StateObject var modelData = ModelData()
    
    @State var badgeCount  = 5
    
    let coreDataStack = CoreDataStack.shared
    
    var body: some View {
        
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
    //                .environmentObject(modelData)
                    .environment(\.managedObjectContext, coreDataStack.context)
                    .environmentObject(locationManager)
                BranchenView()
                    .tabItem {
                        Label("Berufe", systemImage: "map.circle.fill")
                    }
    //                .environmentObject(modelData)
                    .environment(\.managedObjectContext, coreDataStack.context)
                    .environmentObject(locationManager)
                ScoreView()
                    .tabItem {
                        Label("Score", systemImage: "bell.fill")
                    }
                    .badge(badgeCount)
                    .onTapGesture {
                        badgeCount = 0
                    }
                    .environment(\.managedObjectContext, coreDataStack.context)
                ProfilView()
                    .tabItem {
                        Label("Profil", systemImage: "person.crop.circle.fill")
                    }
    //                .environmentObject(modelData)
            }
    }
}


