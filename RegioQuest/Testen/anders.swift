//
//  anders.swift
//  RegioQuest
//
//  Created by Orhan Salman on 07.12.22.
//

import SwiftUI

struct anders: View {
    var body: some View {
        
        NavigationStack {
            List {
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
            }

        }
    }
}

struct anders_Previews: PreviewProvider {
    static var previews: some View {
        anders()
    }
}
