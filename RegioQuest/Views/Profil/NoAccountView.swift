//
//  NoAccountView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 01.12.22.
//

import SwiftUI


struct NoAccountView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    // Account variables
    @StateObject private var viewModel = AccountServiceViewModel()
    @State private var accountStatusAlertShown = false
    @Environment(\.dismiss) var dismiss
    
    @State var text = "Profil anlegen"
    @State var count: Int = 0
    
    var body: some View {
        Text("Lege ein anonymisiertes Profil in deiner iCloud an, um deine Fortschritte speichern zu können. Entscheide selbst, ob Du dein Profil mit anderen teilen möchtest, oder nicht. Du kannst jederzeit Änderungen vornehmen oder dein Profil löschen.")
        
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

//        let localUser = UserLocalData(context: viewContext)
        let cloudUser = User(context: viewContext)
        
        let userId = UUID()
        let randomNum = Int.random(in: 10000...99999)
        let jobArr = ["Deo-Tester", "Glückskeks-Autor", "Notenblatt-Umblätterer", "Kaugummi-Entferner", "Eincreme-Assistent", "Wasserrutschen-Tester", "Puppendoktor", "Golfballtaucher", "Professioneller Ansteher", "Möbil-Probesitzer", "Lebende Schaufensterpuppe", "Lego-Modellbauer", "Pferde-Zahnarzt", "Schlussmacher"]
        let userRegion = ["Ducktales", "Bikini Bottom", "Springfield", "Gotham City", "Smaugs Einöde", "Hogwarts", "Narnia", ]
        cloudUser.id = userId
        cloudUser.email = ""
        cloudUser.name = "User-" + String(randomNum)
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

struct NoAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NoAccountView()
    }
}
