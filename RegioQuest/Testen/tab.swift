//
//  tab.swift
//  RegioQuest
//
//  Created by Orhan Salman on 07.12.22.
//

import SwiftUI

struct tab: View {
    @StateObject var locationManager = LocationManager()

    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)],
    animation: .default) var user: FetchedResults<User>
    var body: some View {
        TabView() {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .environmentObject(locationManager)
                .environmentObject(ViewRouter())
            CustomTabView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .environmentObject(locationManager)
                .environmentObject(ViewRouter())
        }
    }
}

struct tab_Previews: PreviewProvider {
    static var previews: some View {
        tab()
    }
}
