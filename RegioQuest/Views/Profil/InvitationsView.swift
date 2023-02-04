//
//  InvitationsView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 29.01.23.
//

import SwiftUI

struct InvitationsView: View {
    var body: some View {
        Text("Hier würden Anfragen von Unternehmen landen, die an deinem Profil interessiert sind. Diese Unternehmen stellen Quests bereit, daher erhalten sie auch gewisse App-Daten von dir. Dazu gehören z.B. deine Skills, die Du durch das lösen von Quests bewiesen hast.")
            .padding()
    }
}

struct InvitationsView_Previews: PreviewProvider {
    static var previews: some View {
        InvitationsView()
    }
}
