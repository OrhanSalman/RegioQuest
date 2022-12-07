//
//  ViewRouter.swift
//  RegioQuest
//
//  Created by Orhan Salman on 07.12.22.
//

import SwiftUI

enum Pages {
    case HomeView
    case OrteView
}

class ViewRouter: ObservableObject {
    @Published var currentView: Pages = .HomeView
}

/*
struct NavigationController: View {
    
    @StateObject var controller: viewControl
    
    var body: some View {
        
        switch controller.currentView {
        case .HomeView:
            HomeView(controller: controller)
        case .OrteView:
            OrteView(controller: controller)
        case .MapBoard:
            MapBoard(controller: controller)
        }
    }
}
*/

