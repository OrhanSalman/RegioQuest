//
//  HomeView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 10.11.22.
//

import SwiftUI
import MapKit


/*
 struct Nutzer: Identifiable, Hashable {
 var id = UUID()
 var name: String
 }
 */
struct HomeView: View {
    @EnvironmentObject var locationManager: LocationManager
    
    @State private var showFilterScreen = false
    @State private var showFiltered = false
    
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)],
    animation: .default) var user: FetchedResults<User>
    
    var body: some View {
        NavigationView {
            
            VStack {
                ForEach(user) { data in
                    Text(data.name ?? "Leer")
                }
            }
            List {
                Text("Empfohlene Jobs für dich")
                Text("Neueste Storys")
                Text("Siegerehrung, Lisa hat einen Ausbildunsplatz erquizt, Glückwunsch!")
                Text("Letzte Quests")
                Text("Score")
            }
            
            .navigationTitle("Regionale Quest")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showFilterScreen.toggle()
                } label: {
                    Label("Filter", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showFilterScreen) {
            FilterView()
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
//            .environmentObject(ModelData())
            .environmentObject(LocationManager())
    }
}
