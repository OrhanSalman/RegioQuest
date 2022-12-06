//
//  StoryView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 14.11.22.
//

import SwiftUI

struct StoryView: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.systemBackground))
                .overlay {
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "info.square.fill")
                                .imageScale(.medium)
                                .symbolRenderingMode(.monochrome)
                                .foregroundColor(.indigo)
                        }
                        Divider()
                            .opacity(1)
                        Spacer()
                        HStack {
                            Text("@Storyteller")
                                .font(.subheadline.weight(.thin))
                            Spacer()
                        }
                    }
                    .padding()
                }
                .frame(height: 200)
                .clipped()
                .shadow(color: .primary.opacity(0.5), radius: 14, x: 0, y: 14)
                .padding(20)
            
        }
    }
}

struct StoryView_Previews: PreviewProvider {
    static var previews: some View {
        StoryView()
    }
}
