//
//  KarteView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 06.12.22.
//

import SwiftUI

struct KarteView: View {
    var body: some View {
        VStack {
            LinearGradient(gradient: Gradient(colors: [.black.opacity(0.75), .indigo, .indigo]), startPoint: .top, endPoint: .bottom)
        }
        .ignoresSafeArea()
    }
}

struct KarteView_Previews: PreviewProvider {
    static var previews: some View {
        KarteView()
            
    }
}
