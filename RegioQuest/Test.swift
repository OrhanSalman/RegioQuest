//
//  Test.swift
//  RegioQuest
//
//  Created by Orhan Salman on 17.12.22.
//

import SwiftUI

struct Test: View {
    @State var text: String = ""
    @State var booler: Bool = false
    
    var body: some View {
        VStack {
            Text(text)
            Button("Klick", action: {
                booler.toggle()
                Task {
                    await mach()
                }
                
            })
        }
    }
    
    func mach() async {
        if booler {
            text = "Ja"
        }
        else if !booler {
            text = "Nein"
        }
        else {
            text = "Nix"
        }
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
