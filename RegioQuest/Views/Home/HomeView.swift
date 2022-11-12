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
    
    //    @EnvironmentObject var model: Job
    
    @EnvironmentObject var modelDataObject: ModelData
    @EnvironmentObject var locationManager: LocationManager
    @State private var showFilterScreen = false
    @State private var showFiltered = false
    
    var body: some View {
        NavigationView {
            
            List {
                Text("Ein Text")
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
            .environmentObject(ModelData())
            .environmentObject(LocationManager())
    }
}
