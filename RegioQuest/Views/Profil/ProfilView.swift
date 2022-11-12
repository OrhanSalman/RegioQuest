//
//  ProfilView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 10.11.22.
//

import SwiftUI


struct ProfilView: View {
    
    @State var tabIndex = 0
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    CustomTopTabBar(tabIndex: $tabIndex)
                }
                .padding()
                Divider()
            }
            .padding(10)
            .padding(.horizontal, 40)
            
            VStack {
                if tabIndex == 0 {
                    ContentProfil()
                }
                else if tabIndex == 1 {
                    ContentGift()
                }
                else if tabIndex == 2 {
                    ContentOptions()
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
    
    @EnvironmentObject var modelDataObject: ModelData
    var modelData: [User] {
        modelDataObject.userDataStorage
    }
    
    var skillData: [Skill] {
        modelDataObject.skillDataStorage
    }
    @State private var activeIAm = true
    
    
    var body: some View {
        
        
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(modelData) { data in
                        VStack {
                            PhotoPicker()
                            Spacer(minLength: 10)
                            Text("@\(data.name)")
                            Divider()
                        }
                        .frame(width: 220, height: 220)
                    }
                    NavigationView {
                        List {
                            Section(header: Text("Profil")) {
                                Text("Abschluss")
                                
                                NavigationLink(destination: SkillView()) {
                                    Text("Skill")
                                }
                            }
                            Section(header: Text("Präferenzen")) {
                                Text("Job")
                                Toggle("Aktiv", isOn: $activeIAm)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
        }
    }
}
/*
 struct ContentList: View {
 
 @EnvironmentObject var modelData: ModelData
 
 var body: some View {
 NavigationView {
 List {
 
 Text("Bewerten")
 }
 .navigationTitle("Landmarks")
 }
 }
 }
 */

struct SkillView: View {
    @State private var current = 67.0
    @State private var minValue = 0.0
    @State private var maxValue = 170.0
    var body: some View {
        
        NavigationView {
            List {
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
                
            }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped(), alignment: .center)
            .padding(.top, 20)
    }
}

struct ProfilView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilView()
            .environmentObject(ModelData())
    }
}
