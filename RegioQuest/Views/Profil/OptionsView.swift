//
//  OptionsView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 19.11.22.
//

import SwiftUI

struct OptionsView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 15, style: .continuous)
            .fill(Color(.quaternaryLabel))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .overlay(VStack {
                Text("Nur die App-Einstellungen! Nix mit RegioQuest!")
                Text("Account löschen")
            }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped(), alignment: .center)
            .padding(.top, 20)
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView()
    }
}
