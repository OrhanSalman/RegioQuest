//
//  DelayTest.swift
//  RegioQuest
//
//  Created by Orhan Salman on 31.01.23.
//

import SwiftUI

struct DelayTest: View {
    @State private var count = 5
    @State private var text = "Ende"
    @State private var showText = false
    
    var body: some View {
        VStack {
            if showText {
                HStack {
                    Spacer()
                    Text("\(text)")
                        .font(.largeTitle)
                        .padding(.trailing)
                }
                Spacer()
            }
            else {
                HStack {
                    Spacer()
                    Text("\(count)")
                        .font(.largeTitle)
                        .padding(.trailing)
                }
                Spacer()
            }
        }.onAppear {
            if !showText {
                Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
                    self.count -= 1
                    
                    switch count {
                    case 0:
                        showText.toggle()
                    default:
                        break
                    }
                }
            }
        }
    }
}


struct DelayTest_Previews: PreviewProvider {
    static var previews: some View {
        DelayTest()
    }
}
