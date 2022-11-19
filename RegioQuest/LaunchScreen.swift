//
//  LaunchScreen.swift
//  RegioQuest
//
//  Created by Orhan Salman on 15.11.22.
//

import SwiftUI
import UIKit

struct LaunchScreen: View {
    
    // Local device core data store
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)],
        animation: .default)
    
    private var user: FetchedResults<User>
    
    @State var text: String = "Suche Profil..."
    @State var isAnimating: Bool = true
    @State private var navigate = false
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Image("logo_transparent_background_klei")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(50)
                    .frame(alignment: .top)
                
                ActivityIndicator(isAnimating: $isAnimating, textLabel: $text)
                    .onAppear {
                        if (user.isEmpty) {
                            self.text = "Erstelle neuen default User..."
                            delay()
                            guard createDefaultUser() == "Success" else {
                                self.text = "Default User Fehler"
                                delay()
                                print("__________________________________________")
                                fatalError(text)
                            }
                            self.text = "Du bist startklar ✅"
                            delay()
                            self.isAnimating = false
                            self.navigate = true
                        }
                        else {
                            delay()
                            self.text = "Profildaten laden..."
                            for my in user {
                                let a = " eingeloggt ✅"
                                delay()
                                let b = my.name ?? ""
                                self.text = b + a
                                self.isAnimating = false
                                self.navigate = true
                                
                                print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
                                print("Anzahl gefundener User auf diesem Gerät: \(user.count)")
                                print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
                            }
                        }
                    }
                    .fullScreenCover(isPresented: $navigate) {
                        // Things to do when the screen is dismissed
                    } content: {
                        MainView()
                    }
            }
        }
    }
    
    private func delay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            
        }
    }
    
    private func createDefaultUser() -> String {
        let returnStatus: String
        
        let user = User(context: viewContext)
        
        let randomNum = Int.random(in: 10000...99999)
        let jobArr = ["Deo-Tester", "Glückskeks-Autor", "Notenblatt-Umblätterer", "Kaugummi-Entferner", "Eincreme-Assistent", "Wasserrutschen-Tester", "Puppendoktor", "Golfballtaucher", "Professioneller Ansteher", "Möbil-Probesitzer", "Lebende Schaufensterpuppe", "Lego-Modellbauer", "Pferde-Zahnarzt", "Schlussmacher"]
        let userRegion = ["Ducktales", "Bikini Bottom", "Springfield", "Gotham City", "Smaugs Einöde", "Hogwarts", "Narnia", ]
        
        let userId = UUID()
        
        user.id = userId
        user.email = ""
        user.name = "User-" + String(randomNum)
        user.education = "Irgend'ne Schule"
//        user.image = UIImage(systemName: "turtlerock")?.jpegData(compressionQuality: 0.8)
        user.job = jobArr.randomElement()
        user.region = userRegion.randomElement()
        user.shareWithFriends = true
        let userPreferences = UserPreferences(context: viewContext)
        
        userPreferences.userId = userId
        userPreferences.contactMail = false
        userPreferences.contactPhone = false
        userPreferences.meYou = true
        userPreferences.youMe = false
        
        user.userPreferences = userPreferences
        
        // 1. Save local
        do {
            try viewContext.save()
            returnStatus = "Success"
            return returnStatus
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        // 2. Save in Cloud

    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}

struct ProgressViewStyler: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .padding(4)
            .cornerRadius(4)
    }
}

struct ActivityIndicator: UIViewRepresentable {
    
    @Binding var isAnimating: Bool
    @Binding var textLabel: String
    @State var l = UILabel(frame: CGRect(x: 0, y: 50, width: UIScreen.main.bounds.midX, height: UIScreen.main.bounds.midY))
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let v = UIActivityIndicatorView()
        v.sizeToFit()
        //        l.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(l)
        //        l.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = false
        return v
    }
    
    func updateUIView(_ activityIndicator: UIActivityIndicatorView, context: Context) {
        if isAnimating {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        l.textAlignment = .center
        l.text = textLabel
        l.center = CGPoint(x: activityIndicator.center.x, y: activityIndicator.center.y + 50)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
    }
}

struct Success: View {
    var body: some View {
        Image(systemName: "checkmark.circle")
            .foregroundColor(.green)
    }
}
