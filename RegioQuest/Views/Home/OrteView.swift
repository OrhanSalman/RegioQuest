//
//  OrteView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 06.12.22.
//

import SwiftUI
import WebKit

struct OrteView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        ZStack {
            StoryboardView()
                .ignoresSafeArea()
            VStack {
                HStack(alignment: .firstTextBaseline) {
                    Image(systemName: "chevron.backward.square")
                        .imageScale(.large)
                        .symbolRenderingMode(.monochrome)
                        .scaleEffect(1.5, anchor: .center)
                        .opacity(0.5)
                        .onTapGesture {
                            withAnimation {
                                viewRouter.currentView = .HomeView
                            }
                        }
                    Spacer()
                }
                .scaleEffect(1, anchor: .center)
                Spacer()
            }
            .padding(25)
            .padding(.vertical, 25)
            .ignoresSafeArea()
        }
    }
}

struct StoryboardView: UIViewControllerRepresentable {
    func makeUIViewController(context content: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "Main")
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}


struct OrteView_Previews: PreviewProvider {
    static var previews: some View {
        OrteView()
            .environmentObject(ViewRouter())
    }
}
