//
//  ContentView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 09.11.22.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("isFirst") var isFirst: Bool = false
    var body: some View {
        VStack {
            
            if isFirst {
                Text("Welcome")
            } else {
                Button("log in") {
                    print("Logged in")
                }
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
