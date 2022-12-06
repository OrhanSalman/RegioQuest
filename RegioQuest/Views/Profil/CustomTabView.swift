//
//  ProfilView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 10.11.22.
//

import SwiftUI


struct CustomTabView: View {
    
    @State var tabIndex = 0
//    @StateObject var inMemoryDataStorage = InMemoryDataStorage()
    
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
                    ProfilView()
//                        .environmentObject(inMemoryDataStorage)
//                        .environment(\.managedObjectContext, coreDataStack.context)
                }
                else if tabIndex == 1 {
                    GiftView()
//                        .environmentObject(inMemoryDataStorage)
//                        .environment(\.managedObjectContext, coreDataStack.context)
                }
                else if tabIndex == 2 {
                    OptionsView()
//                        .environmentObject(inMemoryDataStorage)
//                        .environment(\.managedObjectContext, coreDataStack.context)
                }
            }
            Spacer()
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

struct CustomTabViewPreviews: PreviewProvider {
    static var previews: some View {
        CustomTabView()
    }
}
