//
//  QuestsNearByList.swift
//  RegioQuest
//
//  Created by Orhan Salman on 25.01.23.
//

import SwiftUI

struct QuestsNearByList: View {
    @State private var showAlert: Bool = false
    @State private var alertShown: Bool = false
    @State private var load: Bool = false
    var body: some View {
        
        NavigationView {
            Form {
                Section(header: Text("Quests nahe deiner aktuellen Position")) {
                    LabeledContent(content: {
                        
                    }, label: {
                        Button(action: {
                            if !alertShown {
                                showAlert = true
                            }
                        }, label: {
                            HStack {
                                Text("Mathe-Genie")
                                Spacer()
                                HStack(spacing: 0) {
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star")
                                    Image(systemName: "star")
                                }
                                Spacer()
                                Text("0.7 km")
                                
                                if load {
                                    Spacer()
                                    ProgressView()
                                }
                            }
                        })
                    })
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Quest starten?"),
                            message: Text("Möchtest Du die Quest starten?"),
                            primaryButton: .default(Text("Los")) {
                                load = true
                                showAlert = false
                                alertShown = true
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
        }
    }
}

struct QuestsNearByList_Previews: PreviewProvider {
    static var previews: some View {
        QuestsNearByList()
    }
}
