//
//  ProfilView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 10.11.22.
//

import SwiftUI


struct ProfilView: View {
    
    @State var tabIndex = 0
    private let coreDataStack = CoreDataStack.shared
    
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    CustomTopTabBar(tabIndex: $tabIndex)
                }
                Divider()
            }
            .padding(.top, 25)
            .padding(.horizontal, 70)
            
            VStack {
                if tabIndex == 0 {
                    ContentProfil()
                        .environment(\.managedObjectContext, coreDataStack.context)
                }
                else if tabIndex == 1 {
                    ContentGift()
                        .environment(\.managedObjectContext, coreDataStack.context)
                }
                else if tabIndex == 2 {
                    ContentOptions()
                        .environment(\.managedObjectContext, coreDataStack.context)
                }
            }
        }
    }
}

struct CustomTopTabBar: View {
    @Binding var tabIndex: Int
    var body: some View {
        TabBarButton(systemName: "person.fill", isSelected: .constant(tabIndex == 0))
            .onTapGesture { onButtonTapped(index: 0) }
        Spacer()
        TabBarButton(systemName: "gift.fill", isSelected: .constant(tabIndex == 1))
            .onTapGesture { onButtonTapped(index: 1) }
        Spacer()
        TabBarButton(systemName: "gearshape.fill", isSelected: .constant(tabIndex == 2))
            .onTapGesture { onButtonTapped(index: 2) }
    }
    
    private func onButtonTapped(index: Int) {
        withAnimation { tabIndex = index }
    }
}


struct TabBarButton: View {
    let systemName: String
    @Binding var isSelected: Bool
    var body: some View {
        Image(systemName: systemName)
            .imageScale(.large)
            .foregroundColor(isSelected ?  .blue : .primary)
    }
}

struct EdgeBorder: Shape {
    
    var width: CGFloat
    var edges: [Edge]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }
            
            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }
            
            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return self.width
                }
            }
            
            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: SwiftUI.Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct ContentProfil: View {
    /*
    @EnvironmentObject var modelDataObject: ModelData
    var modelData: [User] {
        modelDataObject.userDataStorage
    }
    var skillData: [Skill] {
        modelDataObject.skillDataStorage
    }
    */
    
    @State private var openForJobs = true
    @State private var contactMyMail = true
    @State private var contactMyPhone = true
    
    enum ContactOption: String, CaseIterable, Identifiable {
        case youMe, meYou
        var id: Self { self }
    }

    @State private var selectedContactOption: ContactOption = .youMe
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)],
        animation: .default)
    private var user: FetchedResults<User>
    
    
    var body: some View {
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
    // ToDo
    func toggler() {
        switch self.selectedContactOption {
        case .meYou:
            contactMyMail = false
            contactMyPhone = false
        case .youMe:
            contactMyMail = true
            contactMyPhone = true
        }
    }
}


struct SkillView: View {
    // ToDo

    
    /*
    @EnvironmentObject var modelDataObject: ModelData
    var modelData: [User] {
        modelDataObject.userDataStorage
    }
    */
    
    @State private var current = 67.0
    @State private var minValue = 0.0
    @State private var maxValue = 170.0
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: true) {
            ForEach(1..<11) { index in
                Gauge(value: current, in: minValue...maxValue) {
                    Text("BPM")
                } currentValueLabel: {
                    Text("\(Int(current))")
                } minimumValueLabel: {
                    Text("\(Int(minValue))")
                } maximumValueLabel: {
                    Text("\(Int(maxValue))")
                }
            }
        }
    }
}

struct ContentGift: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 15, style: .continuous)
            .fill(Color(.quaternaryLabel))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .overlay(VStack {
                
            }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped(), alignment: .center)
            .padding(.top, 20)
    }
}

struct ContentOptions: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 15, style: .continuous)
            .fill(Color(.quaternaryLabel))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .overlay(VStack {
                Text("Nur die App-Einstellungen! Nix mit RegioQuest!")
                Text("Account löschen")
            }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped(), alignment: .center)
            .padding(.top, 20)
    }
}

struct ProfilView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilView()
//            .environmentObject(ModelData())
    }
}
