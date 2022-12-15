//
//  ProfilView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 19.11.22.
//

import SwiftUI
import CloudKit

struct ProfilView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)],
    animation: .default) var user: FetchedResults<User>
    @State var badgeCount = 0
    
    var body: some View {
        if(user.isEmpty) {
            NoAccountView()
        }
        else {
            ForEach(user) { data in         // Should not be for-each, only 1 user per device
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

struct NoAccountView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    // Account variables
    @StateObject private var viewModel = AccountServiceModel()
    @State private var accountStatusAlertShown = false
    @Environment(\.dismiss) var dismiss
    
    @State var text = "Profil anlegen"
    @State var count: Int = 0
    
    var body: some View {
        Text("Lege ein anonymisiertes Profil in deiner iCloud an, um deine Fortschritte speichern zu können. Entscheide selbst, ob Du dein Profil mit anderen teilen möchtest, oder nicht. Du kannst jederzeit Änderungen vornehmen oder dein Profil löschen.")
            .padding()
        
        Button(text) {
            
            if viewModel.accountStatus != .available {
                accountStatusAlertShown = true
                print("GESCHEITERT")
            } else {
//                dismiss()
                // Create profil if user has a valid iCloud setting
                let create: Bool = createDefaultUser()
                if(create) {
                    text = "Profil angelegt"
                }
                else {
                    count = count + 1
                    text = "\(count) Fehler. Try again."
                }
            }
        }
        .offset(y: UIScreen.main.bounds.height * 0.4)
        .alert("Du brauchst eine Verbindung zu iCloud. Bitte prüfe deine lokalen Account Einstellungen.", isPresented: $accountStatusAlertShown) {
            Button("Ok!", role: .cancel, action: {})
        }
        .task {
            await viewModel.fetchAccountStatus()
        }
    }
    private func createDefaultUser() -> Bool {
        var status: Bool = false
        let randomNum = Int.random(in: 10000...99999)
        let jobArr = ["Deo-Tester", "Glückskeks-Autor", "Notenblatt-Umblätterer", "Kaugummi-Entferner", "Eincreme-Assistent", "Wasserrutschen-Tester", "Puppendoktor", "Golfballtaucher", "Professioneller Ansteher", "Möbil-Probesitzer", "Lebende Schaufensterpuppe", "Lego-Modellbauer", "Pferde-Zahnarzt", "Schlussmacher"]
        let userRegion = ["Ducktales", "Bikini Bottom", "Springfield", "Gotham City", "Smaugs Einöde", "Hogwarts", "Narnia"]
        let userId = UUID()
        let userName = "User-" + String(randomNum)
        
        let cloudUser = User(context: viewContext)
        cloudUser.id = userId
        cloudUser.email = "Keine Email"
        cloudUser.name = userName
        cloudUser.education = "Irgend'ne Schule"
        cloudUser.job = jobArr.randomElement()
        cloudUser.region = userRegion.randomElement()
        cloudUser.shareWithFriends = true
        
        do {
            try viewContext.save()
            status = true
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return status
    }
}

struct ProfilView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilView()
    }
}

extension UUID: RawRepresentable {
    public var rawValue: String {
        self.uuidString
    }

    public typealias RawValue = String

    public init?(rawValue: RawValue) {
        self.init(uuidString: rawValue)
    }
}
