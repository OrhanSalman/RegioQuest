//
//  anders2.swift
//  RegioQuest
//
//  Created by Orhan Salman on 07.12.22.
//

import SwiftUI

struct anders2: View {
    @State private var load: Bool = true
    
    var body: some View {
        VStack {
            
            
        }
        .fullScreenCover(isPresented: $load, content: {
            withAnimation {
                ZStack {
                    ProgressView(label: {
                        Text("Laden...")
                            .font(.title3)
                    }).transition(.slide)
                }
            }

        })
    }
}

struct anders2_Previews: PreviewProvider {
    static var previews: some View {
        anders2()
    }
}
