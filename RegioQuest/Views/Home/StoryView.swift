//
//  StoryView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 14.11.22.
//

import SwiftUI

struct StoryView: View {
    
    @State private var addStory: Bool = false
    @State private var presentStory: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                Storyteller()
                    .onTapGesture {
                        presentStory.toggle()
                    }
                    .sheet(isPresented: $presentStory, content: {
                        StorytellerSheet()
                    })
                
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    addStory.toggle()
                } label: {
                    Label("Filter", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $addStory) {
            Text("SHEET")
        }
        
        
    }
}

struct Storyteller: View {
    
    @State private var zeit = Text(Date.now, format: .dateTime.day().month().year().hour().minute())
    
    var body: some View {
        ForEach(1..<10) { i in
            VStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(.systemBackground))
                    .overlay {
                        VStack {
                            HStack {
                                HStack(spacing: 10) {
                                    Text("#\(i) |    \(zeit)")
                                        .font(.footnote.weight(.thin))
                                }
                                Spacer()
                                Image(systemName: "eye.fill")
                                    .imageScale(.medium)
                                    .symbolRenderingMode(.monochrome)
                                    .foregroundColor(.indigo)
                            }
                            Divider()
                                .opacity(1)
                            HStack {
                                ScrollView(.vertical, showsIndicators: true) {
                                    VStack {
                                        Text("Das hier ist eine Erfahrung die ein User mit der App oder ihrem Inhalt gemacht hat. Der User gibt Tipps und Anregungen an andere User weiter. Das hier ist eine Erfahrung die ein User mit der App oder ihrem Inhalt gemacht hat. Der User gibt Tipps und Anregungen an andere User weiter.")
                                            .font(.callout)
                                    }
                                }
                                Spacer()
                            }
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
}

struct StorytellerSheet: View {
    var body: some View {
        VStack {
            Text("StorytellerSheet")
        }
    }
}

struct StoryView_Previews: PreviewProvider {
    static var previews: some View {
        StoryView()
    }
}
