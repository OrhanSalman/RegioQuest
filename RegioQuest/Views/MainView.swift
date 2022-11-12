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
    @StateObject var modelData = ModelData()
    
    var body: some View {
        
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .environmentObject(modelData)
                .environmentObject(locationManager)
            ScoreView()
                .tabItem {
                    Label("Score", systemImage: "bell.fill")
                }
            QuestView()
                .tabItem {
                    Label("Map", systemImage: "map.circle.fill")
                }
                .environmentObject(modelData)
                .environmentObject(locationManager)
            ProfilView()
                .tabItem {
                    Label("Profil", systemImage: "person.crop.circle.fill")
                }
                .environmentObject(modelData)
        }
    }
}

struct SetBackground: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.mint.opacity(0.9), Color.blue.opacity(0.9)]), startPoint: .top, endPoint: .bottom)
            .colorMultiply(Color.mint)
            .clipped()
    }
}
