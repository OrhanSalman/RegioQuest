//
//  NoAccountView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 01.12.22.
//

import SwiftUI


struct NoAccountView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var text = "Profil anlegen"
    @State var count: Int = 0
    var body: some View {
        Text("Erstelle dir ein default Profil, damit Du die vollen Funktionalitäten nutzen kannst. Du kannst deine Daten jederzeit ändern, oder sie komplett löschen.")
        Button(text) {
            var create: Bool = createDefaultUser()
            if(create) {
                text = "Jawohl!"
            }
            else {
                count = count + 1
                text = "\(count) Fehler. Try again."
            }
        }
        .offset(y: UIScreen.main.bounds.height * 0.4)
        
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
