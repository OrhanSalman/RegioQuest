//
//  LaunchScreen.swift
//  RegioQuest
//
//  Created by Orhan Salman on 15.11.22.
//
/*
import SwiftUI
import UIKit

struct LaunchScreen: View {
    
    // Local device core data store
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)],
        animation: .default) private var user: FetchedResults<User>
 
    @State var text: String = "Suche Profil..."
    @State var isAnimating: Bool = true
    @State private var navigate = false
    
 //   @State var mach: LocalViewModel
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Image("logo_transparent_background_klei")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(50)
                    .frame(alignment: .top)
                
 
                /*
                ActivityIndicator(isAnimating: $isAnimating, textLabel: $text)
                    .onAppear {
                        while(user.isEmpty) {
                            self.text = "Leer"
                        }
                        if(!user.isEmpty) {
                            self.text = "Hab gefunden!"
                            
                        }
                    }
*/
                
                ActivityIndicator(isAnimating: $isAnimating, textLabel: $text)
                /*
                    .onAppear {
                        
                        if (user.isEmpty) {     // if it's the first time the user has installed this app
                            self.text = "Erstelle neuen default User..."
                            guard createDefaultUser() == "Success" else {
                                self.text = "Default User Fehler"
                                fatalError(text)
                            }
                            self.text = "Du bist startklar ✅"
//                            self.isAnimating = false
                            self.navigate = true
                        }
                        else {
                            self.text = "Profildaten laden..."
                            for my in user {
                                let a = " eingeloggt ✅"
                                let b = my.name ?? ""
                                self.text = b + a
                                self.text = a
//                                self.isAnimating = false
                                self.navigate = true
                            }
                        }
                        
                    }
                 */
//                    .fullScreenCover(isPresented: $navigate, content: MainView.init)
                
            }
        }
        .onAppear {
                Task {
                    await onboarding()
                }
        }
    }
    
    private func myUserFunc() async -> FetchedResults<User> {
        viewContext.performAndWait {
            @FetchRequest(
                sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)],
                animation: .default) var users: FetchedResults<User>

            return users
        }
    }
    
    
    func onboarding() async {
        if (self.user.isEmpty) {     // if it's the first time the user has installed this app
            self.text = "Kein Profil gefunden. Erstelle neuen default User..."
            guard createDefaultUser() == "Success" else {
                self.text = "Default User Fehler"
                fatalError(text)
            }
            self.text = "Du bist startklar ✅"
//                            self.isAnimating = false
            self.navigate = true
        }
        else {
            self.text = "Profildaten laden..."
            for my in self.user {
                let a = " eingeloggt ✅"
                let b = my.name ?? ""
                self.text = b + a
                self.text = a
//                                self.isAnimating = false
                self.navigate = true
            }
        }
    }
    

    private func createDefaultUser() -> String {
        let returnStatus: String

//        let localUser = UserLocalData(context: viewContext)
        let cloudUser = User(context: viewContext)
        
        let userId = UUID()
        let randomNum = Int.random(in: 10000...99999)
        let jobArr = ["Deo-Tester", "Glückskeks-Autor", "Notenblatt-Umblätterer", "Kaugummi-Entferner", "Eincreme-Assistent", "Wasserrutschen-Tester", "Puppendoktor", "Golfballtaucher", "Professioneller Ansteher", "Möbil-Probesitzer", "Lebende Schaufensterpuppe", "Lego-Modellbauer", "Pferde-Zahnarzt", "Schlussmacher"]
        let userRegion = ["Ducktales", "Bikini Bottom", "Springfield", "Gotham City", "Smaugs Einöde", "Hogwarts", "Narnia", ]
        
        
//        localUser.id = userId
//        localUser.latitude = 0.0
//        localUser.longitude = 0.0

        cloudUser.id = userId
        cloudUser.email = ""
        cloudUser.name = "User-" + String(randomNum)
        cloudUser.education = "Irgend'ne Schule"
        cloudUser.job = jobArr.randomElement()
        cloudUser.region = userRegion.randomElement()
        cloudUser.shareWithFriends = true
        
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


extension UUID: RawRepresentable {
    public var rawValue: String {
        self.uuidString
    }

    public typealias RawValue = String

    public init?(rawValue: RawValue) {
        self.init(uuidString: rawValue)
    }
}

*/
