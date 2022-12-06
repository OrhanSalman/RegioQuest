//
//  ProfilView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 19.11.22.
//

import SwiftUI

struct ProfilView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)],
    animation: .default) var user: FetchedResults<User>
    
    
//    @EnvironmentObject var a: InMemoryDataStorage
    @State var badgeCount = 0
    
    var body: some View {
        if(user.isEmpty) {
            NoAccountView()
        }
        else {
            ForEach(user) { data in
                List {
                    VStack {
                        Section() {
                            VStack {
                                PhotoPicker()
                                Spacer(minLength: 10)
                                Text(data.name ?? "Kein Name" )
                                Divider()
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listStyle(GroupedListStyle())
                    
                    Section(header: Text("Profil")) {
                        HStack {
                            Text("Abschluss")
                            Spacer()
                            Text(data.education ?? "Keine Education")
                                .foregroundColor(.teal)
                        }
                        HStack {
                            Text("Job")
                            Spacer()
                            Text(data.job ?? "Kein Job")
                                .foregroundColor(.teal)
                        }
                        HStack {
                            Text("Region")
                            Spacer()
                            Text(data.region ?? "Keine Region")
                                .foregroundColor(.teal)
                        }
                    }
                    
                    Section(header: Text("Fortschritt")) {
                        NavigationLink(destination: SkillView()) {
                            Text("Einladungen")
                        }
                        NavigationLink(destination: SkillView()) {
                            Text("Quests")
                        }
                        NavigationLink(destination: SkillView()) {
                            Text("Skills")
                        }
                        NavigationLink(destination: SkillView()) {
                            Text("Quote")
                        }
                    }
                    
                    Section(header: Text("Präferenzen")) {
                        Toggle("Profil mit Freunden teilen", isOn: Binding<Bool>(
                            get: { data.shareWithFriends },
                            set: {
                                data.shareWithFriends = $0
                                try? self.managedObjectContext.save()
                            }))
                    }
                }
            }
        }
    }
}

struct ProfilView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilView()
    }
}
